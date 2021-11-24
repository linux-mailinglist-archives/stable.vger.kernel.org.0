Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B5F745BBE1
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:22:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243865AbhKXMZB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:25:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:38380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243322AbhKXMWZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:22:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DCA4E61163;
        Wed, 24 Nov 2021 12:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756014;
        bh=mNsELqpMKYtIcHJbjReoR2g5UvL0gp2+bmW+CM+TDvk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uMDq9jgKbXWOlPoaeE9QEQUwEUL7g3jhuRwW0YiRdjBgJvLxIbvg+t9tBkrNLgjEX
         +SSO8G81Jfi7hzyAl16a5mLdmE+adWPUaq7l+AV76YJwGb7Ukcf6aQ2RDYBrQ9zB1x
         e3He6hEnAwD0GXEhaPkV3yHcMQGmmihqkRai4JX8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 139/207] dmaengine: dmaengine_desc_callback_valid(): Check for `callback_result`
Date:   Wed, 24 Nov 2021 12:56:50 +0100
Message-Id: <20211124115708.526989530@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115703.941380739@linuxfoundation.org>
References: <20211124115703.941380739@linuxfoundation.org>
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
index 882ff9448c3ba..6537b8ec03934 100644
--- a/drivers/dma/dmaengine.h
+++ b/drivers/dma/dmaengine.h
@@ -167,7 +167,7 @@ dmaengine_desc_get_callback_invoke(struct dma_async_tx_descriptor *tx,
 static inline bool
 dmaengine_desc_callback_valid(struct dmaengine_desc_callback *cb)
 {
-	return (cb->callback) ? true : false;
+	return cb->callback || cb->callback_result;
 }
 
 #endif
-- 
2.33.0



