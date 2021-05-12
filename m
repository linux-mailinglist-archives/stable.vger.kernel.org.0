Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A350D37C170
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 16:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231555AbhELPAL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:00:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:43384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231808AbhELO6U (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 10:58:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E90D6142E;
        Wed, 12 May 2021 14:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831364;
        bh=t+BE1w70P5dw0RNscBJwi1jRhfwEN6KENCimwH/w+Og=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1l1rooTS8zoiQaEgp9qhou2T5w7JoCJnu9ozh19kPd0YCF7nuKWA2YcXU5CFC6SEP
         4wFT4j6c+K1a+qdKdnPe+PH9jMMtAQj7oEGnLLkWEmZvJ8htldzXOZb87hlMm4QMAs
         YDcEeTWdd7i0qgPMdu/N+rTdnv2L5THYF0GcOFkg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabian Vogt <fabian@ritter-vogt.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 091/244] fotg210-udc: Remove a dubious condition leading to fotg210_done
Date:   Wed, 12 May 2021 16:47:42 +0200
Message-Id: <20210512144745.931841283@linuxfoundation.org>
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

[ Upstream commit c7f755b243494d6043aadcd9a2989cb157958b95 ]

When the EP0 IN request was not completed but less than a packet sent,
it would complete the request successfully. That doesn't make sense
and can't really happen as fotg210_start_dma always sends
min(length, maxpkt) bytes.

Fixes: b84a8dee23fd ("usb: gadget: add Faraday fotg210_udc driver")
Signed-off-by: Fabian Vogt <fabian@ritter-vogt.de>
Link: https://lore.kernel.org/r/20210324141115.9384-4-fabian@ritter-vogt.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/fotg210-udc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/udc/fotg210-udc.c b/drivers/usb/gadget/udc/fotg210-udc.c
index 7abd56ad29bc..b2c75c8ca3d7 100644
--- a/drivers/usb/gadget/udc/fotg210-udc.c
+++ b/drivers/usb/gadget/udc/fotg210-udc.c
@@ -379,8 +379,7 @@ static void fotg210_ep0_queue(struct fotg210_ep *ep,
 	}
 	if (ep->dir_in) { /* if IN */
 		fotg210_start_dma(ep, req);
-		if ((req->req.length == req->req.actual) ||
-		    (req->req.actual < ep->ep.maxpacket))
+		if (req->req.length == req->req.actual)
 			fotg210_done(ep, req, 0);
 	} else { /* OUT */
 		u32 value = ioread32(ep->fotg210->reg + FOTG210_DMISGR0);
-- 
2.30.2



