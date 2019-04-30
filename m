Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17C2CF7A4
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 14:01:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729662AbfD3LpO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:45:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:57272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729494AbfD3LpO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:45:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC90D21707;
        Tue, 30 Apr 2019 11:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624713;
        bh=Y9VG9bpFil1JKNKM+77M5AY4DhSDUjtMmD2poi2CVWk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kz4s5RUWQK0fqL5/rFmmRQx+TI/RHwIxICObmB3euUGsOSt4EyZgStYD159yOezho
         CxGByDFJl0in4EgFdto1OcMFzNyEq1uUjyTaPL+qTiSsRhezjG7TCi3jCpFg14cCOL
         /VwLZ+5eUlX2/A4QxFPPWQQ6Ykx/FIcwpjoCIbz8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dirk Behme <dirk.behme@de.bosch.com>,
        Achim Dahlhoff <Achim.Dahlhoff@de.bosch.com>,
        Hiroyuki Yokoyama <hiroyuki.yokoyama.vx@renesas.com>,
        Yao Lihua <ylhuajnu@outlook.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 4.19 043/100] dmaengine: sh: rcar-dmac: With cyclic DMA residue 0 is valid
Date:   Tue, 30 Apr 2019 13:38:12 +0200
Message-Id: <20190430113611.148869632@linuxfoundation.org>
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

From: Dirk Behme <dirk.behme@de.bosch.com>

commit 907bd68a2edc491849e2fdcfe52c4596627bca94 upstream.

Having a cyclic DMA, a residue 0 is not an indication of a completed
DMA. In case of cyclic DMA make sure that dma_set_residue() is called
and with this a residue of 0 is forwarded correctly to the caller.

Fixes: 3544d2878817 ("dmaengine: rcar-dmac: use result of updated get_residue in tx_status")
Signed-off-by: Dirk Behme <dirk.behme@de.bosch.com>
Signed-off-by: Achim Dahlhoff <Achim.Dahlhoff@de.bosch.com>
Signed-off-by: Hiroyuki Yokoyama <hiroyuki.yokoyama.vx@renesas.com>
Signed-off-by: Yao Lihua <ylhuajnu@outlook.com>
Reviewed-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: <stable@vger.kernel.org> # v4.8+
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dma/sh/rcar-dmac.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/dma/sh/rcar-dmac.c
+++ b/drivers/dma/sh/rcar-dmac.c
@@ -1367,6 +1367,7 @@ static enum dma_status rcar_dmac_tx_stat
 	enum dma_status status;
 	unsigned long flags;
 	unsigned int residue;
+	bool cyclic;
 
 	status = dma_cookie_status(chan, cookie, txstate);
 	if (status == DMA_COMPLETE || !txstate)
@@ -1374,10 +1375,11 @@ static enum dma_status rcar_dmac_tx_stat
 
 	spin_lock_irqsave(&rchan->lock, flags);
 	residue = rcar_dmac_chan_get_residue(rchan, cookie);
+	cyclic = rchan->desc.running ? rchan->desc.running->cyclic : false;
 	spin_unlock_irqrestore(&rchan->lock, flags);
 
 	/* if there's no residue, the cookie is complete */
-	if (!residue)
+	if (!residue && !cyclic)
 		return DMA_COMPLETE;
 
 	dma_set_residue(txstate, residue);


