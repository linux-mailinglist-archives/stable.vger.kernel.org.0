Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85C5514B963
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:33:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387483AbgA1ObM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:31:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:56034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387465AbgA1O2J (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:28:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 765AB20716;
        Tue, 28 Jan 2020 14:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221687;
        bh=HrpOpgxsXGmwuwvvJPLNqkj9fKnc7vA/t9D18pJkZXk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PSGSUvIIBGYwUjLA65yD6QxKClknsskptNC0OAkwdLtwrC/H5mWN/B7jWy3ai68OP
         I8NDi5ebmhcXaGYHif4PwKXkIpNTkBifseqO+MM2QMmqowAel1hdAH1CYn3SMlP/jb
         c+oF6+Fn1B9ZtmlMZcGTlxOMNbzEnt5Pez13BKc0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stan Johnson <userm57@yahoo.com>,
        Finn Thain <fthain@telegraphics.com.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 50/92] net/sonic: Improve receive descriptor status flag check
Date:   Tue, 28 Jan 2020 15:08:18 +0100
Message-Id: <20200128135815.540726314@linuxfoundation.org>
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

commit 94b166349503957079ef5e7d6f667f157aea014a upstream.

After sonic_tx_timeout() calls sonic_init(), it can happen that
sonic_rx() will subsequently encounter a receive descriptor with no
flags set. Remove the comment that says that this can't happen.

When giving a receive descriptor to the SONIC, clear the descriptor
status field. That way, any rx descriptor with flags set can only be
a newly received packet.

Don't process a descriptor without the LPKT bit set. The buffer is
still in use by the SONIC.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/natsemi/sonic.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

--- a/drivers/net/ethernet/natsemi/sonic.c
+++ b/drivers/net/ethernet/natsemi/sonic.c
@@ -433,7 +433,6 @@ static int index_from_addr(struct sonic_
 static void sonic_rx(struct net_device *dev)
 {
 	struct sonic_local *lp = netdev_priv(dev);
-	int status;
 	int entry = lp->cur_rx;
 	int prev_entry = lp->eol_rx;
 
@@ -444,9 +443,10 @@ static void sonic_rx(struct net_device *
 		u16 bufadr_l;
 		u16 bufadr_h;
 		int pkt_len;
+		u16 status = sonic_rda_get(dev, entry, SONIC_RD_STATUS);
 
-		status = sonic_rda_get(dev, entry, SONIC_RD_STATUS);
-		if (status & SONIC_RCR_PRX) {
+		/* If the RD has LPKT set, the chip has finished with the RB */
+		if ((status & SONIC_RCR_PRX) && (status & SONIC_RCR_LPKT)) {
 			u32 addr = (sonic_rda_get(dev, entry,
 						  SONIC_RD_PKTPTR_H) << 16) |
 				   sonic_rda_get(dev, entry, SONIC_RD_PKTPTR_L);
@@ -494,10 +494,6 @@ static void sonic_rx(struct net_device *
 			bufadr_h = (unsigned long)new_laddr >> 16;
 			sonic_rra_put(dev, i, SONIC_RR_BUFADR_L, bufadr_l);
 			sonic_rra_put(dev, i, SONIC_RR_BUFADR_H, bufadr_h);
-		} else {
-			/* This should only happen, if we enable accepting broken packets. */
-		}
-		if (status & SONIC_RCR_LPKT) {
 			/*
 			 * this was the last packet out of the current receive buffer
 			 * give the buffer back to the SONIC
@@ -510,12 +506,11 @@ static void sonic_rx(struct net_device *
 					  __func__);
 				SONIC_WRITE(SONIC_ISR, SONIC_INT_RBE); /* clear the flag */
 			}
-		} else
-			printk(KERN_ERR "%s: rx desc without RCR_LPKT. Shouldn't happen !?\n",
-			     dev->name);
+		}
 		/*
 		 * give back the descriptor
 		 */
+		sonic_rda_put(dev, entry, SONIC_RD_STATUS, 0);
 		sonic_rda_put(dev, entry, SONIC_RD_IN_USE, 1);
 
 		prev_entry = entry;


