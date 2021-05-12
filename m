Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0669837C177
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 16:59:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232520AbhELPAX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:00:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:46814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232521AbhELO6e (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 10:58:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3158B61433;
        Wed, 12 May 2021 14:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831371;
        bh=S+zPI6VsCQB9dcbdI+sn4i4B6r4QPCu/eE5YXZNMlyk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bWFo9JAN6vTSZd6UfND34C9Vk4tE4gO2Y+2QyvIY6C7ARkwZjF7lQTxYJBtYseYNq
         VUAnKV645PgQjetn9hXgnl8B9dL5Uu9zJ+wflLPgPfgvKU0kSBNr+/KmitiDB9OPAV
         O/29Pl0j5iLttHlIs1rWsMTZemgV9DW5n7ls6NcI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabian Vogt <fabian@ritter-vogt.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 094/244] fotg210-udc: Complete OUT requests on short packets
Date:   Wed, 12 May 2021 16:47:45 +0200
Message-Id: <20210512144746.034804234@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144743.039977287@linuxfoundation.org>
References: <20210512144743.039977287@linuxfoundation.org>
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
index 5e2f84818896..c313d07ec16f 100644
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



