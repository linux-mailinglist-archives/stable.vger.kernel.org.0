Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49F2738A6B0
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:28:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235237AbhETK3s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:29:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:55696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235961AbhETK1t (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:27:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B9DC61C28;
        Thu, 20 May 2021 09:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504241;
        bh=PFz0vzBcaTOiSeUcsZ/qvTbrrYS3LdT+lRnpobao/Vo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DBd80LiYqYjwXWdGMh5BWRnl03YotQav+18zxkWRFDtGVy/e2XtWSwdGXJYHRNkOX
         9zgGMroJhRGOS6onrwnlhgAOHU4mAfITQh8JtXZoY8nfuVOU/N4HDXRomlfkLhUeYW
         xgcDQ/rGdRjZopXSQPamKl6EFTCWIYCIG0eQqLAs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabian Vogt <fabian@ritter-vogt.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 156/323] fotg210-udc: Complete OUT requests on short packets
Date:   Thu, 20 May 2021 11:20:48 +0200
Message-Id: <20210520092125.447339235@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
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
index 315d0e485d32..9440973cdb44 100644
--- a/drivers/usb/gadget/udc/fotg210-udc.c
+++ b/drivers/usb/gadget/udc/fotg210-udc.c
@@ -856,12 +856,16 @@ static void fotg210_out_fifo_handler(struct fotg210_ep *ep)
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



