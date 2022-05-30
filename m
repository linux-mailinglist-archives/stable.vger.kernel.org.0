Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 978605382D3
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238579AbiE3O2e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 10:28:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240661AbiE3OZU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 10:25:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A7E4ABF58;
        Mon, 30 May 2022 06:50:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C15E60FCC;
        Mon, 30 May 2022 13:50:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEBB5C3411C;
        Mon, 30 May 2022 13:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653918628;
        bh=HK2bUnN9u8Hcgp6SbPKH4JTNsovTrTAGTlyslCynbNI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dw6sOchjboFN4Y4ExjU/2+yD+7Ehpf8mX0/GMNXm6tMVX9A3TwpZ+TZgLWtsXbSoQ
         eGFB70NACQzYpygtWSisNcprHSIeUh/+PNUJ8DzX7mIHPnqXDr1AwcnJ3OYAXG0G/E
         LFpw0ZhOA39Y36DhgiQzeAUzs9GiCLOAVaP+mz5oXnU3jYDbXXnlDGKhfnauBwy4r4
         CzOmAp8ZEQ16pX1UFffMO4h23IG/HDocEgV+l3IqG1DOvmDmPVA/h1ftwCgRsAZ4LT
         ic6F3FawAH3Htl2WGCswH2yWBrsq4FA+FEBpSEz44JYo+8KLG3S/HLb2d8GAtskr8N
         Cs58mSri3iSGw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mikulas Patocka <mpatocka@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, m.szyprowski@samsung.com,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 4.19 26/38] dma-debug: change allocation mode from GFP_NOWAIT to GFP_ATIOMIC
Date:   Mon, 30 May 2022 09:49:12 -0400
Message-Id: <20220530134924.1936816-26-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530134924.1936816-1-sashal@kernel.org>
References: <20220530134924.1936816-1-sashal@kernel.org>
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
index 9c9a5b12f92f..7c6cd00d0fca 100644
--- a/kernel/dma/debug.c
+++ b/kernel/dma/debug.c
@@ -469,7 +469,7 @@ void debug_dma_dump_mappings(struct device *dev)
  * At any time debug_dma_assert_idle() can be called to trigger a
  * warning if any cachelines in the given page are in the active set.
  */
-static RADIX_TREE(dma_active_cacheline, GFP_NOWAIT);
+static RADIX_TREE(dma_active_cacheline, GFP_ATOMIC);
 static DEFINE_SPINLOCK(radix_lock);
 #define ACTIVE_CACHELINE_MAX_OVERLAP ((1 << RADIX_TREE_MAX_TAGS) - 1)
 #define CACHELINE_PER_PAGE_SHIFT (PAGE_SHIFT - L1_CACHE_SHIFT)
-- 
2.35.1

