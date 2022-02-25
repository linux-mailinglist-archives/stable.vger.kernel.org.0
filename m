Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA874C515F
	for <lists+stable@lfdr.de>; Fri, 25 Feb 2022 23:16:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230519AbiBYWRE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Feb 2022 17:17:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbiBYWRE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Feb 2022 17:17:04 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34F8918F225
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 14:16:31 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id i1so5930889plr.2
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 14:16:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=r3UP7sPeOE4tpdOZPQATV5IzX0JqoKCyo0Zu8w+yg68=;
        b=cwzZ+z3+KNNPi5VuoY5g5Mm7AaXgLz08dHXsMzB+MR31s6wqXa+tCeTmE9+ysLd5BD
         fJpMa+FxWBITL2PrYQMv2VSlaVI255BXR6egh3HWuU0yR7XMZgzbjwb7GFrm7qww8onl
         AoE5BybnANZ8N/qlzz5rGhzJLWqQ/dDnY2OwU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=r3UP7sPeOE4tpdOZPQATV5IzX0JqoKCyo0Zu8w+yg68=;
        b=pq03/EJIpomG41sSzOdfnqkJHMb6xTyy9Toec0ABwsTJXs94+4o3bHUS+R8vqfwmIM
         lWJFqzGVtgJzLMA0Mv4DZTrRfkDtzfubzPbz4yzfCym+WY5tchKGbWngkToC9FYv6bRU
         Z0AKNach/r2NGEoAQdZuJpPMXmg5+PUeQprEDSdYf4M5PsEkaRo/23adKtujwo95YCIf
         9hVhcIHP7JolSjMlf7qafIRKPTeXd9dAaHYDrP+G9XsJfiS7NC3HD/GRP/TeVH0SvfD8
         csZiwH6mx2EURuIaI71CrDjJ1phj8gJ8C481BdP3oC4w39eOvfigv53w0nj4ZEzPE2hy
         T3Gg==
X-Gm-Message-State: AOAM530XVfU/pt0Ncpsrmb5WRhWlZKArpSt2bVKLBydwWT1yAmQr2n8u
        18wJ8Yh4xzSUuXZuvjKk3pvt+Q==
X-Google-Smtp-Source: ABdhPJzMO0XmsB2Ylb7z3PBT/wwN9Bg5Lb62ntAtlDJaBxTGiqEJ8nNIZ4XE3X5AvapcOZmE2Rh/Kg==
X-Received: by 2002:a17:902:e9c2:b0:14f:edeb:4b99 with SMTP id 2-20020a170902e9c200b0014fedeb4b99mr9057948plk.67.1645827390703;
        Fri, 25 Feb 2022 14:16:30 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id il17-20020a17090b165100b001bcd92fd355sm3489471pjb.28.2022.02.25.14.16.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Feb 2022 14:16:30 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     llvm@lists.linux.dev
Cc:     Kees Cook <keescook@chromium.org>, Marco Elver <elver@google.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>, linux-mm@kvack.org,
        stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Christoph Lameter <cl@linux.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Daniel Micay <danielmicay@gmail.com>,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: [PATCH] mm: Handle ksize() vs __alloc_size by forgetting size
Date:   Fri, 25 Feb 2022 14:16:25 -0800
Message-Id: <20220225221625.3531852-1-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4876; h=from:subject; bh=ngJf13CKEOSfIOvi/uk/FkUtfIKyiY96MAZ3FgS6iVA=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBiGVU5zB3C19q1mxFo1Mzgjm0mZS1MOKexM4K+phaS h17iA9aJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYhlVOQAKCRCJcvTf3G3AJr02D/ 9R0hItTprzV5mWNM8aCcX8L0F2v+v/e95RyzyLo1T7LwWVhuj3YWxObRY9FdOwFwxm9ZStrcp1DzKD 7Ma4Spws5QkpSywumc3NE/bvcFsiQAkjKTRH2gCETGC8mR5Tjlbu0AfXsaJ5GSwMIgKDNIOG8IsB05 sAjOzuEBwjB80XDX6LkCwTJ2PmT2X7PR/08PG4YsznVQ652jSZgp8ct86o/UJzbvjYZd5uGtNUE5OS Xe1YVaagQc1vQQ8YtcpOHbOyMoJ7V9NKvjL4QoMjOehY8f/Pheg4VoKk/n385neXo6qOoxxD2QNPUn DDZdMg4gZH6C/R049bmaaK8O+70Jz06PAyVpPUGQb1otFaGhsFwNbbhRk7dEFmbreQ8RgTN04FqOi6 Bsc8+r4aBkCckXO+Wtf2a2r7TIMQQi7kDkocM8rrjBe5EbUESv6ARikUDWWggtbDXkRkSCTNJp/jkg 69YqnTPy1oVQW72DSvsxc8Xwk1StTyy/23s4OiNfptDmBJSlK8SAwMQ7Ur/EHNc2SMhpxkxggisrfK 8VDE2Fk8jYI2jbxLsPyDCjw25Cb4YnMiYf3Wut7w00wJDZwGIWzO7Fhp04m85JeK97srjM1MijrCx+ t7H7HNVY0fh8eCrbcnpLFL5ETTKnY5lLSx0Dyj5X8ml3az/gU1ubUmeyPsCA==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If ksize() is used on an allocation, the compiler cannot make any
assumptions about its size any more (as hinted by __alloc_size). Force
it to forget.

One caller was using a container_of() construction that needed to be
worked around.

Cc: Marco Elver <elver@google.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: linux-mm@kvack.org
Link: https://github.com/ClangBuiltLinux/linux/issues/1599
Fixes: c37495d6254c ("slab: add __alloc_size attributes for better bounds checking")
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
This appears to work for me, but I'm waiting for more feedback on
the specific instance got tripped over in Android.
---
 drivers/base/devres.c |  4 +++-
 include/linux/slab.h  | 26 +++++++++++++++++++++++++-
 mm/slab_common.c      | 19 +++----------------
 3 files changed, 31 insertions(+), 18 deletions(-)

diff --git a/drivers/base/devres.c b/drivers/base/devres.c
index eaa9a5cd1db9..1a2645bd7234 100644
--- a/drivers/base/devres.c
+++ b/drivers/base/devres.c
@@ -855,6 +855,7 @@ void *devm_krealloc(struct device *dev, void *ptr, size_t new_size, gfp_t gfp)
 	size_t total_new_size, total_old_size;
 	struct devres *old_dr, *new_dr;
 	unsigned long flags;
+	void *allocation;
 
 	if (unlikely(!new_size)) {
 		devm_kfree(dev, ptr);
@@ -874,7 +875,8 @@ void *devm_krealloc(struct device *dev, void *ptr, size_t new_size, gfp_t gfp)
 	if (!check_dr_size(new_size, &total_new_size))
 		return NULL;
 
-	total_old_size = ksize(container_of(ptr, struct devres, data));
+	allocation = container_of(ptr, struct devres, data);
+	total_old_size = ksize(allocation);
 	if (total_old_size == 0) {
 		WARN(1, "Pointer doesn't point to dynamically allocated memory.");
 		return NULL;
diff --git a/include/linux/slab.h b/include/linux/slab.h
index 37bde99b74af..a14f3bfa2f44 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -182,8 +182,32 @@ int kmem_cache_shrink(struct kmem_cache *s);
 void * __must_check krealloc(const void *objp, size_t new_size, gfp_t flags) __alloc_size(2);
 void kfree(const void *objp);
 void kfree_sensitive(const void *objp);
+
+/**
+ * ksize - get the actual amount of memory allocated for a given object
+ * @objp: Pointer to the object
+ *
+ * kmalloc may internally round up allocations and return more memory
+ * than requested. ksize() can be used to determine the actual amount of
+ * memory allocated. The caller may use this additional memory, even though
+ * a smaller amount of memory was initially specified with the kmalloc call.
+ * The caller must guarantee that objp points to a valid object previously
+ * allocated with either kmalloc() or kmem_cache_alloc(). The object
+ * must not be freed during the duration of the call.
+ *
+ * Return: size of the actual memory used by @objp in bytes
+ */
+#define ksize(objp) ({							\
+	/*								\
+	 * Getting the actual allocation size means the __alloc_size	\
+	 * hints are no longer valid, and the compiler needs to		\
+	 * forget about them.						\
+	 */								\
+	OPTIMIZER_HIDE_VAR(objp);					\
+	_ksize(objp);							\
+})
 size_t __ksize(const void *objp);
-size_t ksize(const void *objp);
+size_t _ksize(const void *objp);
 #ifdef CONFIG_PRINTK
 bool kmem_valid_obj(void *object);
 void kmem_dump_obj(void *object);
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 23f2ab0713b7..ba5fa8481396 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1245,21 +1245,8 @@ void kfree_sensitive(const void *p)
 }
 EXPORT_SYMBOL(kfree_sensitive);
 
-/**
- * ksize - get the actual amount of memory allocated for a given object
- * @objp: Pointer to the object
- *
- * kmalloc may internally round up allocations and return more memory
- * than requested. ksize() can be used to determine the actual amount of
- * memory allocated. The caller may use this additional memory, even though
- * a smaller amount of memory was initially specified with the kmalloc call.
- * The caller must guarantee that objp points to a valid object previously
- * allocated with either kmalloc() or kmem_cache_alloc(). The object
- * must not be freed during the duration of the call.
- *
- * Return: size of the actual memory used by @objp in bytes
- */
-size_t ksize(const void *objp)
+/* Should not be called directly: use "ksize" macro wrapper. */
+size_t _ksize(const void *objp)
 {
 	size_t size;
 
@@ -1289,7 +1276,7 @@ size_t ksize(const void *objp)
 	kasan_unpoison_range(objp, size);
 	return size;
 }
-EXPORT_SYMBOL(ksize);
+EXPORT_SYMBOL(_ksize);
 
 /* Tracepoints definitions. */
 EXPORT_TRACEPOINT_SYMBOL(kmalloc);
-- 
2.30.2

