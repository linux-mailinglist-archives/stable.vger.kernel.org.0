Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA26165656
	for <lists+stable@lfdr.de>; Thu, 20 Feb 2020 05:39:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727637AbgBTEjk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Feb 2020 23:39:40 -0500
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:32976 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727469AbgBTEjk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Feb 2020 23:39:40 -0500
X-Greylist: delayed 906 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Feb 2020 23:39:40 EST
Received: from sc9-mailhost3.vmware.com (10.113.161.73) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Wed, 19 Feb 2020 20:24:31 -0800
Received: from akaher-virtual-machine.eng.vmware.com (unknown [10.197.103.239])
        by sc9-mailhost3.vmware.com (Postfix) with ESMTP id A6A49403A0;
        Wed, 19 Feb 2020 20:24:33 -0800 (PST)
From:   Ajay Kaher <akaher@vmware.com>
To:     <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>, <srivatsab@vmware.com>,
        <srivatsa@csail.mit.edu>, <amakhalov@vmware.com>,
        <srinidhir@vmware.com>, <bvikas@vmware.com>, <anishs@vmware.com>,
        <vsirnapalli@vmware.com>, <akaher@vmware.com>,
        <sharathg@vmware.com>, <srostedt@vmware.com>,
        <martin.petersen@oracle.com>, <hmadhani@marvell.com>,
        <mwilck@suse.com>, <allen.pais@oracle.com>
Subject: [PATCH v4.14.y] scsi: qla2xxx: fix a potential NULL pointer dereference
Date:   Thu, 20 Feb 2020 09:50:41 +0530
Message-ID: <1582172443-20029-1-git-send-email-akaher@vmware.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX13-EDG-OU-001.vmware.com: akaher@vmware.com does not
 designate permitted sender hosts)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Allen Pais <allen.pais@oracle.com>

commit 35a79a63517981a8aea395497c548776347deda8 upstream

alloc_workqueue is not checked for errors and as a result a potential
NULL dereference could occur.

Link: https://lore.kernel.org/r/1568824618-4366-1-git-send-email-allen.pais@oracle.com
Signed-off-by: Allen Pais <allen.pais@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Acked-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
[Ajay: Modified to apply on v4.14.y]
Signed-off-by: Ajay Kaher <akaher@vmware.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 5f9d4db..d402401 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3178,6 +3178,10 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	    base_vha->mgmt_svr_loop_id, host->sg_tablesize);
 
 	ha->wq = alloc_workqueue("qla2xxx_wq", WQ_MEM_RECLAIM, 0);
+	if (unlikely(!ha->wq)) {
+		ret = -ENOMEM;
+		goto probe_failed;
+	}
 
 	if (ha->mqenable) {
 		bool mq = false;
-- 
2.7.4

