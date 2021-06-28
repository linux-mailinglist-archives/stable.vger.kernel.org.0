Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 346383B60ED
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233598AbhF1ObQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:31:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:37368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234625AbhF1OaM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:30:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B330161CB1;
        Mon, 28 Jun 2021 14:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890397;
        bh=zwjrpBQ7o0x2xqtiyXHPgA7MFvj9vARlzFvp3O45wJc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U3vm6fop12hkoVesnm/XIXerjVedYSwYQoc49m9LKBFiI/vlEHEPQEUHF/2hvTcCv
         C5wFBld6y2BnKS+vufblOzcGX9FNV/fvwyWyD3jthBZfuNuSTkVDeVPsd4Zqddu6fJ
         UqaHOh6g7EIOsTsSOH5V9WpoBleAJrDqCKRt07/zP/Ph7H53BOXejKDdleJxgIiVyb
         9YWu76zWfW9IjzlA5GFa43vl4SvrZXjTSg+38lZLmSzhew3o0gL2w6oxk2tGuSi75/
         7lW40SwzhrD/lGYGb9YfEdX7g/WnYc2IzVwcudA93xfv5g8Y0e2mLzC3/ANzW+kzsP
         TgreXhnF+FMhA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guillaume Ranquet <granquet@baylibre.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 032/101] dmaengine: mediatek: use GFP_NOWAIT instead of GFP_ATOMIC in prep_dma
Date:   Mon, 28 Jun 2021 10:24:58 -0400
Message-Id: <20210628142607.32218-33-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628142607.32218-1-sashal@kernel.org>
References: <20210628142607.32218-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.47-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.47-rc1
X-KernelTest-Deadline: 2021-06-30T14:25+00:00
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
index a09ab2dd3b46..375e7e647df6 100644
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

