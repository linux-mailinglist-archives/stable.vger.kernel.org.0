Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B6FF3C2EEE
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233519AbhGJC34 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:29:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:41746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232763AbhGJC2J (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:28:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 07E3B613F7;
        Sat, 10 Jul 2021 02:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883899;
        bh=koMInF0pTJ4jH9nnaDMP7JTIKBlVOtHo4QGr2fpwcdI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BNI99Wu+5aER/vWlfeM0itQjQlfQ6RwYkQQ2K2wpVGWH8aHdbLXFDA6grZUm8UKUz
         Fn8QJaoQwzWwSKUteK5sAKKti+XXi1Y0yMs8SsYdhKMt7TQbGVMvGiTc0d5/tX6N/O
         xtTieQt8H2+GaI1A1mCFg2pbiLUUsZkk3m0vfgqLf0BR/kca4GcBQ1d429ZNIW2KEy
         Z1QH5sYMOreeTZd8E9ZWvqR3SozwGxwYsebDyoI4SGx5qmqZ07sllslcSxEvSTWE7/
         dJzSCm69GC1+sjgXnb79Q5f49cSrJeoAWkwNuMI+TRQGsnSy5oEcqLs1ypU+g6v4Un
         t3M7J8/L9QtNg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     ching Huang <ching2048@areca.com.tw>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 23/93] scsi: arcmsr: Fix doorbell status being updated late on ARC-1886
Date:   Fri,  9 Jul 2021 22:23:17 -0400
Message-Id: <20210710022428.3169839-23-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022428.3169839-1-sashal@kernel.org>
References: <20210710022428.3169839-1-sashal@kernel.org>
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
index 4838f790dac7..9294a2c677b3 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -2424,10 +2424,17 @@ static void arcmsr_hbaD_doorbell_isr(struct AdapterControlBlock *pACB)
 
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

