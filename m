Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF993C2DE6
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233185AbhGJCZ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:25:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:42176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232813AbhGJCZN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:25:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 63B19613D9;
        Sat, 10 Jul 2021 02:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883749;
        bh=HXXsm6bDL23ZwcCamIIW0m6ncof559sel1rCAX8ztzU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RYqjXXwB9ic+BLB2GNoyYoNk7sQtbAO6djs6wgaCbvvYpjrkh2R3XUWdY5qhJBn0c
         YET53rUzPaAc3orpxH0IkPjaxp2KFPZWapk/vIIY0hH/tC0hqr6eiTyv5x3yTBGgwF
         MeCMgJa1G99AUcvh/PqDeKrMuPa7m3Pk6sQQB7Rg3CTQWpwcrNmbzzmR3DxH7jZLEJ
         XH3dZe0RsrmNahykN812GxItKgpIEZIrIaT7jWtlTP4owv1a1xrmT/G+PVM91zfabm
         T1iLHm2dKC3oHYwsCeEXY34SGpkvdF6Q9qrABLqSo9givs7ICG+IGJLDvBNZbY4x7F
         71sVUGrWTP4+w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     ching Huang <ching2048@areca.com.tw>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 025/104] scsi: arcmsr: Fix doorbell status being updated late on ARC-1886
Date:   Fri,  9 Jul 2021 22:20:37 -0400
Message-Id: <20210710022156.3168825-25-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022156.3168825-1-sashal@kernel.org>
References: <20210710022156.3168825-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: ching Huang <ching2048@areca.com.tw>

[ Upstream commit d9a231226f28261a787535e08d0c78669e1ad010 ]

It is possible for the IOP to be delayed in updating the doorbell
status. The doorbell status should not be 0 so loop until the value
changes.

Link: https://lore.kernel.org/r/afdfdf7eabecf14632492c4987a6b9ac6312a7ad.camel@areca.com.tw
Signed-off-by: ching Huang <ching2048@areca.com.tw>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/arcmsr/arcmsr_hba.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 930972cda38c..42e494a7106c 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -2419,10 +2419,17 @@ static void arcmsr_hbaD_doorbell_isr(struct AdapterControlBlock *pACB)
 
 static void arcmsr_hbaE_doorbell_isr(struct AdapterControlBlock *pACB)
 {
-	uint32_t outbound_doorbell, in_doorbell, tmp;
+	uint32_t outbound_doorbell, in_doorbell, tmp, i;
 	struct MessageUnit_E __iomem *reg = pACB->pmuE;
 
-	in_doorbell = readl(&reg->iobound_doorbell);
+	if (pACB->adapter_type == ACB_ADAPTER_TYPE_F) {
+		for (i = 0; i < 5; i++) {
+			in_doorbell = readl(&reg->iobound_doorbell);
+			if (in_doorbell != 0)
+				break;
+		}
+	} else
+		in_doorbell = readl(&reg->iobound_doorbell);
 	outbound_doorbell = in_doorbell ^ pACB->in_doorbell;
 	do {
 		writel(0, &reg->host_int_status); /* clear interrupt */
-- 
2.30.2

