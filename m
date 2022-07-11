Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0866756FCFC
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233105AbiGKJti (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:49:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233466AbiGKJs5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:48:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25362BC37;
        Mon, 11 Jul 2022 02:23:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF6C8612FE;
        Mon, 11 Jul 2022 09:23:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E74F9C34115;
        Mon, 11 Jul 2022 09:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531424;
        bh=hSlfljaxN0870y3L7U2AvEFp1w8AZEKDtfWQyHcJPd0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VkCkUJxjQYHxFrSfVGtMiWowapSxEBUED7e6wdrbMLmijhWWdBQlzYTCmgMGKUK5H
         67oho4Qq5fAxLe+eGGX0jSQGDN92nL/RqUV1rTNaUu91N1b0mdObF0bzJaw0ZSpxBX
         3zLxIrfqYZLpIhzQgWd9qt5pNHCGJcepQ8YFOtwQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michal Hocko <mhocko@suse.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 101/230] mm: vmalloc: introduce array allocation functions
Date:   Mon, 11 Jul 2022 11:05:57 +0200
Message-Id: <20220711090606.934875485@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Paolo Bonzini <pbonzini@redhat.com>

[ Upstream commit a8749a35c39903120ec421ef2525acc8e0daa55c ]

Linux has dozens of occurrences of vmalloc(array_size()) and
vzalloc(array_size()).  Allow to simplify the code by providing
vmalloc_array and vcalloc, as well as the underscored variants that let
the caller specify the GFP flags.

Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/vmalloc.h |  5 +++++
 mm/util.c               | 50 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 55 insertions(+)

diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index 4fe9e885bbfa..5535be1012a2 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -159,6 +159,11 @@ void *__vmalloc_node(unsigned long size, unsigned long align, gfp_t gfp_mask,
 		int node, const void *caller);
 void *vmalloc_no_huge(unsigned long size);
 
+extern void *__vmalloc_array(size_t n, size_t size, gfp_t flags) __alloc_size(1, 2);
+extern void *vmalloc_array(size_t n, size_t size) __alloc_size(1, 2);
+extern void *__vcalloc(size_t n, size_t size, gfp_t flags) __alloc_size(1, 2);
+extern void *vcalloc(size_t n, size_t size) __alloc_size(1, 2);
+
 extern void vfree(const void *addr);
 extern void vfree_atomic(const void *addr);
 
diff --git a/mm/util.c b/mm/util.c
index 3073de05c2bd..ea04979f131e 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -698,6 +698,56 @@ static inline void *__page_rmapping(struct page *page)
 	return (void *)mapping;
 }
 
+/**
+ * __vmalloc_array - allocate memory for a virtually contiguous array.
+ * @n: number of elements.
+ * @size: element size.
+ * @flags: the type of memory to allocate (see kmalloc).
+ */
+void *__vmalloc_array(size_t n, size_t size, gfp_t flags)
+{
+	size_t bytes;
+
+	if (unlikely(check_mul_overflow(n, size, &bytes)))
+		return NULL;
+	return __vmalloc(bytes, flags);
+}
+EXPORT_SYMBOL(__vmalloc_array);
+
+/**
+ * vmalloc_array - allocate memory for a virtually contiguous array.
+ * @n: number of elements.
+ * @size: element size.
+ */
+void *vmalloc_array(size_t n, size_t size)
+{
+	return __vmalloc_array(n, size, GFP_KERNEL);
+}
+EXPORT_SYMBOL(vmalloc_array);
+
+/**
+ * __vcalloc - allocate and zero memory for a virtually contiguous array.
+ * @n: number of elements.
+ * @size: element size.
+ * @flags: the type of memory to allocate (see kmalloc).
+ */
+void *__vcalloc(size_t n, size_t size, gfp_t flags)
+{
+	return __vmalloc_array(n, size, flags | __GFP_ZERO);
+}
+EXPORT_SYMBOL(__vcalloc);
+
+/**
+ * vcalloc - allocate and zero memory for a virtually contiguous array.
+ * @n: number of elements.
+ * @size: element size.
+ */
+void *vcalloc(size_t n, size_t size)
+{
+	return __vmalloc_array(n, size, GFP_KERNEL | __GFP_ZERO);
+}
+EXPORT_SYMBOL(vcalloc);
+
 /* Neutral page->mapping pointer to address_space or anon_vma or other */
 void *page_rmapping(struct page *page)
 {
-- 
2.35.1



