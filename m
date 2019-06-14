Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FAEB469E8
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 22:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727168AbfFNUgF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jun 2019 16:36:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:52090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727177AbfFNU3t (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Jun 2019 16:29:49 -0400
Received: from sasha-vm.mshome.net (unknown [131.107.159.134])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8DEEE21848;
        Fri, 14 Jun 2019 20:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560544188;
        bh=1XWVcna6ibM0e624qpjkh6BRvMNG84hwCnjcEQh/zcg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LcG0ULtSlJS2kIxIiZPHuKHmsykL78+DEWpejEbQMm+r+xXJWXAOs0wHeAJRN29Q4
         PYgkIWS4RK0zcPc1ZdVvh+g7hy4tloZuZR1e0tznP2BAM669kZBadvn/rIJvJAkClS
         krnBxsClz360GxuRBtgWUy6xECTsjjlBq0D3dx30=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 02/39] dmaengine: dw-axi-dmac: fix null dereference when pointer first is null
Date:   Fri, 14 Jun 2019 16:29:07 -0400
Message-Id: <20190614202946.27385-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190614202946.27385-1-sashal@kernel.org>
References: <20190614202946.27385-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 0788611c9a0925c607de536b2449de5ed98ef8df ]

In the unlikely event that axi_desc_get returns a null desc in the
very first iteration of the while-loop the error exit path ends
up calling axi_desc_put on a null pointer 'first' and this causes
a null pointer dereference.  Fix this by adding a null check on
pointer 'first' before calling axi_desc_put.

Addresses-Coverity: ("Explicit null dereference")
Fixes: 1fe20f1b8454 ("dmaengine: Introduce DW AXI DMAC driver")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c b/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
index c4eb55e3011c..c05ef7f1d7b6 100644
--- a/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
+++ b/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
@@ -512,7 +512,8 @@ dma_chan_prep_dma_memcpy(struct dma_chan *dchan, dma_addr_t dst_adr,
 	return vchan_tx_prep(&chan->vc, &first->vd, flags);
 
 err_desc_get:
-	axi_desc_put(first);
+	if (first)
+		axi_desc_put(first);
 	return NULL;
 }
 
-- 
2.20.1

