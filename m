Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A55666B42DA
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:08:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230514AbjCJOIB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:08:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231791AbjCJOHn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:07:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A49211A2CC
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:07:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D42BBB822BB
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:07:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18542C4339B;
        Fri, 10 Mar 2023 14:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678457226;
        bh=VnPJPX8u6PzYEvPCEKx44H/8+7RQBSRycCUW8IiM29o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EnFqqIcC92VnATlfaEQVd23nPjCCuOQaFZLoaLgP2hXL/rKbhm/PCpEAiZt8T/5zM
         rKMroAhB/j5iRKtg0ceWeUOV3jOr8LJXGlAWUMVilr7r/9XQnBdav1iKIxmbpHcGbR
         yJzSE3GlcjgXwfsHRHyMSFIlD2YSHAgB4K+9+qG0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Li Zetao <lizetao1@huawei.com>,
        Zhihao Cheng <chengzhihao1@huawei.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 032/200] ubi: Fix use-after-free when volume resizing failed
Date:   Fri, 10 Mar 2023 14:37:19 +0100
Message-Id: <20230310133718.034088995@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Zetao <lizetao1@huawei.com>

[ Upstream commit 9af31d6ec1a4be4caab2550096c6bd2ba8fba472 ]

There is an use-after-free problem reported by KASAN:
  ==================================================================
  BUG: KASAN: use-after-free in ubi_eba_copy_table+0x11f/0x1c0 [ubi]
  Read of size 8 at addr ffff888101eec008 by task ubirsvol/4735

  CPU: 2 PID: 4735 Comm: ubirsvol
  Not tainted 6.1.0-rc1-00003-g84fa3304a7fc-dirty #14
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
  BIOS 1.14.0-1.fc33 04/01/2014
  Call Trace:
   <TASK>
   dump_stack_lvl+0x34/0x44
   print_report+0x171/0x472
   kasan_report+0xad/0x130
   ubi_eba_copy_table+0x11f/0x1c0 [ubi]
   ubi_resize_volume+0x4f9/0xbc0 [ubi]
   ubi_cdev_ioctl+0x701/0x1850 [ubi]
   __x64_sys_ioctl+0x11d/0x170
   do_syscall_64+0x35/0x80
   entry_SYSCALL_64_after_hwframe+0x46/0xb0
   </TASK>

When ubi_change_vtbl_record() returns an error in ubi_resize_volume(),
"new_eba_tbl" will be freed on error handing path, but it is holded
by "vol->eba_tbl" in ubi_eba_replace_table(). It means that the liftcycle
of "vol->eba_tbl" and "vol" are different, so when resizing volume in
next time, it causing an use-after-free fault.

Fix it by not freeing "new_eba_tbl" after it replaced in
ubi_eba_replace_table(), while will be freed in next volume resizing.

Fixes: 801c135ce73d ("UBI: Unsorted Block Images")
Signed-off-by: Li Zetao <lizetao1@huawei.com>
Reviewed-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/ubi/vmt.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/ubi/vmt.c b/drivers/mtd/ubi/vmt.c
index 8fcc0bdf06358..74637575346e8 100644
--- a/drivers/mtd/ubi/vmt.c
+++ b/drivers/mtd/ubi/vmt.c
@@ -464,7 +464,7 @@ int ubi_resize_volume(struct ubi_volume_desc *desc, int reserved_pebs)
 		for (i = 0; i < -pebs; i++) {
 			err = ubi_eba_unmap_leb(ubi, vol, reserved_pebs + i);
 			if (err)
-				goto out_acc;
+				goto out_free;
 		}
 		spin_lock(&ubi->volumes_lock);
 		ubi->rsvd_pebs += pebs;
@@ -512,6 +512,8 @@ int ubi_resize_volume(struct ubi_volume_desc *desc, int reserved_pebs)
 		ubi->avail_pebs += pebs;
 		spin_unlock(&ubi->volumes_lock);
 	}
+	return err;
+
 out_free:
 	kfree(new_eba_tbl);
 	return err;
-- 
2.39.2



