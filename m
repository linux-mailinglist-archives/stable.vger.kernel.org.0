Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D701E21AD
	for <lists+stable@lfdr.de>; Wed, 23 Oct 2019 19:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728715AbfJWRY0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Oct 2019 13:24:26 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:32780 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727079AbfJWRY0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Oct 2019 13:24:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=bG3/WLQ3BKtHlYI3WFB7izs5MtpxdRb40qU5GLuq7Kc=; b=uGPIy0ZlzUq7xee7gYH6zC3G2
        pSrOyTAvWP+Wpg6vgAZSinr7A2/uNC+nOEmCHmCOqLTI8/zJvB+NLkxefC248I+ClUm+cwguY+Nln
        i2myUnQID2xvEzjNYXcRnH8vMWKtCF64XjrlHnPS4x02FrIsPQGxBNGyWP+pHdwlqDXK2KYql6Smm
        b/VttAo5viTNxoBVU/xaMwnpd/goLs5Uf3vsX9NKku6Qk7xB7NAmSuVrOGChBDT/j0bVb7HrZjlZE
        yblsP/9LqUE4osPgpwuuiFPziJsaIIm+qmX4gSbd5fFkKKoVZcevHIu1LvRofn9XdxY1AvtHUgeZx
        ZC6VLKRlA==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iNKMu-0006oY-I8; Wed, 23 Oct 2019 17:24:20 +0000
Date:   Wed, 23 Oct 2019 10:24:20 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Yang Shi <yang.shi@linux.alibaba.com>
Cc:     hughd@google.com, aarcange@redhat.com,
        kirill.shutemov@linux.intel.com, gavin.dg@linux.alibaba.com,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [v2 PATCH] mm: thp: handle page cache THP correctly in
 PageTransCompoundMap
Message-ID: <20191023172420.GB2963@bombadil.infradead.org>
References: <1571850304-82802-1-git-send-email-yang.shi@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1571850304-82802-1-git-send-email-yang.shi@linux.alibaba.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 24, 2019 at 01:05:04AM +0800, Yang Shi wrote:
> +	return map_count >= 0 &&
> +	       map_count == atomic_read(&head[1].compound_mapcount);
>  }

I didn't like Hugh's duplicate definition either.  May I suggest:

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 2f2199a51941..3d0efd937d2b 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -695,11 +695,6 @@ static inline void *kvcalloc(size_t n, size_t size, gfp_t flags)
 
 extern void kvfree(const void *addr);
 
-static inline atomic_t *compound_mapcount_ptr(struct page *page)
-{
-	return &page[1].compound_mapcount;
-}
-
 static inline int compound_mapcount(struct page *page)
 {
 	VM_BUG_ON_PAGE(!PageCompound(page), page);
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 2222fa795284..270aa8fd2800 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -221,6 +221,11 @@ struct page {
 #endif
 } _struct_page_alignment;
 
+static inline atomic_t *compound_mapcount_ptr(struct page *page)
+{
+	return &page[1].compound_mapcount;
+}
+
 /*
  * Used for sizing the vmemmap region on some architectures
  */
