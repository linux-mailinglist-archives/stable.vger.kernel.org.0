Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1B212C73BA
	for <lists+stable@lfdr.de>; Sat, 28 Nov 2020 23:15:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731716AbgK1Vty (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 Nov 2020 16:49:54 -0500
Received: from mail-m1272.qiye.163.com ([115.236.127.2]:27661 "EHLO
        mail-m1272.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387565AbgK1The (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 28 Nov 2020 14:37:34 -0500
X-Greylist: delayed 4199 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 Nov 2020 14:37:33 EST
Received: from localhost.localdomain (unknown [113.89.246.41])
        by mail-m1272.qiye.163.com (Hmail) with ESMTPA id AEEC6B01F56;
        Sat, 28 Nov 2020 20:27:49 +0800 (CST)
From:   Ding Hui <dinghui@sangfor.com.cn>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ding Hui <dinghui@sangfor.com.cn>,
        stable <stable@vger.kernel.org>
Subject: [PATCH] scsi: ses: Fix crash caused by kfree an invalid pointer
Date:   Sat, 28 Nov 2020 20:23:02 +0800
Message-Id: <20201128122302.9490-1-dinghui@sangfor.com.cn>
X-Mailer: git-send-email 2.17.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSE83V1ktWUFJV1kPCR
        oVCBIfWUFZHx5DTU9NTB0eGk1PVkpNS01OTU1PTUJCQkJVEwETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKTFVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PzY6Qzo5MT8tTk4wSkMUNwxO
        IUxPCilVSlVKTUtNTk1NT0xLSE9JVTMWGhIXVR8SFRwTDhI7CBoVHB0UCVUYFBZVGBVFWVdZEgtZ
        QVlKSkhVQ0JVSU9NVU9KWVdZCAFZQUhCTEs3Bg++
X-HM-Tid: 0a760ed2e10598b7kuuuaeec6b01f56
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We can get a crash when disconnecting the iSCSI session,
the call trace like this:

  [ffff00002a00fb70] kfree at ffff00000830e224
  [ffff00002a00fba0] ses_intf_remove at ffff000001f200e4
  [ffff00002a00fbd0] device_del at ffff0000086b6a98
  [ffff00002a00fc50] device_unregister at ffff0000086b6d58
  [ffff00002a00fc70] __scsi_remove_device at ffff00000870608c
  [ffff00002a00fca0] scsi_remove_device at ffff000008706134
  [ffff00002a00fcc0] __scsi_remove_target at ffff0000087062e4
  [ffff00002a00fd10] scsi_remove_target at ffff0000087064c0
  [ffff00002a00fd70] __iscsi_unbind_session at ffff000001c872c4
  [ffff00002a00fdb0] process_one_work at ffff00000810f35c
  [ffff00002a00fe00] worker_thread at ffff00000810f648
  [ffff00002a00fe70] kthread at ffff000008116e98

In ses_intf_add, components count could be 0, and kcalloc 0 size scomp,
but not saved in edev->component[i].scratch

In this situation, edev->component[0].scratch is an invalid pointer,
when kfree it in ses_intf_remove_enclosure, a crash like above would happen
The call trace also could be other random cases when kfree cannot catch
the invalid pointer

We should not use edev->component[] array when the components count is 0
We also need check index when use edev->component[] array in
ses_enclosure_data_process

Tested-by: Zeng Zhicong <timmyzeng@163.com>
Cc: stable <stable@vger.kernel.org> # 2.6.25+
Signed-off-by: Ding Hui <dinghui@sangfor.com.cn>
---
 drivers/scsi/ses.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index c2afba2a5414..f5ef0a91f0eb 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -477,9 +477,6 @@ static int ses_enclosure_find_by_addr(struct enclosure_device *edev,
 	int i;
 	struct ses_component *scomp;
 
-	if (!edev->component[0].scratch)
-		return 0;
-
 	for (i = 0; i < edev->components; i++) {
 		scomp = edev->component[i].scratch;
 		if (scomp->addr != efd->addr)
@@ -565,8 +562,10 @@ static void ses_enclosure_data_process(struct enclosure_device *edev,
 						components++,
 						type_ptr[0],
 						name);
-				else
+				else if (components < edev->components)
 					ecomp = &edev->component[components++];
+				else
+					ecomp = ERR_PTR(-EINVAL);
 
 				if (!IS_ERR(ecomp)) {
 					if (addl_desc_ptr)
@@ -731,9 +730,11 @@ static int ses_intf_add(struct device *cdev,
 		buf = NULL;
 	}
 page2_not_supported:
-	scomp = kcalloc(components, sizeof(struct ses_component), GFP_KERNEL);
-	if (!scomp)
-		goto err_free;
+	if (components > 0) {
+		scomp = kcalloc(components, sizeof(struct ses_component), GFP_KERNEL);
+		if (!scomp)
+			goto err_free;
+	}
 
 	edev = enclosure_register(cdev->parent, dev_name(&sdev->sdev_gendev),
 				  components, &ses_enclosure_callbacks);
@@ -813,7 +814,8 @@ static void ses_intf_remove_enclosure(struct scsi_device *sdev)
 	kfree(ses_dev->page2);
 	kfree(ses_dev);
 
-	kfree(edev->component[0].scratch);
+	if (edev->components > 0)
+		kfree(edev->component[0].scratch);
 
 	put_device(&edev->edev);
 	enclosure_unregister(edev);
-- 
2.17.1

