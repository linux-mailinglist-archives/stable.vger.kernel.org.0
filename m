Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 391F4360D28
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 16:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233052AbhDOO54 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 10:57:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:38804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233792AbhDOOzx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 10:55:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 294ED613CD;
        Thu, 15 Apr 2021 14:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498443;
        bh=PJDY36dxSfxuXR1bnH/A2bm9hCPHOMCKhOQsYxLW6js=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u96gbcBw0k0ug2g+x2g77IGhZGMkxpSmWiMAT41XGsk+nKCK/DxlK2aI+c8VsQmGY
         TWwxzcvUqQlyw55WDjC9Hx50ENVGFIN0/gVvaBA7aRW7pHuMi5cRFOiH3LMWPWDhSx
         HbyQgh4nareZNzQxKfVJ5rb4eS4bslcDV2l75IRY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.14 41/68] net/ncsi: Dont return error on normal response
Date:   Thu, 15 Apr 2021 16:47:22 +0200
Message-Id: <20210415144415.813323202@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415144414.464797272@linuxfoundation.org>
References: <20210415144414.464797272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Samuel Mendoza-Jonas <sam@mendozajonas.com>

commit 04bad8bda9e25afe676a6f4452f3b304c1fdea16 upstream.

Several response handlers return EBUSY if the data corresponding to the
command/response pair is already set. There is no reason to return an
error here; the channel is advertising something as enabled because we
told it to enable it, and it's possible that the feature has been
enabled previously.

Signed-off-by: Samuel Mendoza-Jonas <sam@mendozajonas.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ncsi/ncsi-rsp.c |   31 ++++++++++++++-----------------
 1 file changed, 14 insertions(+), 17 deletions(-)

--- a/net/ncsi/ncsi-rsp.c
+++ b/net/ncsi/ncsi-rsp.c
@@ -146,7 +146,7 @@ static int ncsi_rsp_handler_ec(struct nc
 
 	ncm = &nc->modes[NCSI_MODE_ENABLE];
 	if (ncm->enable)
-		return -EBUSY;
+		return 0;
 
 	ncm->enable = 1;
 	return 0;
@@ -173,7 +173,7 @@ static int ncsi_rsp_handler_dc(struct nc
 
 	ncm = &nc->modes[NCSI_MODE_ENABLE];
 	if (!ncm->enable)
-		return -EBUSY;
+		return 0;
 
 	ncm->enable = 0;
 	return 0;
@@ -217,7 +217,7 @@ static int ncsi_rsp_handler_ecnt(struct
 
 	ncm = &nc->modes[NCSI_MODE_TX_ENABLE];
 	if (ncm->enable)
-		return -EBUSY;
+		return 0;
 
 	ncm->enable = 1;
 	return 0;
@@ -239,7 +239,7 @@ static int ncsi_rsp_handler_dcnt(struct
 
 	ncm = &nc->modes[NCSI_MODE_TX_ENABLE];
 	if (!ncm->enable)
-		return -EBUSY;
+		return 0;
 
 	ncm->enable = 1;
 	return 0;
@@ -263,7 +263,7 @@ static int ncsi_rsp_handler_ae(struct nc
 	/* Check if the AEN has been enabled */
 	ncm = &nc->modes[NCSI_MODE_AEN];
 	if (ncm->enable)
-		return -EBUSY;
+		return 0;
 
 	/* Update to AEN configuration */
 	cmd = (struct ncsi_cmd_ae_pkt *)skb_network_header(nr->cmd);
@@ -382,7 +382,7 @@ static int ncsi_rsp_handler_ev(struct nc
 	/* Check if VLAN mode has been enabled */
 	ncm = &nc->modes[NCSI_MODE_VLAN];
 	if (ncm->enable)
-		return -EBUSY;
+		return 0;
 
 	/* Update to VLAN mode */
 	cmd = (struct ncsi_cmd_ev_pkt *)skb_network_header(nr->cmd);
@@ -409,7 +409,7 @@ static int ncsi_rsp_handler_dv(struct nc
 	/* Check if VLAN mode has been enabled */
 	ncm = &nc->modes[NCSI_MODE_VLAN];
 	if (!ncm->enable)
-		return -EBUSY;
+		return 0;
 
 	/* Update to VLAN mode */
 	ncm->enable = 0;
@@ -455,13 +455,10 @@ static int ncsi_rsp_handler_sma(struct n
 
 	bitmap = &ncf->bitmap;
 	if (cmd->at_e & 0x1) {
-		if (test_and_set_bit(cmd->index, bitmap))
-			return -EBUSY;
+		set_bit(cmd->index, bitmap);
 		memcpy(ncf->data + 6 * cmd->index, cmd->mac, 6);
 	} else {
-		if (!test_and_clear_bit(cmd->index, bitmap))
-			return -EBUSY;
-
+		clear_bit(cmd->index, bitmap);
 		memset(ncf->data + 6 * cmd->index, 0, 6);
 	}
 
@@ -485,7 +482,7 @@ static int ncsi_rsp_handler_ebf(struct n
 	/* Check if broadcast filter has been enabled */
 	ncm = &nc->modes[NCSI_MODE_BC];
 	if (ncm->enable)
-		return -EBUSY;
+		return 0;
 
 	/* Update to broadcast filter mode */
 	cmd = (struct ncsi_cmd_ebf_pkt *)skb_network_header(nr->cmd);
@@ -511,7 +508,7 @@ static int ncsi_rsp_handler_dbf(struct n
 	/* Check if broadcast filter isn't enabled */
 	ncm = &nc->modes[NCSI_MODE_BC];
 	if (!ncm->enable)
-		return -EBUSY;
+		return 0;
 
 	/* Update to broadcast filter mode */
 	ncm->enable = 0;
@@ -538,7 +535,7 @@ static int ncsi_rsp_handler_egmf(struct
 	/* Check if multicast filter has been enabled */
 	ncm = &nc->modes[NCSI_MODE_MC];
 	if (ncm->enable)
-		return -EBUSY;
+		return 0;
 
 	/* Update to multicast filter mode */
 	cmd = (struct ncsi_cmd_egmf_pkt *)skb_network_header(nr->cmd);
@@ -564,7 +561,7 @@ static int ncsi_rsp_handler_dgmf(struct
 	/* Check if multicast filter has been enabled */
 	ncm = &nc->modes[NCSI_MODE_MC];
 	if (!ncm->enable)
-		return -EBUSY;
+		return 0;
 
 	/* Update to multicast filter mode */
 	ncm->enable = 0;
@@ -591,7 +588,7 @@ static int ncsi_rsp_handler_snfc(struct
 	/* Check if flow control has been enabled */
 	ncm = &nc->modes[NCSI_MODE_FC];
 	if (ncm->enable)
-		return -EBUSY;
+		return 0;
 
 	/* Update to flow control mode */
 	cmd = (struct ncsi_cmd_snfc_pkt *)skb_network_header(nr->cmd);


