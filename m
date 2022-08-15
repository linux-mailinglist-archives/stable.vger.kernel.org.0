Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CDA35947C8
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:04:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245103AbiHOXR0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:17:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353366AbiHOXQV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:16:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D86B914743C;
        Mon, 15 Aug 2022 13:03:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C1255612D8;
        Mon, 15 Aug 2022 20:03:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4829C433D6;
        Mon, 15 Aug 2022 20:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593787;
        bh=9Pf3I5L9YkcRINMhHJWI5bH6f4UjHn55TDvvn+Jqi+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lWhdNPTKnz1nXMq4w1pOAwymlC6FAxTEJjBrXHFL/fb+ZIFYDeXsu0j2nOooaLMLr
         2RFiwr6jqi7ZsmUdIhutqDlFf9h3jKEDEieMJ6BrAd1Z/TR4QWCOWTZVftt7viozw4
         APzSPR7UsGa4Kj3o8aGu94BL4fGsYDjS0wXTQYcs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Luo Meng <luomeng12@huawei.com>,
        Mike Snitzer <snitzer@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 1006/1095] dm thin: fix use-after-free crash in dm_sm_register_threshold_callback
Date:   Mon, 15 Aug 2022 20:06:45 +0200
Message-Id: <20220815180510.712920490@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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
index 2db7030aba00..a27395c8621f 100644
--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -2045,10 +2045,13 @@ int dm_pool_register_metadata_threshold(struct dm_pool_metadata *pmd,
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
index 4d25d0e27031..53ac6ae870ac 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -3382,8 +3382,10 @@ static int pool_ctr(struct dm_target *ti, unsigned argc, char **argv)
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



