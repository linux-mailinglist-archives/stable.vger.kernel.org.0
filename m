Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6813C8FA7
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239936AbhGNTxD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:53:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:46246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240300AbhGNTtj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:49:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8197C61431;
        Wed, 14 Jul 2021 19:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291903;
        bh=6lmjyxY1yhsgh0tWS0E2pLA/Evvzkg5aGOdnzpe7vOM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ABjs8AnikIhj3uRG2JNcEcUP8EZHP1rLHeSgXKiivTFwssL1NAMS/Evm+HCgT4Ine
         kfr5R8CZGTP9Zr7rfkVMKA0HKeVt7uPVdrtb44R1IpZ3/cV+eNGBUBXpzC/gA2RFae
         /XdvCBKLTrcwzBbS2GeR0s3tKXxF7R0n/4VtBCXnzf7aZ/SkSbQ5uULE5d3HRn4S9y
         34qW1MeLfTZMBDiAgze72Vqfph+65p6KMuvYinDt3/mWVTdBj0tmi4G96+ZDRdoIda
         p9a12A55L9finRyFEvPHKs0Eayd/+dXekEMn3nIrbShKiJtHmQtluRJ5RkDF3I1gFy
         CkoT20BFC4G9w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Javed Hasan <jhasan@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 81/88] scsi: libfc: Fix array index out of bound exception
Date:   Wed, 14 Jul 2021 15:42:56 -0400
Message-Id: <20210714194303.54028-81-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194303.54028-1-sashal@kernel.org>
References: <20210714194303.54028-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Javed Hasan <jhasan@marvell.com>

[ Upstream commit b27c4577557045f1ab3cdfeabfc7f3cd24aca1fe ]

Fix array index out of bound exception in fc_rport_prli_resp().

Link: https://lore.kernel.org/r/20210615165939.24327-1-jhasan@marvell.com
Signed-off-by: Javed Hasan <jhasan@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/libfc/fc_rport.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index a60b228d13f1..f40edb0dab70 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -1162,6 +1162,7 @@ static void fc_rport_prli_resp(struct fc_seq *sp, struct fc_frame *fp,
 		resp_code = (pp->spp.spp_flags & FC_SPP_RESP_MASK);
 		FC_RPORT_DBG(rdata, "PRLI spp_flags = 0x%x spp_type 0x%x\n",
 			     pp->spp.spp_flags, pp->spp.spp_type);
+
 		rdata->spp_type = pp->spp.spp_type;
 		if (resp_code != FC_SPP_RESP_ACK) {
 			if (resp_code == FC_SPP_RESP_CONF)
@@ -1184,11 +1185,13 @@ static void fc_rport_prli_resp(struct fc_seq *sp, struct fc_frame *fp,
 		/*
 		 * Call prli provider if we should act as a target
 		 */
-		prov = fc_passive_prov[rdata->spp_type];
-		if (prov) {
-			memset(&temp_spp, 0, sizeof(temp_spp));
-			prov->prli(rdata, pp->prli.prli_spp_len,
-				   &pp->spp, &temp_spp);
+		if (rdata->spp_type < FC_FC4_PROV_SIZE) {
+			prov = fc_passive_prov[rdata->spp_type];
+			if (prov) {
+				memset(&temp_spp, 0, sizeof(temp_spp));
+				prov->prli(rdata, pp->prli.prli_spp_len,
+					   &pp->spp, &temp_spp);
+			}
 		}
 		/*
 		 * Check if the image pair could be established
-- 
2.30.2

