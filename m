Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BEF6F5DD
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 13:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727654AbfD3Ljk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:39:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:45132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727936AbfD3Ljk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:39:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 051CD21734;
        Tue, 30 Apr 2019 11:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624379;
        bh=8W/ehXQACVYoYHOEBk7VSWUI8SF3BqYrJa0YNOBXKRo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1z0nfUeD3hluBS/zJtR34SSYeOM3ax5aXXZ9CEv8et7QSXk2gHQdyJlIIdAsG0cLk
         pmwgGR6xL3/sMgFqPN51TwgU0OW3leUzHSUwef+GeGRlyiTL5fTv0ZvuuSZ7s1TcQi
         Jdllq9/OdwMV75m3h7x2AwCag+yTYvkIV+ur39v4=
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
Subject: [PATCH 4.9 13/41] dmaengine: sh: rcar-dmac: With cyclic DMA residue 0 is valid
Date:   Tue, 30 Apr 2019 13:38:24 +0200
Message-Id: <20190430113528.091286225@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113524.451237916@linuxfoundation.org>
References: <20190430113524.451237916@linuxfoundation.org>
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
@@ -1311,6 +1311,7 @@ static enum dma_status rcar_dmac_tx_stat
 	enum dma_status status;
 	unsigned long flags;
 	unsigned int residue;
+	bool cyclic;
 
 	status = dma_cookie_status(chan, cookie, txstate);
 	if (status == DMA_COMPLETE || !txstate)
@@ -1318,10 +1319,11 @@ static enum dma_status rcar_dmac_tx_stat
 
 	spin_lock_irqsave(&rchan->lock, flags);
 	residue = rcar_dmac_chan_get_residue(rchan, cookie);
+	cyclic = rchan->desc.running ? rchan->desc.running->cyclic : false;
 	spin_unlock_irqrestore(&rchan->lock, flags);
 
 	/* if there's no residue, the cookie is complete */
-	if (!residue)
+	if (!residue && !cyclic)
 		return DMA_COMPLETE;
 
 	dma_set_residue(txstate, residue);


