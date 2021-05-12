Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7FB737CC6C
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238662AbhELQo6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:44:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:57420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243033AbhELQgb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:36:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DBE9661CC1;
        Wed, 12 May 2021 16:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835233;
        bh=HjCaItIy7fL3QVxAC//0oOeWiZ0GOZuAuyIzVwGcdv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZMBace39WEcpZo0TfPfJNBxoXRYToVkt9byzVXaL7W0C2egbQ574jNAEhzh4E1DeW
         2oXT8+JL93+8GX2g5f8MneCwHs35BxeFKm1VlvVL8hWRVlvfP4sE54BAdftDwwzUOi
         7Ngkw7nyb1jpF+Wm9c3S6UpvhdAZuE4sUPxe20UM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabian Vogt <fabian@ritter-vogt.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 227/677] fotg210-udc: Complete OUT requests on short packets
Date:   Wed, 12 May 2021 16:44:33 +0200
Message-Id: <20210512144844.779301906@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabian Vogt <fabian@ritter-vogt.de>

[ Upstream commit 75bb93be0027123b5db6cbcce89eb62f0f6b3c5b ]

A short packet indicates the end of a transfer and marks the request as
complete.

Fixes: b84a8dee23fd ("usb: gadget: add Faraday fotg210_udc driver")
Signed-off-by: Fabian Vogt <fabian@ritter-vogt.de>
Link: https://lore.kernel.org/r/20210324141115.9384-8-fabian@ritter-vogt.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/fotg210-udc.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/udc/fotg210-udc.c b/drivers/usb/gadget/udc/fotg210-udc.c
index 9925d7ac9138..75bf446f4a66 100644
--- a/drivers/usb/gadget/udc/fotg210-udc.c
+++ b/drivers/usb/gadget/udc/fotg210-udc.c
@@ -849,12 +849,16 @@ static void fotg210_out_fifo_handler(struct fotg210_ep *ep)
 {
 	struct fotg210_request *req = list_entry(ep->queue.next,
 						 struct fotg210_request, queue);
+	int disgr1 = ioread32(ep->fotg210->reg + FOTG210_DISGR1);
 
 	fotg210_start_dma(ep, req);
 
-	/* finish out transfer */
+	/* Complete the request when it's full or a short packet arrived.
+	 * Like other drivers, short_not_ok isn't handled.
+	 */
+
 	if (req->req.length == req->req.actual ||
-	    req->req.actual < ep->ep.maxpacket)
+	    (disgr1 & DISGR1_SPK_INT(ep->epnum - 1)))
 		fotg210_done(ep, req, 0);
 }
 
-- 
2.30.2



