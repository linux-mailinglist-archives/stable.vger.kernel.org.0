Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C40385B7037
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233477AbiIMOVq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:21:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233808AbiIMOUG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:20:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30D5610573;
        Tue, 13 Sep 2022 07:14:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2376F614B7;
        Tue, 13 Sep 2022 14:13:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CD19C433C1;
        Tue, 13 Sep 2022 14:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078379;
        bh=MSdg/gfZFyqlmyvEJyn8JOVNcmpXWwNVwBkr0+cN1yQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PFE+/T0F/8PtT8ZzxAD5XF+fd5KTuimOwXLid/9znw8MxGLienI7C5LWZWZ+jL+MK
         ajEYtCe/4wk6TQ6IFYOIwS7lAZHZPsF/xZUw/CmMDoIIwnW2l8L06CCfaQ0EaVugN2
         CMAUrLcFHRen7Ru0dYlVkNuhtw5IxzyPMbP8ZRAk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 117/192] net: introduce __skb_fill_page_desc_noacc
Date:   Tue, 13 Sep 2022 16:03:43 +0200
Message-Id: <20220913140415.813430563@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 84ce071e38a6e25ea3ea91188e5482ac1f17b3af ]

Managed pages contain pinned userspace pages and controlled by upper
layers, there is no need in tracking skb->pfmemalloc for them. Introduce
a helper for filling frags but ignoring page tracking, it'll be needed
later.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/skbuff.h | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 2f41364a6791e..b0a1374043f30 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -2528,6 +2528,22 @@ static inline unsigned int skb_pagelen(const struct sk_buff *skb)
 	return skb_headlen(skb) + __skb_pagelen(skb);
 }
 
+static inline void __skb_fill_page_desc_noacc(struct skb_shared_info *shinfo,
+					      int i, struct page *page,
+					      int off, int size)
+{
+	skb_frag_t *frag = &shinfo->frags[i];
+
+	/*
+	 * Propagate page pfmemalloc to the skb if we can. The problem is
+	 * that not all callers have unique ownership of the page but rely
+	 * on page_is_pfmemalloc doing the right thing(tm).
+	 */
+	frag->bv_page		  = page;
+	frag->bv_offset		  = off;
+	skb_frag_size_set(frag, size);
+}
+
 /**
  * __skb_fill_page_desc - initialise a paged fragment in an skb
  * @skb: buffer containing fragment to be initialised
@@ -2544,17 +2560,7 @@ static inline unsigned int skb_pagelen(const struct sk_buff *skb)
 static inline void __skb_fill_page_desc(struct sk_buff *skb, int i,
 					struct page *page, int off, int size)
 {
-	skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
-
-	/*
-	 * Propagate page pfmemalloc to the skb if we can. The problem is
-	 * that not all callers have unique ownership of the page but rely
-	 * on page_is_pfmemalloc doing the right thing(tm).
-	 */
-	frag->bv_page		  = page;
-	frag->bv_offset		  = off;
-	skb_frag_size_set(frag, size);
-
+	__skb_fill_page_desc_noacc(skb_shinfo(skb), i, page, off, size);
 	page = compound_head(page);
 	if (page_is_pfmemalloc(page))
 		skb->pfmemalloc	= true;
-- 
2.35.1



