Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D97E05494A1
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344528AbiFMKfD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 06:35:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346362AbiFMKeX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 06:34:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 462BDDCC;
        Mon, 13 Jun 2022 03:22:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 35CC4B80E93;
        Mon, 13 Jun 2022 10:22:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87938C34114;
        Mon, 13 Jun 2022 10:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655115742;
        bh=q4/TRkFKO17K5S6Q52l+i8SN+KZng04nsE2jNUt5RHw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1mwJK2kurEkx07HUhGRDF4ujY6XAh6/U3DwXyYIYYiIx7z56pBGE8wpMALZV+ru3o
         JQN8lePIVF3HjcL6RAyO5EfuZHD7gk52UPvkbCggWWgy+eN+d3QwuYkQaaJuWP50sG
         BMA07Dsm0pj37ELkQWouomzQ4bWTxytPWddRe/Y8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 025/218] dma-debug: change allocation mode from GFP_NOWAIT to GFP_ATIOMIC
Date:   Mon, 13 Jun 2022 12:08:03 +0200
Message-Id: <20220613094914.270206187@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094908.257446132@linuxfoundation.org>
References: <20220613094908.257446132@linuxfoundation.org>
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
 lib/dma-debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index 61e7240947f5..163e0e9b357f 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -465,7 +465,7 @@ EXPORT_SYMBOL(debug_dma_dump_mappings);
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



