Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB1538A3D9
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233593AbhETJ5e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:57:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:58884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234999AbhETJz3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:55:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A020361407;
        Thu, 20 May 2021 09:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503436;
        bh=DNbB14rNDgp36EwfV0cee1kPB1JosHYihntvhZHWNME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I7w2c/tU92BT/HNahDzusf8VB/Az4YDPnAdsCxrBXB2mXmuUZBGln2n1kr5JsE++y
         UtRd37+b4Vu9GIv4YXqPQ0hAjoGw0w4fZxNLTg/7JwiJXM50tJwxaEFaFEyUdQWRq4
         2Q8ELfpwbkFdW5RDBecVYpD1wZPYVuPRXkcU0gKg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabian Vogt <fabian@ritter-vogt.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 187/425] fotg210-udc: Dont DMA more than the buffer can take
Date:   Thu, 20 May 2021 11:19:16 +0200
Message-Id: <20210520092137.566807812@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabian Vogt <fabian@ritter-vogt.de>

[ Upstream commit 3e7c2510bdfe89a9ec223dd7acd6bfc8bb1cbeb6 ]

Before this, it wrote as much as available into the buffer, even if it
didn't fit.

Fixes: b84a8dee23fd ("usb: gadget: add Faraday fotg210_udc driver")
Signed-off-by: Fabian Vogt <fabian@ritter-vogt.de>
Link: https://lore.kernel.org/r/20210324141115.9384-7-fabian@ritter-vogt.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/fotg210-udc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/udc/fotg210-udc.c b/drivers/usb/gadget/udc/fotg210-udc.c
index 41cc5babd50d..7ae0243c32e5 100644
--- a/drivers/usb/gadget/udc/fotg210-udc.c
+++ b/drivers/usb/gadget/udc/fotg210-udc.c
@@ -337,8 +337,9 @@ static void fotg210_start_dma(struct fotg210_ep *ep,
 		} else {
 			buffer = req->req.buf + req->req.actual;
 			length = ioread32(ep->fotg210->reg +
-					FOTG210_FIBCR(ep->epnum - 1));
-			length &= FIBCR_BCFX;
+					FOTG210_FIBCR(ep->epnum - 1)) & FIBCR_BCFX;
+			if (length > req->req.length - req->req.actual)
+				length = req->req.length - req->req.actual;
 		}
 	} else {
 		buffer = req->req.buf + req->req.actual;
-- 
2.30.2



