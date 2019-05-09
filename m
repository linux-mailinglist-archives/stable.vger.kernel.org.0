Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FCE01915E
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 20:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728192AbfEISyr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 14:54:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:49740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729132AbfEISyr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:54:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17205217D7;
        Thu,  9 May 2019 18:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557428086;
        bh=Faki6XwGAvO7jC/Gd2Wg4MC+oVoEbsPi0NqOI0wM7gA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BiVLGbJnP0BmK4V382MGXVtAOsaY3MDLlbiPsjQ6VAkK5X4F1Q/Ca0i4N/86v+Tyo
         bKopJ2Cdeg2qgcHgkEyHlx/6yEi8F1GmBGC42irHdurgaNQ3RWRT+JbQYk7S6IEI5J
         dFvxTbpN0yflas+J1cxCJNVqHn3IWN1D+xjxmD50=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Giridhar Malavali <gmalavali@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.1 20/30] scsi: qla2xxx: Set remote port devloss timeout to 0
Date:   Thu,  9 May 2019 20:42:52 +0200
Message-Id: <20190509181255.266455565@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181250.417203112@linuxfoundation.org>
References: <20190509181250.417203112@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Giridhar Malavali <gmalavali@marvell.com>

commit ffc81fc07efc94a04695a8c1d458a06aecaf9f30 upstream.

This patch sets remote_port_devloss value to 0. This indicates to FC-NVMe
transport that driver is unloading and transport should not retry.

Fixes: e476fe8af5ff ("scsi: qla2xxx: Fix unload when NVMe devices are configured")
Cc: stable@vger.kernel.org
Signed-off-by: Giridhar Malavali <gmalavali@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/qla2xxx/qla_nvme.c |   19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -615,7 +615,6 @@ static void qla_nvme_unregister_remote_p
 	struct fc_port *fcport = container_of(work, struct fc_port,
 	    nvme_del_work);
 	struct qla_nvme_rport *qla_rport, *trport;
-	scsi_qla_host_t *base_vha;
 
 	if (!IS_ENABLED(CONFIG_NVME_FC))
 		return;
@@ -623,23 +622,19 @@ static void qla_nvme_unregister_remote_p
 	ql_log(ql_log_warn, NULL, 0x2112,
 	    "%s: unregister remoteport on %p\n",__func__, fcport);
 
-	base_vha = pci_get_drvdata(fcport->vha->hw->pdev);
-	if (test_bit(PFLG_DRIVER_REMOVING, &base_vha->pci_flags)) {
-		ql_dbg(ql_dbg_disc, fcport->vha, 0x2114,
-		    "%s: Notify FC-NVMe transport, set devloss=0\n",
-		    __func__);
-
-		nvme_fc_set_remoteport_devloss(fcport->nvme_remote_port, 0);
-	}
-
 	list_for_each_entry_safe(qla_rport, trport,
 	    &fcport->vha->nvme_rport_list, list) {
 		if (qla_rport->fcport == fcport) {
 			ql_log(ql_log_info, fcport->vha, 0x2113,
 			    "%s: fcport=%p\n", __func__, fcport);
+			nvme_fc_set_remoteport_devloss
+				(fcport->nvme_remote_port, 0);
 			init_completion(&fcport->nvme_del_done);
-			nvme_fc_unregister_remoteport(
-			    fcport->nvme_remote_port);
+			if (nvme_fc_unregister_remoteport
+			    (fcport->nvme_remote_port))
+				ql_log(ql_log_info, fcport->vha, 0x2114,
+				    "%s: Failed to unregister nvme_remote_port\n",
+				    __func__);
 			wait_for_completion(&fcport->nvme_del_done);
 			break;
 		}


