Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8152937CC73
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:05:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239549AbhELQpI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:45:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:56992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243115AbhELQgr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:36:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 089AE61E0A;
        Wed, 12 May 2021 16:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835245;
        bh=paIkBAal57ouLyx6Y8VYkL21J9TMP4bNmhH9Qyd5Mlw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c1CgRL+7gmjCN+fLc4l+8vnZk37HfGl8VctXy0qVQcMbIl4x6OHSMa7R+E/eA50zP
         4uWjZQLP8TP+/KtDOIgcXWUyEuzwLRtjUqMzY4uLHe/emeTbY9Lq5weNUJnXJjNuGm
         3R6bGJvUd2ee4C8Bs9/v8R7xpJzVzMo0Wo9hDsKg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabian Vogt <fabian@ritter-vogt.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 222/677] fotg210-udc: Fix DMA on EP0 for length > max packet size
Date:   Wed, 12 May 2021 16:44:28 +0200
Message-Id: <20210512144844.607675103@linuxfoundation.org>
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
index d6ca50f01985..39260007ebf8 100644
--- a/drivers/usb/gadget/udc/fotg210-udc.c
+++ b/drivers/usb/gadget/udc/fotg210-udc.c
@@ -346,7 +346,7 @@ static void fotg210_start_dma(struct fotg210_ep *ep,
 		if (req->req.length - req->req.actual > ep->ep.maxpacket)
 			length = ep->ep.maxpacket;
 		else
-			length = req->req.length;
+			length = req->req.length - req->req.actual;
 	}
 
 	d = dma_map_single(dev, buffer, length,
-- 
2.30.2



