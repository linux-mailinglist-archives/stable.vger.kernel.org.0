Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02DD86677CD
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:49:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239576AbjALOtN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:49:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238976AbjALOsJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:48:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11560DFE
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:35:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0048B81E83
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:35:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DCFBC433F2;
        Thu, 12 Jan 2023 14:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673534140;
        bh=nCb7nb9dDDVzNBydQH6vA7yL9BpgGm2g4edGpMUyzlc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1bPXSfz0XBkGZP8Q4AciK08lnHxlW7MMCUrzrkBJ2CicLPFWtzfLmYu3CCn8RexcX
         sQPRu4IQy+nWuEIwVw/ttGXBBnkKqqezIU2XSLK+dcmYD0juQZs1v1S4TChQS4c2AF
         jbMvl1zJ+j3ca4lm9PjQtbsz4bNnyoiS2m1VPUzk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Boris Pismenny <borisp@mellanox.com>,
        Or Gerlitz <gerlitz.or@gmail.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Eric Biggers <ebiggers@kernel.org>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        Ira Weiny <ira.weiny@intel.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 709/783] mm/highmem: Lift memcpy_[to|from]_page to core
Date:   Thu, 12 Jan 2023 14:57:05 +0100
Message-Id: <20230112135557.239848796@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ira Weiny <ira.weiny@intel.com>

[ Upstream commit bb90d4bc7b6a536b2e4db45f4763e467c2008251 ]

Working through a conversion to a call kmap_local_page() instead of
kmap() revealed many places where the pattern kmap/memcpy/kunmap
occurred.

Eric Biggers, Matthew Wilcox, Christoph Hellwig, Dan Williams, and Al
Viro all suggested putting this code into helper functions.  Al Viro
further pointed out that these functions already existed in the iov_iter
code.[1]

Various locations for the lifted functions were considered.

Headers like mm.h or string.h seem ok but don't really portray the
functionality well.  pagemap.h made some sense but is for page cache
functionality.[2]

Another alternative would be to create a new header for the promoted
memcpy functions, but it masks the fact that these are designed to copy
to/from pages using the kernel direct mappings and complicates matters
with a new header.

Placing these functions in 'highmem.h' is suboptimal especially with the
changes being proposed in the functionality of kmap.  From a caller
perspective including/using 'highmem.h' implies that the functions
defined in that header are only required when highmem is in use which is
increasingly not the case with modern processors.  However, highmem.h is
where all the current functions like this reside (zero_user(),
clear_highpage(), clear_user_highpage(), copy_user_highpage(), and
copy_highpage()).  So it makes the most sense even though it is
distasteful for some.[3]

Lift memcpy_to_page() and memcpy_from_page() to pagemap.h.

[1] https://lore.kernel.org/lkml/20201013200149.GI3576660@ZenIV.linux.org.uk/
    https://lore.kernel.org/lkml/20201013112544.GA5249@infradead.org/

[2] https://lore.kernel.org/lkml/20201208122316.GH7338@casper.infradead.org/

[3] https://lore.kernel.org/lkml/20201013200149.GI3576660@ZenIV.linux.org.uk/#t
    https://lore.kernel.org/lkml/20201208163814.GN1563847@iweiny-DESK2.sc.intel.com/

Cc: Boris Pismenny <borisp@mellanox.com>
Cc: Or Gerlitz <gerlitz.or@gmail.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Suggested-by: Christoph Hellwig <hch@infradead.org>
Suggested-by: Dan Williams <dan.j.williams@intel.com>
Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Suggested-by: Eric Biggers <ebiggers@kernel.org>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 956510c0c743 ("fs: ext4: initialize fsdata in pagecache_write()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/highmem.h | 18 ++++++++++++++++++
 lib/iov_iter.c          | 14 --------------
 2 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index 14e6202ce47f..b25df1f8d48d 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -345,4 +345,22 @@ static inline void copy_highpage(struct page *to, struct page *from)
 
 #endif
 
+static inline void memcpy_from_page(char *to, struct page *page,
+				    size_t offset, size_t len)
+{
+	char *from = kmap_atomic(page);
+
+	memcpy(to, from + offset, len);
+	kunmap_atomic(from);
+}
+
+static inline void memcpy_to_page(struct page *page, size_t offset,
+				  const char *from, size_t len)
+{
+	char *to = kmap_atomic(page);
+
+	memcpy(to + offset, from, len);
+	kunmap_atomic(to);
+}
+
 #endif /* _LINUX_HIGHMEM_H */
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 650554964f18..6e30113303ba 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -467,20 +467,6 @@ void iov_iter_init(struct iov_iter *i, unsigned int direction,
 }
 EXPORT_SYMBOL(iov_iter_init);
 
-static void memcpy_from_page(char *to, struct page *page, size_t offset, size_t len)
-{
-	char *from = kmap_atomic(page);
-	memcpy(to, from + offset, len);
-	kunmap_atomic(from);
-}
-
-static void memcpy_to_page(struct page *page, size_t offset, const char *from, size_t len)
-{
-	char *to = kmap_atomic(page);
-	memcpy(to + offset, from, len);
-	kunmap_atomic(to);
-}
-
 static void memzero_page(struct page *page, size_t offset, size_t len)
 {
 	char *addr = kmap_atomic(page);
-- 
2.35.1



