Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29C19541C23
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347144AbiFGV4d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:56:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382883AbiFGVwC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:52:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E95C23F234;
        Tue,  7 Jun 2022 12:09:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 58017617DA;
        Tue,  7 Jun 2022 19:09:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62AD8C385A2;
        Tue,  7 Jun 2022 19:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628992;
        bh=6+X3r+SmwZkR8Bjt3sCvukd/lbvONYbu3LJTaLIiXWY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rGgvXs7YFnGKyHolotee7YLspmwcWqp5s41EV7yHgSOZW2uTZPmQs20a5nj0W37Tf
         bFOb7V2UUWOGUL3lT1tVzcQOIs+NiyF3gTz6iOpWwQAyMLGNGHr0X1X2kSXIuOFXTj
         bgh3S/Y76JqJ8m5hSKaObjkY+0OjWtnJaua58OiM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
        Christoph Hellwig <hch@lst.de>,
        David Rientjes <rientjes@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 529/879] dma-direct: dont over-decrypt memory
Date:   Tue,  7 Jun 2022 19:00:47 +0200
Message-Id: <20220607165018.230271846@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robin Murphy <robin.murphy@arm.com>

[ Upstream commit 4a37f3dd9a83186cb88d44808ab35b78375082c9 ]

The original x86 sev_alloc() only called set_memory_decrypted() on
memory returned by alloc_pages_node(), so the page order calculation
fell out of that logic. However, the common dma-direct code has several
potential allocators, not all of which are guaranteed to round up the
underlying allocation to a power-of-two size, so carrying over that
calculation for the encryption/decryption size was a mistake. Fix it by
rounding to a *number* of pages, rather than an order.

Until recently there was an even worse interaction with DMA_DIRECT_REMAP
where we could have ended up decrypting part of the next adjacent
vmalloc area, only averted by no architecture actually supporting both
configs at once. Don't ask how I found that one out...

Fixes: c10f07aa27da ("dma/direct: Handle force decryption for DMA coherent buffers in common code")
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/direct.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index 3e7f4aab740e..e978f36e6be8 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -79,7 +79,7 @@ static int dma_set_decrypted(struct device *dev, void *vaddr, size_t size)
 {
 	if (!force_dma_unencrypted(dev))
 		return 0;
-	return set_memory_decrypted((unsigned long)vaddr, 1 << get_order(size));
+	return set_memory_decrypted((unsigned long)vaddr, PFN_UP(size));
 }
 
 static int dma_set_encrypted(struct device *dev, void *vaddr, size_t size)
@@ -88,7 +88,7 @@ static int dma_set_encrypted(struct device *dev, void *vaddr, size_t size)
 
 	if (!force_dma_unencrypted(dev))
 		return 0;
-	ret = set_memory_encrypted((unsigned long)vaddr, 1 << get_order(size));
+	ret = set_memory_encrypted((unsigned long)vaddr, PFN_UP(size));
 	if (ret)
 		pr_warn_ratelimited("leaking DMA memory that can't be re-encrypted\n");
 	return ret;
-- 
2.35.1



