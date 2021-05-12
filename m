Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A882837CC2A
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:03:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237869AbhELQnN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:43:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:51024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242480AbhELQey (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:34:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D51E361CC2;
        Wed, 12 May 2021 15:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835183;
        bh=DF8prHhm7BdjJr3JuvxXGbq5KxsOC0UJ246nObn0pFQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OobCb1xaJ8JHkBf4wFiynUenkqpv54V9oVVEZETWwybrj2jcCJxt0tG7Rfe7418+7
         naCw1nUaGS1M4cPFkVdM8fZ8v316KokDdvqxUvlzKGLtEQ8ap2uf9C3Ai5a1TNy+rm
         H55vGHaMtrOB8zEZSIk2h3vSXi00TYj6XQiOap/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabian Vogt <fabian@ritter-vogt.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 224/677] fotg210-udc: Remove a dubious condition leading to fotg210_done
Date:   Wed, 12 May 2021 16:44:30 +0200
Message-Id: <20210512144844.678322700@linuxfoundation.org>
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
index 345827cf1b64..a3ad93bfd256 100644
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



