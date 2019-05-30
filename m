Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF6E2F1FD
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:18:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729603AbfE3ER2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:17:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:39062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730415AbfE3DPj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:15:39 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A3A42458A;
        Thu, 30 May 2019 03:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186139;
        bh=6XI6BUlrA5k8SXnhUDs5kmKjC8YZaPyUQ+X6CdLHIY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UxxsdPHnw599B6/XhEB0d/MjB3yIJhuq81s+QgGfHW0LIxM/ntpCZi1N8zzinQuej
         UFZFARBYROdzmIWYb7rfGJlxXTVKN5zF6P4pS9KVkdAglmZ0RJUE1tg/Td1q855xVM
         o9QDw/KbRYltUk6dP40Y82zsoM4BSvH+G89m1XZk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 312/346] scsi: lpfc: Fix fc4type information for FDMI
Date:   Wed, 29 May 2019 20:06:25 -0700
Message-Id: <20190530030556.636057037@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
References: <20190530030540.363386121@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 32a80c093b524a0682f1c6166c910387b116ffce ]

The driver is reporting support for NVME even when not configured for NVME
operation.

Fix (and make more readable) when NVME protocol support is indicated.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_ct.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 912aad3d5b043..b385b8ece343c 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -2363,10 +2363,11 @@ lpfc_fdmi_port_attr_fc4type(struct lpfc_vport *vport,
 	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
 	memset(ae, 0, 32);
 
-	ae->un.AttrTypes[3] = 0x02; /* Type 1 - ELS */
-	ae->un.AttrTypes[2] = 0x01; /* Type 8 - FCP */
-	ae->un.AttrTypes[6] = 0x01; /* Type 40 - NVME */
-	ae->un.AttrTypes[7] = 0x01; /* Type 32 - CT */
+	ae->un.AttrTypes[3] = 0x02; /* Type 0x1 - ELS */
+	ae->un.AttrTypes[2] = 0x01; /* Type 0x8 - FCP */
+	if (vport->nvmei_support || vport->phba->nvmet_support)
+		ae->un.AttrTypes[6] = 0x01; /* Type 0x28 - NVME */
+	ae->un.AttrTypes[7] = 0x01; /* Type 0x20 - CT */
 	size = FOURBYTES + 32;
 	ad->AttrLen = cpu_to_be16(size);
 	ad->AttrType = cpu_to_be16(RPRT_SUPPORTED_FC4_TYPES);
@@ -2676,9 +2677,11 @@ lpfc_fdmi_port_attr_active_fc4type(struct lpfc_vport *vport,
 	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
 	memset(ae, 0, 32);
 
-	ae->un.AttrTypes[3] = 0x02; /* Type 1 - ELS */
-	ae->un.AttrTypes[2] = 0x01; /* Type 8 - FCP */
-	ae->un.AttrTypes[7] = 0x01; /* Type 32 - CT */
+	ae->un.AttrTypes[3] = 0x02; /* Type 0x1 - ELS */
+	ae->un.AttrTypes[2] = 0x01; /* Type 0x8 - FCP */
+	if (vport->phba->cfg_enable_fc4_type & LPFC_ENABLE_NVME)
+		ae->un.AttrTypes[6] = 0x1; /* Type 0x28 - NVME */
+	ae->un.AttrTypes[7] = 0x01; /* Type 0x20 - CT */
 	size = FOURBYTES + 32;
 	ad->AttrLen = cpu_to_be16(size);
 	ad->AttrType = cpu_to_be16(RPRT_ACTIVE_FC4_TYPES);
-- 
2.20.1



