Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60261431EB5
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 16:03:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234315AbhJROFI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 10:05:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:38300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234521AbhJROCd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 10:02:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E434C61A55;
        Mon, 18 Oct 2021 13:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564592;
        bh=c4Cyn4nHvIBz3K7rCFGkyeXzPmsRkLRYh6D5zPt1C0s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F6XJEfAAOdch15JRm6gOmvMW166HwVfOv4uaDNco9szj6nzhX56k164zptQogRhd6
         sQpUga1GARbLL2Xo4bKjL8QMRenI4oj5/nyNY0GujlGJ8W5Hf8RHIweQLQU1SqQn1m
         S3Af14u1yGyE44hf6tNLdcK2TTQe1p/SoCEZ8xis=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.14 148/151] net: mscc: ocelot: deny TX timestamping of non-PTP packets
Date:   Mon, 18 Oct 2021 15:25:27 +0200
Message-Id: <20211018132345.470814695@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

commit fba01283d85a09e0e2ef552c6e764b903111d90a upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mscc/ocelot.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -585,16 +585,12 @@ u32 ocelot_ptp_rew_op(struct sk_buff *sk
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
@@ -614,11 +610,20 @@ int ocelot_port_txtstamp_request(struct
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


