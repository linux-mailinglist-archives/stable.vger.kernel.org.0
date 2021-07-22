Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4562A3D29DA
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235100AbhGVQGo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:06:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:43670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234835AbhGVQFt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:05:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D2C961D5B;
        Thu, 22 Jul 2021 16:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972383;
        bh=7rP6QNdzEhQzfiBxNXVn23g6FHgrvvvxuCVYYNNE+9k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fofo/MVnHxNFPG70A3Lfln0IeDYE0gNiHByiVSeIqro9LDywD7Y6By0gSZR6A44Ry
         J0seNYKAXs0xXzoAWwtU9N69EM3fi2CEH99k4+mTkOA+yE/OgieZlaeHb5jgkwkGhj
         DHtLOSZgaK+ZOWWDjhhV0IaWhlaySDAETzFBod9k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Javed Hasan <jhasan@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 093/156] scsi: libfc: Fix array index out of bound exception
Date:   Thu, 22 Jul 2021 18:31:08 +0200
Message-Id: <20210722155631.382497196@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155628.371356843@linuxfoundation.org>
References: <20210722155628.371356843@linuxfoundation.org>
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



