Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA8537C175
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 16:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231440AbhELPAW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:00:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:42902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232361AbhELO6d (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 10:58:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B607C6143B;
        Wed, 12 May 2021 14:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831369;
        bh=Lg9TKJAUaBTb+e4qtEOHgU4Gzy/LdmqRIVOCnA0F0Oo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iISPd+FBJHqoDhDBLfUeRjH6ZBYNGEtKGr5UjbK1hTPhk7buDOiO738lakQgyD3xo
         dK4h4X4tgTQS5o6yWEz8+tVIyr9p6hSHFNhjerwpx/4953qIfwM4cwMbW7HOffobA8
         wud/8JETcE5PW1WXZ1qnvbEefPiSHcGirQ/9Yy+g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabian Vogt <fabian@ritter-vogt.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 093/244] fotg210-udc: Dont DMA more than the buffer can take
Date:   Wed, 12 May 2021 16:47:44 +0200
Message-Id: <20210512144745.994971704@linuxfoundation.org>
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
index c287dc7d430f..5e2f84818896 100644
--- a/drivers/usb/gadget/udc/fotg210-udc.c
+++ b/drivers/usb/gadget/udc/fotg210-udc.c
@@ -338,8 +338,9 @@ static void fotg210_start_dma(struct fotg210_ep *ep,
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



