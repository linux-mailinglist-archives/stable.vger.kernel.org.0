Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5EF63B6199
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235285AbhF1Og4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:36:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:43904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235307AbhF1OfT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:35:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E643F61C8A;
        Mon, 28 Jun 2021 14:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890624;
        bh=0EfZd7DYiKHVWO3GhjofK8wxYjHRVA4dvSvIY09L6tw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EdSIqRJwdW/uzV29ab3daht/RwWWtGfmHZfW9jSJfZZP21MFR3ao1zU2516Duo4hV
         Yxgyf8pGaHUG9TSwgOenCQU0p9K6glSEyRLXx2WiLxgyu3N+KE5xcWoJnjK5uJAc3m
         Fb8OgXefSG9+X16UJby3mEz8rkSD0sda4uobiBkI4j8jJP2zN9l5EeErdMhqKQ3mfW
         K86BuqP3uF1b/JxJs/iFoR2bOv1XdEAUgs9oC4GPocDr0Ph9Gqd5iQtSDND0OodXMG
         Nk6dlHWRHYxkeZQVLQixg6onu6rqAgxYTEYUuCBs2Iy+ebNQ+a4cZIPn8AdQgvZMXk
         N/KNcwOX3q0Ig==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guillaume Ranquet <granquet@baylibre.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 20/71] dmaengine: mediatek: use GFP_NOWAIT instead of GFP_ATOMIC in prep_dma
Date:   Mon, 28 Jun 2021 10:29:13 -0400
Message-Id: <20210628143004.32596-21-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143004.32596-1-sashal@kernel.org>
References: <20210628143004.32596-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.129-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.129-rc1
X-KernelTest-Deadline: 2021-06-30T14:29+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guillaume Ranquet <granquet@baylibre.com>

[ Upstream commit 9041575348b21ade1fb74d790f1aac85d68198c7 ]

As recommended by the doc in:
Documentation/drivers-api/dmaengine/provider.rst

Use GFP_NOWAIT to not deplete the emergency pool.

Signed-off-by: Guillaume Ranquet <granquet@baylibre.com>

Link: https://lore.kernel.org/r/20210513192642.29446-4-granquet@baylibre.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/mediatek/mtk-uart-apdma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/mediatek/mtk-uart-apdma.c b/drivers/dma/mediatek/mtk-uart-apdma.c
index e420e9f72b3d..9c0ea13ca788 100644
--- a/drivers/dma/mediatek/mtk-uart-apdma.c
+++ b/drivers/dma/mediatek/mtk-uart-apdma.c
@@ -349,7 +349,7 @@ static struct dma_async_tx_descriptor *mtk_uart_apdma_prep_slave_sg
 		return NULL;
 
 	/* Now allocate and setup the descriptor */
-	d = kzalloc(sizeof(*d), GFP_ATOMIC);
+	d = kzalloc(sizeof(*d), GFP_NOWAIT);
 	if (!d)
 		return NULL;
 
-- 
2.30.2

