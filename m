Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B793C538026
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239734AbiE3OKG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 10:10:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240171AbiE3OGg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 10:06:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A8B33DDF3;
        Mon, 30 May 2022 06:42:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 219F460FA9;
        Mon, 30 May 2022 13:42:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92C6EC385B8;
        Mon, 30 May 2022 13:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653918121;
        bh=7Cf6JB2q1A9OGemJDYVSx1pjXiSzVu0Yuw1kwfazgNM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JyrcZop0k84B7t3AW/VN/h4fxs6x7wkFGwIH6Cosbb0Is14BXsMIXVEC9xPt50cRp
         ZR2xhz6t5EgKUGkSlrsb92rUJjMsliXwAZVYh13ObCGWnn0Nvzl5pvpjIT9FnDPEml
         4ZXMx4+U4EbcD/RYYgLu1YOIzRkLSDDyZ6m4g0tz8X2ajrX9qmUWny7K3iDmSFkY79
         jx+WDt8Sg/ezmli2f7nWbWD6vhRST4djbA5o+PsmeQn71PlbD5O0idIbJcsbU0+qt5
         ddgA2BFSGs6Z1eG60fFhnNuNMnfVoRLIizTwyqKb1syHNfGdzOW/IVenrrhszkdZvH
         Bj2TiSlMa8ztQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mikulas Patocka <mpatocka@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, m.szyprowski@samsung.com,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.15 069/109] dma-debug: change allocation mode from GFP_NOWAIT to GFP_ATIOMIC
Date:   Mon, 30 May 2022 09:37:45 -0400
Message-Id: <20220530133825.1933431-69-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530133825.1933431-1-sashal@kernel.org>
References: <20220530133825.1933431-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 84bc4f1dbbbb5f8aa68706a96711dccb28b518e5 ]

We observed the error "cacheline tracking ENOMEM, dma-debug disabled"
during a light system load (copying some files). The reason for this error
is that the dma_active_cacheline radix tree uses GFP_NOWAIT allocation -
so it can't access the emergency memory reserves and it fails as soon as
anybody reaches the watermark.

This patch changes GFP_NOWAIT to GFP_ATOMIC, so that it can access the
emergency memory reserves.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/dma/debug.c b/kernel/dma/debug.c
index f8ff598596b8..ac740630c79c 100644
--- a/kernel/dma/debug.c
+++ b/kernel/dma/debug.c
@@ -448,7 +448,7 @@ void debug_dma_dump_mappings(struct device *dev)
  * other hand, consumes a single dma_debug_entry, but inserts 'nents'
  * entries into the tree.
  */
-static RADIX_TREE(dma_active_cacheline, GFP_NOWAIT);
+static RADIX_TREE(dma_active_cacheline, GFP_ATOMIC);
 static DEFINE_SPINLOCK(radix_lock);
 #define ACTIVE_CACHELINE_MAX_OVERLAP ((1 << RADIX_TREE_MAX_TAGS) - 1)
 #define CACHELINE_PER_PAGE_SHIFT (PAGE_SHIFT - L1_CACHE_SHIFT)
-- 
2.35.1

