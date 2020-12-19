Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D45A92DEFAF
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 14:07:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727651AbgLSM6e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 07:58:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:44716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727633AbgLSM6d (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 19 Dec 2020 07:58:33 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Boyd <swboyd@chromium.org>,
        Sujit Kautkar <sujitka@chromium.org>,
        Alex Elder <elder@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 03/49] net: ipa: pass the correct size when freeing DMA memory
Date:   Sat, 19 Dec 2020 13:58:07 +0100
Message-Id: <20201219125344.843872853@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201219125344.671832095@linuxfoundation.org>
References: <20201219125344.671832095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Elder <elder@linaro.org>

[ Upstream commit 1130b252480f3c98cf468e78c1c5c516b390a29c ]

When the coherent memory is freed in gsi_trans_pool_exit_dma(), we
are mistakenly passing the size of a single element in the pool
rather than the actual allocated size.  Fix this bug.

Fixes: 9dd441e4ed575 ("soc: qcom: ipa: GSI transactions")
Reported-by: Stephen Boyd <swboyd@chromium.org>
Tested-by: Sujit Kautkar <sujitka@chromium.org>
Signed-off-by: Alex Elder <elder@linaro.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20201203215106.17450-1-elder@linaro.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ipa/gsi_trans.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/net/ipa/gsi_trans.c
+++ b/drivers/net/ipa/gsi_trans.c
@@ -157,6 +157,9 @@ int gsi_trans_pool_init_dma(struct devic
 	/* The allocator will give us a power-of-2 number of pages.  But we
 	 * can't guarantee that, so request it.  That way we won't waste any
 	 * memory that would be available beyond the required space.
+	 *
+	 * Note that gsi_trans_pool_exit_dma() assumes the total allocated
+	 * size is exactly (count * size).
 	 */
 	total_size = get_order(total_size) << PAGE_SHIFT;
 
@@ -176,7 +179,9 @@ int gsi_trans_pool_init_dma(struct devic
 
 void gsi_trans_pool_exit_dma(struct device *dev, struct gsi_trans_pool *pool)
 {
-	dma_free_coherent(dev, pool->size, pool->base, pool->addr);
+	size_t total_size = pool->count * pool->size;
+
+	dma_free_coherent(dev, total_size, pool->base, pool->addr);
 	memset(pool, 0, sizeof(*pool));
 }
 


