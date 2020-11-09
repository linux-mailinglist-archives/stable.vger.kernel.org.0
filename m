Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18A6C2AB973
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:09:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731186AbgKINJ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:09:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:34410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731848AbgKINJZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:09:25 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C6F12076E;
        Mon,  9 Nov 2020 13:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927364;
        bh=Z1wDiC3HwG946bzh2U4H7Ti5P50tZ77K2E8iE2Ezgis=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kXTJBoKvq1OAwcBTsxU75saVcjbu9/XarkhmeWgt2vHzpJS9reFzeh4VDd9ykLf2k
         WJfz3MSUz1PYlFU8Fd0Rci77jfsDIyi+CtYQqaWYsLCMgdV2QFag6NDZm7gEDJ+Nl2
         ds9zdDBU93sFH0o/IW9SO5wEssRKQBXhhDObz29E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Jurack <james.jurack@ametek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [PATCH 4.19 07/71] gianfar: Replace skb_realloc_headroom with skb_cow_head for PTP
Date:   Mon,  9 Nov 2020 13:55:01 +0100
Message-Id: <20201109125020.250512772@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125019.906191744@linuxfoundation.org>
References: <20201109125019.906191744@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudiu Manoil <claudiu.manoil@nxp.com>

[ Upstream commit d145c9031325fed963a887851d9fa42516efd52b ]

When PTP timestamping is enabled on Tx, the controller
inserts the Tx timestamp at the beginning of the frame
buffer, between SFD and the L2 frame header.  This means
that the skb provided by the stack is required to have
enough headroom otherwise a new skb needs to be created
by the driver to accommodate the timestamp inserted by h/w.
Up until now the driver was relying on skb_realloc_headroom()
to create new skbs to accommodate PTP frames.  Turns out that
this method is not reliable in this context at least, as
skb_realloc_headroom() for PTP frames can cause random crashes,
mostly in subsequent skb_*() calls, when multiple concurrent
TCP streams are run at the same time with the PTP flow
on the same device (as seen in James' report).  I also noticed
that when the system is loaded by sending multiple TCP streams,
the driver receives cloned skbs in large numbers.
skb_cow_head() instead proves to be stable in this scenario,
and not only handles cloned skbs too but it's also more efficient
and widely used in other drivers.
The commit introducing skb_realloc_headroom in the driver
goes back to 2009, commit 93c1285c5d92
("gianfar: reallocate skb when headroom is not enough for fcb").
For practical purposes I'm referencing a newer commit (from 2012)
that brings the code to its current structure (and fixes the PTP
case).

Fixes: 9c4886e5e63b ("gianfar: Fix invalid TX frames returned on error queue when time stamping")
Reported-by: James Jurack <james.jurack@ametek.com>
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
Link: https://lore.kernel.org/r/20201029081057.8506-1-claudiu.manoil@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/gianfar.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -2370,20 +2370,12 @@ static netdev_tx_t gfar_start_xmit(struc
 		fcb_len = GMAC_FCB_LEN + GMAC_TXPAL_LEN;
 
 	/* make space for additional header when fcb is needed */
-	if (fcb_len && unlikely(skb_headroom(skb) < fcb_len)) {
-		struct sk_buff *skb_new;
-
-		skb_new = skb_realloc_headroom(skb, fcb_len);
-		if (!skb_new) {
+	if (fcb_len) {
+		if (unlikely(skb_cow_head(skb, fcb_len))) {
 			dev->stats.tx_errors++;
 			dev_kfree_skb_any(skb);
 			return NETDEV_TX_OK;
 		}
-
-		if (skb->sk)
-			skb_set_owner_w(skb_new, skb->sk);
-		dev_consume_skb_any(skb);
-		skb = skb_new;
 	}
 
 	/* total number of fragments in the SKB */


