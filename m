Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EAFB38AABD
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240088AbhETLRA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:17:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:37860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240595AbhETLO7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 07:14:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E0C1C6194C;
        Thu, 20 May 2021 10:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621505322;
        bh=w1zepXwKZCJSEghz91NfTQzyP7m84JxtGMbjg+FLY/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UZViFlIEdWQ4kMHFpFxxkrAaa0NwmPYQNbFQjPzhxRp7Czy9LR9i4sPY3g2OHIx+T
         RGuE1y6WNjR7C9FdmooECzoq5JBDDrLv7rW/9VXTeCMni7BG9LxhKkBzoAddr0k8Nv
         Hk4x7GnDED2jJuQiJIqQJ5HUSULRsxIT/4vEoME0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabian Vogt <fabian@ritter-vogt.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 083/190] fotg210-udc: Fix DMA on EP0 for length > max packet size
Date:   Thu, 20 May 2021 11:22:27 +0200
Message-Id: <20210520092104.944253767@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092102.149300807@linuxfoundation.org>
References: <20210520092102.149300807@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabian Vogt <fabian@ritter-vogt.de>

[ Upstream commit 755915fc28edfc608fa89a163014acb2f31c1e19 ]

For a 75 Byte request, it would send the first 64 separately, then detect
that the remaining 11 Byte fit into a single DMA, but due to this bug set
the length to the original 75 Bytes. This leads to a DMA failure (which is
ignored...) and the request completes without the remaining bytes having
been sent.

Fixes: b84a8dee23fd ("usb: gadget: add Faraday fotg210_udc driver")
Signed-off-by: Fabian Vogt <fabian@ritter-vogt.de>
Link: https://lore.kernel.org/r/20210324141115.9384-2-fabian@ritter-vogt.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/fotg210-udc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/udc/fotg210-udc.c b/drivers/usb/gadget/udc/fotg210-udc.c
index 76e991557116..7831c556a40b 100644
--- a/drivers/usb/gadget/udc/fotg210-udc.c
+++ b/drivers/usb/gadget/udc/fotg210-udc.c
@@ -348,7 +348,7 @@ static void fotg210_start_dma(struct fotg210_ep *ep,
 		if (req->req.length - req->req.actual > ep->ep.maxpacket)
 			length = ep->ep.maxpacket;
 		else
-			length = req->req.length;
+			length = req->req.length - req->req.actual;
 	}
 
 	d = dma_map_single(NULL, buffer, length,
-- 
2.30.2



