Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B51266580DC
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:22:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234630AbiL1QVb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:21:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234694AbiL1QVA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:21:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92C7018E26
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:18:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1FD3A61562
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:18:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38357C433EF;
        Wed, 28 Dec 2022 16:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244337;
        bh=fwhFxxvXnqFyPT2/I2aY9/UYDUYC5DB50CIjnBxweYs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bMx8K2L4/OO3Zg2oHLSSUnNnSqm7fUQjwjLjwJeaEs5a6LHxv0BYeaDK5EhkSSL9E
         YU1sHubW1yCMloenfCcwKghnR6onOzYJ6VCurPoWhH5nJOmKhdgkENtAFyjFOJkrQz
         u+sBS8go9+zQbgFUOhIzW/rXXA6Gg6AF/EZH3rtA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shang XiaoJing <shangxiaojing@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0653/1146] scsi: ipr: Fix WARNING in ipr_init()
Date:   Wed, 28 Dec 2022 15:36:32 +0100
Message-Id: <20221228144347.894997155@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shang XiaoJing <shangxiaojing@huawei.com>

[ Upstream commit e6f108bffc3708ddcff72324f7d40dfcd0204894 ]

ipr_init() will not call unregister_reboot_notifier() when
pci_register_driver() fails, which causes a WARNING. Call
unregister_reboot_notifier() when pci_register_driver() fails.

notifier callback ipr_halt [ipr] already registered
WARNING: CPU: 3 PID: 299 at kernel/notifier.c:29
notifier_chain_register+0x16d/0x230
Modules linked in: ipr(+) xhci_pci_renesas xhci_hcd ehci_hcd usbcore
led_class gpu_sched drm_buddy video wmi drm_ttm_helper ttm
drm_display_helper drm_kms_helper drm drm_panel_orientation_quirks
agpgart cfbft
CPU: 3 PID: 299 Comm: modprobe Tainted: G        W
6.1.0-rc1-00190-g39508d23b672-dirty #332
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.15.0-0-g2dd4b9b3f840-prebuilt.qemu.org 04/01/2014
RIP: 0010:notifier_chain_register+0x16d/0x230
Call Trace:
 <TASK>
 __blocking_notifier_chain_register+0x73/0xb0
 ipr_init+0x30/0x1000 [ipr]
 do_one_initcall+0xdb/0x480
 do_init_module+0x1cf/0x680
 load_module+0x6a50/0x70a0
 __do_sys_finit_module+0x12f/0x1c0
 do_syscall_64+0x3f/0x90
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Fixes: f72919ec2bbb ("[SCSI] ipr: implement shutdown changes and remove obsolete write cache parameter")
Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
Link: https://lore.kernel.org/r/20221113064513.14028-1-shangxiaojing@huawei.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ipr.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 9d01a3e3c26a..2022ffb45041 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -10872,11 +10872,19 @@ static struct notifier_block ipr_notifier = {
  **/
 static int __init ipr_init(void)
 {
+	int rc;
+
 	ipr_info("IBM Power RAID SCSI Device Driver version: %s %s\n",
 		 IPR_DRIVER_VERSION, IPR_DRIVER_DATE);
 
 	register_reboot_notifier(&ipr_notifier);
-	return pci_register_driver(&ipr_driver);
+	rc = pci_register_driver(&ipr_driver);
+	if (rc) {
+		unregister_reboot_notifier(&ipr_notifier);
+		return rc;
+	}
+
+	return 0;
 }
 
 /**
-- 
2.35.1



