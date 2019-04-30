Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97E07F71E
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 13:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730990AbfD3LtY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:49:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:35908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730985AbfD3LtY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:49:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57A4621734;
        Tue, 30 Apr 2019 11:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624962;
        bh=R4EoRxp5VUPcegQvGoO6HysLF8EDfQpLxNG6/h6hV9k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q5MAQuR11t5gIrjOWoqcIytsuGQYWg3/T/ESSG3ImakS6OMMDwA5+eIrUqODA2O0P
         +//uxCCWmOd14C1l7LS4wC5CW+LkG5iTjNqjhVz6L5tzP4976z8mQ4NkiZw6hb/u/2
         tnZ8Vr2u41b3zCDO9JWC3mSshtu1rMjADmR0aFmA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Achim Dahlhoff <Achim.Dahlhoff@de.bosch.com>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.0 38/89] dmaengine: sh: rcar-dmac: Fix glitch in dmaengine_tx_status
Date:   Tue, 30 Apr 2019 13:38:29 +0200
Message-Id: <20190430113611.612017498@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113609.741196396@linuxfoundation.org>
References: <20190430113609.741196396@linuxfoundation.org>
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
@@ -1282,6 +1282,9 @@ static unsigned int rcar_dmac_chan_get_r
 	enum dma_status status;
 	unsigned int residue = 0;
 	unsigned int dptr = 0;
+	unsigned int chcrb;
+	unsigned int tcrb;
+	unsigned int i;
 
 	if (!desc)
 		return 0;
@@ -1330,14 +1333,31 @@ static unsigned int rcar_dmac_chan_get_r
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
@@ -1355,7 +1375,7 @@ static unsigned int rcar_dmac_chan_get_r
 	}
 
 	/* Add the residue for the current chunk. */
-	residue += rcar_dmac_chan_read(chan, RCAR_DMATCRB) << desc->xfer_shift;
+	residue += tcrb << desc->xfer_shift;
 
 	return residue;
 }


