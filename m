Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92C873C8D37
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236563AbhGNToI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:44:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:38508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236032AbhGNTnT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:43:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0881D613E2;
        Wed, 14 Jul 2021 19:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291625;
        bh=7rP6QNdzEhQzfiBxNXVn23g6FHgrvvvxuCVYYNNE+9k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gxg814qwQfxiP1uMXrbjyBL/V5BiMfFbJLjd0lN1JlF+O8HhE4Xvc2RB9Dzxyf7R4
         z03doHi2cqPpHNpUkNya7HlYyEaV9OpILlrr7kSeS6HtPZAGftfKJeNRE/p+O45tf3
         vknrJpHkUHgbb0z+91sQ8c6k/lDhXP3R69dCYi+/ekBL5AxFFANdC2vra7HqyQPxJB
         E4KRh4gTttvcgB+RWUrSqjQ8LLwYs8Z9sTajq+rylvHNLf4A/RBiuqP9sOHe32k6sd
         8WS1yA0ZijnWYQ5f2fxRPzV8mcHqExVBd885soG8+5NiCMTdvKZ/QmxBFqeKudrDjB
         dCokcYh4U4koQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Javed Hasan <jhasan@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 101/108] scsi: libfc: Fix array index out of bound exception
Date:   Wed, 14 Jul 2021 15:37:53 -0400
Message-Id: <20210714193800.52097-101-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714193800.52097-1-sashal@kernel.org>
References: <20210714193800.52097-1-sashal@kernel.org>
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
index cd0fb8ca2425..33da3c1085f0 100644
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

