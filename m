Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3126243177D
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 13:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbhJRLht (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 07:37:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:42660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229491AbhJRLht (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 07:37:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D23E60EE5;
        Mon, 18 Oct 2021 11:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634556938;
        bh=M8RC+MWBKso3BGRP3fIUDrib0z50IwqHFvGPaajZuuE=;
        h=Subject:To:Cc:From:Date:From;
        b=Y1V8j3W6GRF1pnQ0s6OcGp+WnGMdYWNhoT211+Qg7JLEb2z3kqNVmnw0ejx+XgRFR
         iOa6koZG4fOk6W0/qrRDcm0bJu0q5plG18L9lbgpHk3uQgJTfstG+00TDCLut1iUFL
         FE1AgBwErMXW7Y32nTDrN+8yljoGJnj83TWO+qFo=
Subject: FAILED: patch "[PATCH] net: mscc: ocelot: deny TX timestamping of non-PTP packets" failed to apply to 5.10-stable tree
To:     vladimir.oltean@nxp.com, kuba@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 Oct 2021 13:35:28 +0200
Message-ID: <163455692813569@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From fba01283d85a09e0e2ef552c6e764b903111d90a Mon Sep 17 00:00:00 2001
From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Tue, 12 Oct 2021 14:40:38 +0300
Subject: [PATCH] net: mscc: ocelot: deny TX timestamping of non-PTP packets

It appears that Ocelot switches cannot timestamp non-PTP frames,
I tested this using the isochron program at:
https://github.com/vladimiroltean/tsn-scripts

with the result that the driver increments the ocelot_port->ts_id
counter as expected, puts it in the REW_OP, but the hardware seems to
not timestamp these packets at all, since no IRQ is emitted.

Therefore check whether we are sending PTP frames, and refuse to
populate REW_OP otherwise.

Fixes: 4e3b0468e6d7 ("net: mscc: PTP Hardware Clock (PHC) support")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 687c07c338cd..3b1f0bb6a414 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -618,16 +618,12 @@ u32 ocelot_ptp_rew_op(struct sk_buff *skb)
 }
 EXPORT_SYMBOL(ocelot_ptp_rew_op);
 
-static bool ocelot_ptp_is_onestep_sync(struct sk_buff *skb)
+static bool ocelot_ptp_is_onestep_sync(struct sk_buff *skb,
+				       unsigned int ptp_class)
 {
 	struct ptp_header *hdr;
-	unsigned int ptp_class;
 	u8 msgtype, twostep;
 
-	ptp_class = ptp_classify_raw(skb);
-	if (ptp_class == PTP_CLASS_NONE)
-		return false;
-
 	hdr = ptp_parse_header(skb, ptp_class);
 	if (!hdr)
 		return false;
@@ -647,11 +643,20 @@ int ocelot_port_txtstamp_request(struct ocelot *ocelot, int port,
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
 	u8 ptp_cmd = ocelot_port->ptp_cmd;
+	unsigned int ptp_class;
 	int err;
 
+	/* Don't do anything if PTP timestamping not enabled */
+	if (!ptp_cmd)
+		return 0;
+
+	ptp_class = ptp_classify_raw(skb);
+	if (ptp_class == PTP_CLASS_NONE)
+		return -EINVAL;
+
 	/* Store ptp_cmd in OCELOT_SKB_CB(skb)->ptp_cmd */
 	if (ptp_cmd == IFH_REW_OP_ORIGIN_PTP) {
-		if (ocelot_ptp_is_onestep_sync(skb)) {
+		if (ocelot_ptp_is_onestep_sync(skb, ptp_class)) {
 			OCELOT_SKB_CB(skb)->ptp_cmd = ptp_cmd;
 			return 0;
 		}

