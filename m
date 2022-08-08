Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 598B058BF73
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242649AbiHHBkG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:40:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242507AbiHHBjT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:39:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FB3D101C6;
        Sun,  7 Aug 2022 18:34:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E775E60DF4;
        Mon,  8 Aug 2022 01:34:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FBD6C433D6;
        Mon,  8 Aug 2022 01:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922460;
        bh=0/Kxnd+QUuc9UVG//nKSwl1HMXqNHbK9ICtv8Ir5lfY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qIyQ06DEoHAUekO7mBsCA93pfVQ7tHFwuF1dAJOhjOFfKM7TqBIyGVg2TeYBCTHV4
         eBD5UAPKwvpKWOd+lkJkgawIt2b3TTwAo9Qpnui7489zi/llzg6YQyBFw/hRsPu/bl
         bItcsgeWrEP3SYttQwBfSyOKWF5kUWC7ek+24XGK6nehRn1LoyNYZr6dYDGLKV87dZ
         RlZ0IuczBcgNrlZvca46qHAaNTxglm6Wz0bHTBkF5Ut12S+mdeHpyL1MIgC65J89pe
         iEJLKPZDOp/fsYN3jBI/GgVaPQnR1WDdZp5c4RFO2Is/j7BEQoB5E0RVZB+BvWO2TT
         TnVexCNaM6ITQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>,
        kasan-dev@googlegroups.com, linux-mm@kvack.org
Subject: [PATCH AUTOSEL 5.18 08/53] mm: kasan: Ensure the tags are visible before the tag in page->flags
Date:   Sun,  7 Aug 2022 21:33:03 -0400
Message-Id: <20220808013350.314757-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808013350.314757-1-sashal@kernel.org>
References: <20220808013350.314757-1-sashal@kernel.org>
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

From: Catalin Marinas <catalin.marinas@arm.com>

[ Upstream commit ed0a6d1d973e9763989b44913ae1bd2a5d5d5777 ]

__kasan_unpoison_pages() colours the memory with a random tag and stores
it in page->flags in order to re-create the tagged pointer via
page_to_virt() later. When the tag from the page->flags is read, ensure
that the in-memory tags are already visible by re-ordering the
page_kasan_tag_set() after kasan_unpoison(). The former already has
barriers in place through try_cmpxchg(). On the reader side, the order
is ensured by the address dependency between page->flags and the memory
access.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Reviewed-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Link: https://lore.kernel.org/r/20220610152141.2148929-2-catalin.marinas@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/kasan/common.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/kasan/common.c b/mm/kasan/common.c
index d9079ec11f31..f6b8dc4f354b 100644
--- a/mm/kasan/common.c
+++ b/mm/kasan/common.c
@@ -108,9 +108,10 @@ void __kasan_unpoison_pages(struct page *page, unsigned int order, bool init)
 		return;
 
 	tag = kasan_random_tag();
+	kasan_unpoison(set_tag(page_address(page), tag),
+		       PAGE_SIZE << order, init);
 	for (i = 0; i < (1 << order); i++)
 		page_kasan_tag_set(page + i, tag);
-	kasan_unpoison(page_address(page), PAGE_SIZE << order, init);
 }
 
 void __kasan_poison_pages(struct page *page, unsigned int order, bool init)
-- 
2.35.1

