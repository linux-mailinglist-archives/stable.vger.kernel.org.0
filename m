Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA9B74522E2
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:14:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350339AbhKPBQh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:16:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:44604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244658AbhKOTRJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:17:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3DCF26327E;
        Mon, 15 Nov 2021 18:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000562;
        bh=Wv15d2xuFD70EIFcG4CXUFbdIJo4ytqHF/AfRsbW0R8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=joVz7FdNbVG6s7Sxd7jTESUVZdolCa72Y8z5w8eaRa9TflRioxEvwSMtMF6Ifr+Uh
         CZ8mtIEoUm9ZuESdZ8yjAWhZ87KBBW5oul3yO/Q7rgnKYMj4CWkJTJOw6lv6sxpLDR
         /XeBracskSYyBiig+JGMPg/b0PC9B9hYr63NKBvI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 705/849] dmaengine: dmaengine_desc_callback_valid(): Check for `callback_result`
Date:   Mon, 15 Nov 2021 18:03:08 +0100
Message-Id: <20211115165444.105740413@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lars-Peter Clausen <lars@metafoo.de>

[ Upstream commit e7e1e880b114ca640a2f280b0d5d38aed98f98c6 ]

Before the `callback_result` callback was introduced drivers coded their
invocation to the callback in a similar way to:

	if (cb->callback) {
		spin_unlock(&dma->lock);
		cb->callback(cb->callback_param);
		spin_lock(&dma->lock);
	}

With the introduction of `callback_result` two helpers where introduced to
transparently handle both types of callbacks. And drivers where updated to
look like this:

	if (dmaengine_desc_callback_valid(cb)) {
		spin_unlock(&dma->lock);
		dmaengine_desc_callback_invoke(cb, ...);
		spin_lock(&dma->lock);
	}

dmaengine_desc_callback_invoke() correctly handles both `callback_result`
and `callback`. But we forgot to update the dmaengine_desc_callback_valid()
function to check for `callback_result`. As a result DMA descriptors that
use the `callback_result` rather than `callback` don't have their callback
invoked by drivers that follow the pattern above.

Fix this by checking for both `callback` and `callback_result` in
dmaengine_desc_callback_valid().

Fixes: f067025bc676 ("dmaengine: add support to provide error result from a DMA transation")
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Acked-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/20211023134101.28042-1-lars@metafoo.de
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dmaengine.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/dmaengine.h b/drivers/dma/dmaengine.h
index 1bfbd64b13717..53f16d3f00294 100644
--- a/drivers/dma/dmaengine.h
+++ b/drivers/dma/dmaengine.h
@@ -176,7 +176,7 @@ dmaengine_desc_get_callback_invoke(struct dma_async_tx_descriptor *tx,
 static inline bool
 dmaengine_desc_callback_valid(struct dmaengine_desc_callback *cb)
 {
-	return (cb->callback) ? true : false;
+	return cb->callback || cb->callback_result;
 }
 
 struct dma_chan *dma_get_slave_channel(struct dma_chan *chan);
-- 
2.33.0



