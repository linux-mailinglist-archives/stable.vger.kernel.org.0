Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1FF592173
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 17:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240881AbiHNPg6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 11:36:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240993AbiHNPgE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 11:36:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29E331DA47;
        Sun, 14 Aug 2022 08:31:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4414AB80B27;
        Sun, 14 Aug 2022 15:31:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CBA5C43144;
        Sun, 14 Aug 2022 15:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660491082;
        bh=g8DqRUnEJ1CxvVsgj9EkQ/vTlZZXVk/+ZnUNVFzMwU4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FRbTuRE9qwfGao0mpqiiLUSiEzsjMgDeILIokj9wXYlrWfr/wZKO4L+WiLV0ObHFp
         lBj2rY8KGh0fn4DtiYYIegOrSie3oUvX0BucPxptb27ivn3Qiq9x3BnbZZNzbCIDUs
         XbpT5U0e911ftv6cY8R0ofZ+kFsewUjqeqeqxGcFbM/IlGR/C1Ztuj+t4mC8aRwKao
         V0k1sWiAcsJqaam9Am37pEoJAEwMSA1W4XIp1eV+9EZ8cxlj0F/oDVq5lgPGF51LLg
         O4xWVqKdNd3VuGoMTKv3ynfqB4ieDbAA4FQpnwy8JE9YaX1Ky+Pq/V0gIHAB4R0Jms
         gRKcM4KuBtbdA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sergey Senozhatsky <senozhatsky@chromium.org>,
        Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, axboe@kernel.dk,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 23/56] zram: do not lookup algorithm in backends table
Date:   Sun, 14 Aug 2022 11:29:53 -0400
Message-Id: <20220814153026.2377377-23-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814153026.2377377-1-sashal@kernel.org>
References: <20220814153026.2377377-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergey Senozhatsky <senozhatsky@chromium.org>

[ Upstream commit dc89997264de565999a1cb55db3f295d3a8e457b ]

Always use crypto_has_comp() so that crypto can lookup module, call
usermodhelper to load the modules, wait for usermodhelper to finish and so
on.  Otherwise crypto will do all of these steps under CPU hot-plug lock
and this looks like too much stuff to handle under the CPU hot-plug lock.
Besides this can end up in a deadlock when usermodhelper triggers a code
path that attempts to lock the CPU hot-plug lock, that zram already holds.

An example of such deadlock:

- path A. zram grabs CPU hot-plug lock, execs /sbin/modprobe from crypto
  and waits for modprobe to finish

disksize_store
 zcomp_create
  __cpuhp_state_add_instance
   __cpuhp_state_add_instance_cpuslocked
    zcomp_cpu_up_prepare
     crypto_alloc_base
      crypto_alg_mod_lookup
       call_usermodehelper_exec
        wait_for_completion_killable
         do_wait_for_common
          schedule

- path B. async work kthread that brings in scsi device. It wants to
  register CPUHP states at some point, and it needs the CPU hot-plug
  lock for that, which is owned by zram.

async_run_entry_fn
 scsi_probe_and_add_lun
  scsi_mq_alloc_queue
   blk_mq_init_queue
    blk_mq_init_allocated_queue
     blk_mq_realloc_hw_ctxs
      __cpuhp_state_add_instance
       __cpuhp_state_add_instance_cpuslocked
        mutex_lock
         schedule

- path C. modprobe sleeps, waiting for all aync works to finish.

load_module
 do_init_module
  async_synchronize_full
   async_synchronize_cookie_domain
    schedule

[senozhatsky@chromium.org: add comment]
  Link: https://lkml.kernel.org/r/20220624060606.1014474-1-senozhatsky@chromium.org
Link: https://lkml.kernel.org/r/20220622023501.517125-1-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/zram/zcomp.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/block/zram/zcomp.c b/drivers/block/zram/zcomp.c
index 052aa3f65514..0916de952e09 100644
--- a/drivers/block/zram/zcomp.c
+++ b/drivers/block/zram/zcomp.c
@@ -63,12 +63,6 @@ static int zcomp_strm_init(struct zcomp_strm *zstrm, struct zcomp *comp)
 
 bool zcomp_available_algorithm(const char *comp)
 {
-	int i;
-
-	i = sysfs_match_string(backends, comp);
-	if (i >= 0)
-		return true;
-
 	/*
 	 * Crypto does not ignore a trailing new line symbol,
 	 * so make sure you don't supply a string containing
@@ -217,6 +211,11 @@ struct zcomp *zcomp_create(const char *compress)
 	struct zcomp *comp;
 	int error;
 
+	/*
+	 * Crypto API will execute /sbin/modprobe if the compression module
+	 * is not loaded yet. We must do it here, otherwise we are about to
+	 * call /sbin/modprobe under CPU hot-plug lock.
+	 */
 	if (!zcomp_available_algorithm(compress))
 		return ERR_PTR(-EINVAL);
 
-- 
2.35.1

