Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90F2059E299
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244593AbiHWMSb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 08:18:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359618AbiHWMQE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 08:16:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A09D4C613;
        Tue, 23 Aug 2022 02:41:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 480D46138B;
        Tue, 23 Aug 2022 09:41:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 490D4C433D6;
        Tue, 23 Aug 2022 09:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661247686;
        bh=9oSHigocV2XvvM+6VuFD2ZFWpYY21AKOJNsjAjIvVtg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tl8eJlPRxAyRBuLT2P283EjHaGEhiQUVN0fFZi/RTBwJYjkPbK+sV7w5CEMLzQnsO
         KfSQO/wupi9pHRtVe7SLnt5vFemp0IkfkZ3t7B1tZS4I/V9hlww9O96GogJkI2v3kW
         alUu3DkCpaeq9OxUEeYMUe68FQQsi5ZU5WR8+DSg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 115/158] zram: do not lookup algorithm in backends table
Date:   Tue, 23 Aug 2022 10:27:27 +0200
Message-Id: <20220823080050.586763796@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080046.056825146@linuxfoundation.org>
References: <20220823080046.056825146@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 33e3b76c4fa9..b08650417bf0 100644
--- a/drivers/block/zram/zcomp.c
+++ b/drivers/block/zram/zcomp.c
@@ -61,12 +61,6 @@ static int zcomp_strm_init(struct zcomp_strm *zstrm, struct zcomp *comp)
 
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
@@ -215,6 +209,11 @@ struct zcomp *zcomp_create(const char *compress)
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



