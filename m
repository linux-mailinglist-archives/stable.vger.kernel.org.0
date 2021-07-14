Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCB6F3C8E6A
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234657AbhGNTro (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:47:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:37944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237852AbhGNTqm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:46:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8F03613D4;
        Wed, 14 Jul 2021 19:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291771;
        bh=gAYJAht+ugGKIDyLtcTWxTkmXeHkTo1VFA86EfkkVBU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dx5lizI4QdTvswMjSpXN08mUbgtq84HdiEeStyQNQ4A35ovvBi9r1RKoK/3D9jQFY
         JNe9xOdut2FfF0PQxCbQ/ANwm5rixj199kvkPRe2b308v8pvWHbBYWsYECnclkD5aR
         IRh2cvfvYLGLTcqsH/KoQZgeAB3aBuoZ3quoN6h+joeir+7XKMIkb2bSsi6pqaEmvP
         gFU89p5p/TO4HoKm6D/wkX4UyBvf/pGCgQrHCrjhlOyp5bueWaF3C0eXKMfVGqPwTH
         TgJ1zzzICUNGrcPeQoJ9WevHPUhvrgejYYfd/S/wa39pB6o+FQ4NncorCFrBEfeCoc
         agGyrEwpvPd9A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Javed Hasan <jhasan@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 095/102] scsi: libfc: Fix array index out of bound exception
Date:   Wed, 14 Jul 2021 15:40:28 -0400
Message-Id: <20210714194036.53141-95-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194036.53141-1-sashal@kernel.org>
References: <20210714194036.53141-1-sashal@kernel.org>
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
index 56003208d2e7..06e75425d5e3 100644
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

