Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9593459A3BF
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 20:04:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353787AbiHSQq3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:46:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353902AbiHSQp1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:45:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B91F128EC5;
        Fri, 19 Aug 2022 09:11:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 110FF612DF;
        Fri, 19 Aug 2022 16:10:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03B7EC433C1;
        Fri, 19 Aug 2022 16:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925437;
        bh=PMsee/xeDl2L2ooNnHy0RE8rDd2txj4pw7WYdLJn8S0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0QL3I+uMJXEEWB+QiTbJm7sdgD8aT2uuc/h3THMKFzqA70yaCWbAJttoL/82Tdhtl
         Yvvu3+biT5cRYe4zEegDfUrIdbzn8m1QcVJVR08bI6Lz/3uQVfrzX+ySr239cj1NG8
         Ws/FnrYCT5C5D9uhXMB/wfvOYP8WrjpZz/9oVtl8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Luo Meng <luomeng12@huawei.com>,
        Mike Snitzer <snitzer@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 490/545] dm thin: fix use-after-free crash in dm_sm_register_threshold_callback
Date:   Fri, 19 Aug 2022 17:44:20 +0200
Message-Id: <20220819153851.377811572@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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

From: Luo Meng <luomeng12@huawei.com>

[ Upstream commit 3534e5a5ed2997ca1b00f44a0378a075bd05e8a3 ]

Fault inject on pool metadata device reports:
  BUG: KASAN: use-after-free in dm_pool_register_metadata_threshold+0x40/0x80
  Read of size 8 at addr ffff8881b9d50068 by task dmsetup/950

  CPU: 7 PID: 950 Comm: dmsetup Tainted: G        W         5.19.0-rc6 #1
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-1.fc33 04/01/2014
  Call Trace:
   <TASK>
   dump_stack_lvl+0x34/0x44
   print_address_description.constprop.0.cold+0xeb/0x3f4
   kasan_report.cold+0xe6/0x147
   dm_pool_register_metadata_threshold+0x40/0x80
   pool_ctr+0xa0a/0x1150
   dm_table_add_target+0x2c8/0x640
   table_load+0x1fd/0x430
   ctl_ioctl+0x2c4/0x5a0
   dm_ctl_ioctl+0xa/0x10
   __x64_sys_ioctl+0xb3/0xd0
   do_syscall_64+0x35/0x80
   entry_SYSCALL_64_after_hwframe+0x46/0xb0

This can be easily reproduced using:
  echo offline > /sys/block/sda/device/state
  dd if=/dev/zero of=/dev/mapper/thin bs=4k count=10
  dmsetup load pool --table "0 20971520 thin-pool /dev/sda /dev/sdb 128 0 0"

If a metadata commit fails, the transaction will be aborted and the
metadata space maps will be destroyed. If a DM table reload then
happens for this failed thin-pool, a use-after-free will occur in
dm_sm_register_threshold_callback (called from
dm_pool_register_metadata_threshold).

Fix this by in dm_pool_register_metadata_threshold() by returning the
-EINVAL error if the thin-pool is in fail mode. Also fail pool_ctr()
with a new error message: "Error registering metadata threshold".

Fixes: ac8c3f3df65e4 ("dm thin: generate event when metadata threshold passed")
Cc: stable@vger.kernel.org
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Luo Meng <luomeng12@huawei.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-thin-metadata.c | 7 +++++--
 drivers/md/dm-thin.c          | 4 +++-
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
index 6ebb2127f3e2..842d79e5ea3a 100644
--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -2058,10 +2058,13 @@ int dm_pool_register_metadata_threshold(struct dm_pool_metadata *pmd,
 					dm_sm_threshold_fn fn,
 					void *context)
 {
-	int r;
+	int r = -EINVAL;
 
 	pmd_write_lock_in_core(pmd);
-	r = dm_sm_register_threshold_callback(pmd->metadata_sm, threshold, fn, context);
+	if (!pmd->fail_io) {
+		r = dm_sm_register_threshold_callback(pmd->metadata_sm,
+						      threshold, fn, context);
+	}
 	pmd_write_unlock(pmd);
 
 	return r;
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index fff4c50df74d..a196d7cb51bd 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -3401,8 +3401,10 @@ static int pool_ctr(struct dm_target *ti, unsigned argc, char **argv)
 						calc_metadata_threshold(pt),
 						metadata_low_callback,
 						pool);
-	if (r)
+	if (r) {
+		ti->error = "Error registering metadata threshold";
 		goto out_flags_changed;
+	}
 
 	dm_pool_register_pre_commit_callback(pool->pmd,
 					     metadata_pre_commit_callback, pool);
-- 
2.35.1



