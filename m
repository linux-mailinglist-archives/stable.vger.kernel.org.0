Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ADD03C2CBE
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:18:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231682AbhGJCUo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:20:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:36990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229606AbhGJCUk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:20:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 677E0613CC;
        Sat, 10 Jul 2021 02:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883476;
        bh=IYoubfj/OlkMZZB5SY71eKlG6nEiNmDXtp7ZUMa6i/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aavYFtroZ2SF1hetHju66MbxSQsoP5wlOzooVrGeJ1UenmsYmc14AO0LIGju7V6Tu
         nlTLhVEOOluVJU7XWo1A+Al8ScoUJAglJsm6cHdBpAl68dEl+w/GrdhEd2JFldwUb1
         aRavOQB4agC81zUWPtIs1yvwBMBlO3xch3dzMHmDAvnUdSzHzgADiilFsxELtseGYY
         oJoRn0QLCU99V2c0SRWAsEKxQvD4KzOWIkEYTNjVLsMHZAkPO6x0a5dquawtFVXVi0
         2qA/NL44ARc6DC17U6CXkWbNJPQFIsDj5HAam1vOV/4RJBIisEbdCEty8rTBrhHziW
         li8zBKiNItBrg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     ching Huang <ching2048@areca.com.tw>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 005/114] scsi: arcmsr: Fix the wrong CDB payload report to IOP
Date:   Fri,  9 Jul 2021 22:15:59 -0400
Message-Id: <20210710021748.3167666-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710021748.3167666-1-sashal@kernel.org>
References: <20210710021748.3167666-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: ching Huang <ching2048@areca.com.tw>

[ Upstream commit 5b8644968d2ca85abb785e83efec36934974b0c2 ]

This patch fixes the wrong CDB payload report to IOP.

Link: https://lore.kernel.org/r/d2c97df3c817595c6faf582839316209022f70da.camel@areca.com.tw
Signed-off-by: ching Huang <ching2048@areca.com.tw>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/arcmsr/arcmsr_hba.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 4b79661275c9..930972cda38c 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -1923,8 +1923,12 @@ static void arcmsr_post_ccb(struct AdapterControlBlock *acb, struct CommandContr
 
 		if (ccb->arc_cdb_size <= 0x300)
 			arc_cdb_size = (ccb->arc_cdb_size - 1) >> 6 | 1;
-		else
-			arc_cdb_size = (((ccb->arc_cdb_size + 0xff) >> 8) + 2) << 1 | 1;
+		else {
+			arc_cdb_size = ((ccb->arc_cdb_size + 0xff) >> 8) + 2;
+			if (arc_cdb_size > 0xF)
+				arc_cdb_size = 0xF;
+			arc_cdb_size = (arc_cdb_size << 1) | 1;
+		}
 		ccb_post_stamp = (ccb->smid | arc_cdb_size);
 		writel(0, &pmu->inbound_queueport_high);
 		writel(ccb_post_stamp, &pmu->inbound_queueport_low);
-- 
2.30.2

