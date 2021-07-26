Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 405E93D5E39
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 17:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236136AbhGZPGW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:06:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:46794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235673AbhGZPF6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:05:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4475660525;
        Mon, 26 Jul 2021 15:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314386;
        bh=+OfU/LJ9KZPWgq3uZIEVOwwSPfgU91jbdLpo/Sf86zc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B3GlYi5zwSWBgsQX6IPr3rJuhy0OsPwFYAphftJcEAd+IsoDxBPjo6bP1AtA/OPfS
         aSsvqafsvVDIMrPM2ThjlUl5ExlZEOtRtl4GnCCzgozkOdxhtRWmMHX0C8p4p0O4+3
         G8Ca5kWXaZkWIrZjmNZGOp+IHUGLIa0tUbVesu+Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Javed Hasan <jhasan@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 21/82] scsi: libfc: Fix array index out of bound exception
Date:   Mon, 26 Jul 2021 17:38:21 +0200
Message-Id: <20210726153828.844993000@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153828.144714469@linuxfoundation.org>
References: <20210726153828.144714469@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 669cf3553a77..ef2fa6b10a9c 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -1174,6 +1174,7 @@ static void fc_rport_prli_resp(struct fc_seq *sp, struct fc_frame *fp,
 		resp_code = (pp->spp.spp_flags & FC_SPP_RESP_MASK);
 		FC_RPORT_DBG(rdata, "PRLI spp_flags = 0x%x spp_type 0x%x\n",
 			     pp->spp.spp_flags, pp->spp.spp_type);
+
 		rdata->spp_type = pp->spp.spp_type;
 		if (resp_code != FC_SPP_RESP_ACK) {
 			if (resp_code == FC_SPP_RESP_CONF)
@@ -1194,11 +1195,13 @@ static void fc_rport_prli_resp(struct fc_seq *sp, struct fc_frame *fp,
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



