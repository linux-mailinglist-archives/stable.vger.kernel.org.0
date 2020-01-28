Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09C5E14B929
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:33:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733089AbgA1O2H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:28:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:55978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387459AbgA1O2G (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:28:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF46C20716;
        Tue, 28 Jan 2020 14:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221685;
        bh=BTNjNvv0simzDRhVnxHDJcG5ftnnbuHYpifLW2PDh6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wMNhkcrFpJXPvmLU7EBncOHjGuVv+FaGRhV/clSiG4hdFJ4N0YUIrcUZoCU5rt3I1
         FUe60bMFq4WT7PUOn90xv3oi+7s+araO1KeVu3j7MunPYpY3UnQH7NbNNN5moRsupT
         9ATc4mX2hqcAjzByqX3p68TB+r/vgUO5micooF/o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stan Johnson <userm57@yahoo.com>,
        Finn Thain <fthain@telegraphics.com.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 49/92] net/sonic: Avoid needless receive descriptor EOL flag updates
Date:   Tue, 28 Jan 2020 15:08:17 +0100
Message-Id: <20200128135815.388148861@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135809.344954797@linuxfoundation.org>
References: <20200128135809.344954797@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Finn Thain <fthain@telegraphics.com.au>

commit eaabfd19b2c787bbe88dc32424b9a43d67293422 upstream.

The while loop in sonic_rx() traverses the rx descriptor ring. It stops
when it reaches a descriptor that the SONIC has not used. Each iteration
advances the EOL flag so the SONIC can keep using more descriptors.
Therefore, the while loop has no definite termination condition.

The algorithm described in the National Semiconductor literature is quite
different. It consumes descriptors up to the one with its EOL flag set
(which will also have its "in use" flag set). All freed descriptors are
then returned to the ring at once, by adjusting the EOL flags (and link
pointers).

Adopt the algorithm from datasheet as it's simpler, terminates quickly
and avoids a lot of pointless descriptor EOL flag changes.

Fixes: efcce839360f ("[PATCH] macsonic/jazzsonic network drivers update")
Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/natsemi/sonic.c |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

--- a/drivers/net/ethernet/natsemi/sonic.c
+++ b/drivers/net/ethernet/natsemi/sonic.c
@@ -435,6 +435,7 @@ static void sonic_rx(struct net_device *
 	struct sonic_local *lp = netdev_priv(dev);
 	int status;
 	int entry = lp->cur_rx;
+	int prev_entry = lp->eol_rx;
 
 	while (sonic_rda_get(dev, entry, SONIC_RD_IN_USE) == 0) {
 		struct sk_buff *used_skb;
@@ -515,13 +516,21 @@ static void sonic_rx(struct net_device *
 		/*
 		 * give back the descriptor
 		 */
-		sonic_rda_put(dev, entry, SONIC_RD_LINK,
-			sonic_rda_get(dev, entry, SONIC_RD_LINK) | SONIC_EOL);
 		sonic_rda_put(dev, entry, SONIC_RD_IN_USE, 1);
-		sonic_rda_put(dev, lp->eol_rx, SONIC_RD_LINK,
-			sonic_rda_get(dev, lp->eol_rx, SONIC_RD_LINK) & ~SONIC_EOL);
-		lp->eol_rx = entry;
-		lp->cur_rx = entry = (entry + 1) & SONIC_RDS_MASK;
+
+		prev_entry = entry;
+		entry = (entry + 1) & SONIC_RDS_MASK;
+	}
+
+	lp->cur_rx = entry;
+
+	if (prev_entry != lp->eol_rx) {
+		/* Advance the EOL flag to put descriptors back into service */
+		sonic_rda_put(dev, prev_entry, SONIC_RD_LINK, SONIC_EOL |
+			      sonic_rda_get(dev, prev_entry, SONIC_RD_LINK));
+		sonic_rda_put(dev, lp->eol_rx, SONIC_RD_LINK, ~SONIC_EOL &
+			      sonic_rda_get(dev, lp->eol_rx, SONIC_RD_LINK));
+		lp->eol_rx = prev_entry;
 	}
 	/*
 	 * If any worth-while packets have been received, netif_rx()


