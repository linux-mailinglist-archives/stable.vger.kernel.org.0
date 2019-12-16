Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 396751213E1
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:07:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729486AbfLPSFs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:05:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:44798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729028AbfLPSFs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:05:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC3AB2072D;
        Mon, 16 Dec 2019 18:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519548;
        bh=Xp4VK4g8z7ehO2iTZkFT1vXBhhdanHJk21j08fBiBs4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v8KFpcIXLp1nO+z5ITuiTgxeIRYM++tglrzlnX0aCdG5kdjsJNgBylCCEHW+5xdg4
         QU0z+v7oqCmFk73tLcvFop8TfxjIGPxJSEYWJa7gqSDTuPP21UHbdbXon5JFvx5cbd
         sUQ4ZxgLRC+IuXJGQ3LlBzS52Q2Q7HN5ReWZ2igM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 111/140] scsi: lpfc: Correct topology type reporting on G7 adapters
Date:   Mon, 16 Dec 2019 18:49:39 +0100
Message-Id: <20191216174816.975135592@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174747.111154704@linuxfoundation.org>
References: <20191216174747.111154704@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit 76558b25733140a0c6bd53ea8af04b2811c92ec3 ]

Driver missed classifying the chip type for G7 when reporting supported
topologies. This resulted in loop being shown as supported on FC links that
are not supported per the standard.

Add the chip classifications to the topology checks in the driver.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_attr.c | 5 +++--
 drivers/scsi/lpfc/lpfc_mbox.c | 6 +++---
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 1e9002138d31c..fe084d47ed9e5 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -3849,8 +3849,9 @@ lpfc_topology_store(struct device *dev, struct device_attribute *attr,
 				val);
 			return -EINVAL;
 		}
-		if (phba->pcidev->device == PCI_DEVICE_ID_LANCER_G6_FC &&
-			val == 4) {
+		if ((phba->pcidev->device == PCI_DEVICE_ID_LANCER_G6_FC ||
+		     phba->pcidev->device == PCI_DEVICE_ID_LANCER_G7_FC) &&
+		    val == 4) {
 			lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
 				"3114 Loop mode not supported\n");
 			return -EINVAL;
diff --git a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
index deb094fdbb793..e6bf5e8bc7670 100644
--- a/drivers/scsi/lpfc/lpfc_mbox.c
+++ b/drivers/scsi/lpfc/lpfc_mbox.c
@@ -513,9 +513,9 @@ lpfc_init_link(struct lpfc_hba * phba,
 		break;
 	}
 
-	if (phba->pcidev->device == PCI_DEVICE_ID_LANCER_G6_FC &&
-		mb->un.varInitLnk.link_flags & FLAGS_TOPOLOGY_MODE_LOOP) {
-		/* Failover is not tried for Lancer G6 */
+	if ((phba->pcidev->device == PCI_DEVICE_ID_LANCER_G6_FC ||
+	     phba->pcidev->device == PCI_DEVICE_ID_LANCER_G7_FC) &&
+	    mb->un.varInitLnk.link_flags & FLAGS_TOPOLOGY_MODE_LOOP) {
 		mb->un.varInitLnk.link_flags = FLAGS_TOPOLOGY_MODE_PT_PT;
 		phba->cfg_topology = FLAGS_TOPOLOGY_MODE_PT_PT;
 	}
-- 
2.20.1



