Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08FBE4D1554
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 11:59:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346058AbiCHLA1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 06:00:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346063AbiCHLAZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 06:00:25 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DFDD2433A4
        for <stable@vger.kernel.org>; Tue,  8 Mar 2022 02:59:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646737168;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iRvTRLpjbDLOx0VqbXyM4lpVNCGi5++MSF5TUnleufc=;
        b=Gpjt+H9pxZfgr6e9RcwIlhQl1YylqhOz7G4BOkyBsMVN5y4qiyC+mkuEsWwBKsA7PjPVf7
        kxP9Rz6FZQbbE7/JmqDBgSQQgfmLXDgJMOJ2e7l5+2P32wMSLJlwsNAiaYf0OLJV+a9NL+
        hyWMFw6pMboEdFode4yGh4yyefVdErc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-407-O4Nm8WHmOeShJnwzttdIGg-1; Tue, 08 Mar 2022 05:59:24 -0500
X-MC-Unique: O4Nm8WHmOeShJnwzttdIGg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 67B9F1006AA7;
        Tue,  8 Mar 2022 10:59:22 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7884E752D3;
        Tue,  8 Mar 2022 10:59:21 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 1/3] mm: vmalloc: introduce array allocation functions
Date:   Tue,  8 Mar 2022 05:59:16 -0500
Message-Id: <20220308105918.615575-2-pbonzini@redhat.com>
In-Reply-To: <20220308105918.615575-1-pbonzini@redhat.com>
References: <20220308105918.615575-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Linux has dozens of occurrences of vmalloc(array_size()) and
vzalloc(array_size()).  Allow to simplify the code by providing
vmalloc_array and vcalloc, as well as the underscored variants that let
the caller specify the GFP flags.

Cc: stable@vger.kernel.org
Cc: linux-mm@kvack.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 include/linux/vmalloc.h |  5 +++++
 mm/util.c               | 50 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 55 insertions(+)

diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index 880227b9f044..d1bbd4fd50c5 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -159,6 +159,11 @@ void *__vmalloc_node(unsigned long size, unsigned long align, gfp_t gfp_mask,
 		int node, const void *caller) __alloc_size(1);
 void *vmalloc_no_huge(unsigned long size) __alloc_size(1);
 
+extern void *__vmalloc_array(size_t n, size_t size, gfp_t flags) __alloc_size(1, 2);
+extern void *vmalloc_array(size_t n, size_t size) __alloc_size(1, 2);
+extern void *__vcalloc(size_t n, size_t size, gfp_t flags) __alloc_size(1, 2);
+extern void *vcalloc(size_t n, size_t size) __alloc_size(1, 2);
+
 extern void vfree(const void *addr);
 extern void vfree_atomic(const void *addr);
 
diff --git a/mm/util.c b/mm/util.c
index 7e43369064c8..94475abe54a0 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -647,6 +647,56 @@ void *kvrealloc(const void *p, size_t oldsize, size_t newsize, gfp_t flags)
 }
 EXPORT_SYMBOL(kvrealloc);
 
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
2.31.1

