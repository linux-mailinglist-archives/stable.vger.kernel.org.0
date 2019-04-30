Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81277F7A1
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 14:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729664AbfD3LpS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:45:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:57344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730366AbfD3LpQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:45:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86A9421670;
        Tue, 30 Apr 2019 11:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624716;
        bh=LnAasITKAP8GikVDz7pSmI6wzBOPW/7N4PyDs08spG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mp5LdIG+nlKvPqaoptQbV0iH23cMYoLHe4Cy8RyA+Fpq6GFaJnszmhqAD20s5K+BK
         AM3ro9run50iga6dSKRWKWfBkOxAYdgi7d9dr1ctLl6jvPAhm1dQqpY5az1T/TUEOF
         LYDph5IUymMrbpdxJj205G2Mc0oBkMKRnPv8FbOY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Achim Dahlhoff <Achim.Dahlhoff@de.bosch.com>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 4.19 044/100] dmaengine: sh: rcar-dmac: Fix glitch in dmaengine_tx_status
Date:   Tue, 30 Apr 2019 13:38:13 +0200
Message-Id: <20190430113611.180037970@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113608.616903219@linuxfoundation.org>
References: <20190430113608.616903219@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Achim Dahlhoff <Achim.Dahlhoff@de.bosch.com>

commit 6e7da74775348d96e2d7efaf3f91410e18c481ef upstream.

The tx_status poll in the rcar_dmac driver reads the status register
which indicates which chunk is busy (DMACHCRB). Afterwards the point
inside the chunk is read from DMATCRB. It is possible that the chunk
has changed between the two reads. The result is a non-monotonous
increase of the residue. Fix this by introducing a 'safe read' logic.

Fixes: 73a47bd0da66 ("dmaengine: rcar-dmac: use TCRB instead of TCR for residue")
Signed-off-by: Achim Dahlhoff <Achim.Dahlhoff@de.bosch.com>
Signed-off-by: Dirk Behme <dirk.behme@de.bosch.com>
Reviewed-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc: <stable@vger.kernel.org> # v4.16+
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dma/sh/rcar-dmac.c |   26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

--- a/drivers/dma/sh/rcar-dmac.c
+++ b/drivers/dma/sh/rcar-dmac.c
@@ -1281,6 +1281,9 @@ static unsigned int rcar_dmac_chan_get_r
 	enum dma_status status;
 	unsigned int residue = 0;
 	unsigned int dptr = 0;
+	unsigned int chcrb;
+	unsigned int tcrb;
+	unsigned int i;
 
 	if (!desc)
 		return 0;
@@ -1329,14 +1332,31 @@ static unsigned int rcar_dmac_chan_get_r
 	}
 
 	/*
+	 * We need to read two registers.
+	 * Make sure the control register does not skip to next chunk
+	 * while reading the counter.
+	 * Trying it 3 times should be enough: Initial read, retry, retry
+	 * for the paranoid.
+	 */
+	for (i = 0; i < 3; i++) {
+		chcrb = rcar_dmac_chan_read(chan, RCAR_DMACHCRB) &
+					    RCAR_DMACHCRB_DPTR_MASK;
+		tcrb = rcar_dmac_chan_read(chan, RCAR_DMATCRB);
+		/* Still the same? */
+		if (chcrb == (rcar_dmac_chan_read(chan, RCAR_DMACHCRB) &
+			      RCAR_DMACHCRB_DPTR_MASK))
+			break;
+	}
+	WARN_ONCE(i >= 3, "residue might be not continuous!");
+
+	/*
 	 * In descriptor mode the descriptor running pointer is not maintained
 	 * by the interrupt handler, find the running descriptor from the
 	 * descriptor pointer field in the CHCRB register. In non-descriptor
 	 * mode just use the running descriptor pointer.
 	 */
 	if (desc->hwdescs.use) {
-		dptr = (rcar_dmac_chan_read(chan, RCAR_DMACHCRB) &
-			RCAR_DMACHCRB_DPTR_MASK) >> RCAR_DMACHCRB_DPTR_SHIFT;
+		dptr = chcrb >> RCAR_DMACHCRB_DPTR_SHIFT;
 		if (dptr == 0)
 			dptr = desc->nchunks;
 		dptr--;
@@ -1354,7 +1374,7 @@ static unsigned int rcar_dmac_chan_get_r
 	}
 
 	/* Add the residue for the current chunk. */
-	residue += rcar_dmac_chan_read(chan, RCAR_DMATCRB) << desc->xfer_shift;
+	residue += tcrb << desc->xfer_shift;
 
 	return residue;
 }


