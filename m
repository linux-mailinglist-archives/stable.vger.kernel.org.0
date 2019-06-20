Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE1244D782
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:19:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727349AbfFTSTi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:19:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:43442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729503AbfFTSO5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:14:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E787621734;
        Thu, 20 Jun 2019 18:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561054496;
        bh=980y4+/bM4nqKR5zFJc08I4f1d9BaMa28HhT7rOx/s4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gtXJhcFrxMIffZxvmSjx6D+AplTtPFO8C7MVlSsXmn/LjAAE2jm07C35phAEQDqBm
         oMhgeHOnEDx43TAYdBapff3PIBPJzDFqI3wUSXr/2P1/RUbPPFRovz0HbRRia8cfBt
         olUqhKCRrClmkI3nburUa0gNMnJlVOr/rszTtmLI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yuri Chipchev <yuric@marvell.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.1 19/98] net: mvpp2: prs: Fix parser range for VID filtering
Date:   Thu, 20 Jun 2019 19:56:46 +0200
Message-Id: <20190620174350.122651256@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174349.443386789@linuxfoundation.org>
References: <20190620174349.443386789@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Chevallier <maxime.chevallier@bootlin.com>

[ Upstream commit 46b0090a6636cf34c0e856f15dd03e15ba4cdda6 ]

VID filtering is implemented in the Header Parser, with one range of 11
vids being assigned for each no-loopback port.

Make sure we use the per-port range when looking for existing entries in
the Parser.

Since we used a global range instead of a per-port one, this causes VIDs
to be removed from the whitelist from all ports of the same PPv2
instance.

Fixes: 56beda3db602 ("net: mvpp2: Add hardware offloading for VLAN filtering")
Suggested-by: Yuri Chipchev <yuric@marvell.com>
Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
@@ -1905,8 +1905,7 @@ static int mvpp2_prs_ip6_init(struct mvp
 }
 
 /* Find tcam entry with matched pair <vid,port> */
-static int mvpp2_prs_vid_range_find(struct mvpp2 *priv, int pmap, u16 vid,
-				    u16 mask)
+static int mvpp2_prs_vid_range_find(struct mvpp2_port *port, u16 vid, u16 mask)
 {
 	unsigned char byte[2], enable[2];
 	struct mvpp2_prs_entry pe;
@@ -1914,13 +1913,13 @@ static int mvpp2_prs_vid_range_find(stru
 	int tid;
 
 	/* Go through the all entries with MVPP2_PRS_LU_VID */
-	for (tid = MVPP2_PE_VID_FILT_RANGE_START;
-	     tid <= MVPP2_PE_VID_FILT_RANGE_END; tid++) {
-		if (!priv->prs_shadow[tid].valid ||
-		    priv->prs_shadow[tid].lu != MVPP2_PRS_LU_VID)
+	for (tid = MVPP2_PRS_VID_PORT_FIRST(port->id);
+	     tid <= MVPP2_PRS_VID_PORT_LAST(port->id); tid++) {
+		if (!port->priv->prs_shadow[tid].valid ||
+		    port->priv->prs_shadow[tid].lu != MVPP2_PRS_LU_VID)
 			continue;
 
-		mvpp2_prs_init_from_hw(priv, &pe, tid);
+		mvpp2_prs_init_from_hw(port->priv, &pe, tid);
 
 		mvpp2_prs_tcam_data_byte_get(&pe, 2, &byte[0], &enable[0]);
 		mvpp2_prs_tcam_data_byte_get(&pe, 3, &byte[1], &enable[1]);
@@ -1950,7 +1949,7 @@ int mvpp2_prs_vid_entry_add(struct mvpp2
 	memset(&pe, 0, sizeof(pe));
 
 	/* Scan TCAM and see if entry with this <vid,port> already exist */
-	tid = mvpp2_prs_vid_range_find(priv, (1 << port->id), vid, mask);
+	tid = mvpp2_prs_vid_range_find(port, vid, mask);
 
 	reg_val = mvpp2_read(priv, MVPP2_MH_REG(port->id));
 	if (reg_val & MVPP2_DSA_EXTENDED)
@@ -2008,7 +2007,7 @@ void mvpp2_prs_vid_entry_remove(struct m
 	int tid;
 
 	/* Scan TCAM and see if entry with this <vid,port> already exist */
-	tid = mvpp2_prs_vid_range_find(priv, (1 << port->id), vid, 0xfff);
+	tid = mvpp2_prs_vid_range_find(port, vid, 0xfff);
 
 	/* No such entry */
 	if (tid < 0)


