Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0CB74F36AB
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237389AbiDELGk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:06:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348290AbiDEJr0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:47:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F9E9272A;
        Tue,  5 Apr 2022 02:33:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E82AB81C6F;
        Tue,  5 Apr 2022 09:33:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76D73C385A0;
        Tue,  5 Apr 2022 09:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151215;
        bh=HjRFNYWoqayGeJ6pKjf0fHtBGla2zrnLB7MtPLRPIBU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L0xTc+vTOaVShzAZx629e9mIpaVhVDWaIb8ZBsKiKz8/yGcXHlmr1z6I4anfQbrvK
         3EU+h1ouzGWZbtR221d2S/j/lOPe6UrCgQudp6GoyGSRwJ8Af0tmrf8SOa7XpzKeZK
         RM6lGklVjLkkutHR/qIhW6UbtQ4L61+V2pGxNj9k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Petr Mladek <pmladek@suse.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 328/913] vsprintf: Fix %pK with kptr_restrict == 0
Date:   Tue,  5 Apr 2022 09:23:10 +0200
Message-Id: <20220405070349.682464482@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit 84842911322fc6a02a03ab9e728a48c691fe3efd ]

Although kptr_restrict is set to 0 and the kernel is booted with
no_hash_pointers parameter, the content of /proc/vmallocinfo is
lacking the real addresses.

  / # cat /proc/vmallocinfo
  0x(ptrval)-0x(ptrval)    8192 load_module+0xc0c/0x2c0c pages=1 vmalloc
  0x(ptrval)-0x(ptrval)   12288 start_kernel+0x4e0/0x690 pages=2 vmalloc
  0x(ptrval)-0x(ptrval)   12288 start_kernel+0x4e0/0x690 pages=2 vmalloc
  0x(ptrval)-0x(ptrval)    8192 _mpic_map_mmio.constprop.0+0x20/0x44 phys=0x80041000 ioremap
  0x(ptrval)-0x(ptrval)   12288 _mpic_map_mmio.constprop.0+0x20/0x44 phys=0x80041000 ioremap
    ...

According to the documentation for /proc/sys/kernel/, %pK is
equivalent to %p when kptr_restrict is set to 0.

Fixes: 5ead723a20e0 ("lib/vsprintf: no_hash_pointers prints all addresses as unhashed")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Petr Mladek <pmladek@suse.com>
Link: https://lore.kernel.org/r/107476128e59bff11a309b5bf7579a1753a41aca.1645087605.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../admin-guide/kernel-parameters.txt         |  3 +-
 lib/vsprintf.c                                | 36 +++++++++++--------
 2 files changed, 22 insertions(+), 17 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index ed55ea20352b..bb25aae69860 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -3452,8 +3452,7 @@
 			difficult since unequal pointers can no longer be
 			compared.  However, if this command-line option is
 			specified, then all normal pointers will have their true
-			value printed.  Pointers printed via %pK may still be
-			hashed.  This option should only be specified when
+			value printed. This option should only be specified when
 			debugging the kernel.  Please do not use on production
 			kernels.
 
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 0621bbb20e0f..a3b73f28b7a9 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -54,6 +54,10 @@
 #include <linux/string_helpers.h>
 #include "kstrtox.h"
 
+/* Disable pointer hashing if requested */
+bool no_hash_pointers __ro_after_init;
+EXPORT_SYMBOL_GPL(no_hash_pointers);
+
 static noinline unsigned long long simple_strntoull(const char *startp, size_t max_chars, char **endp, unsigned int base)
 {
 	const char *cp;
@@ -848,6 +852,19 @@ static char *ptr_to_id(char *buf, char *end, const void *ptr,
 	return pointer_string(buf, end, (const void *)hashval, spec);
 }
 
+static char *default_pointer(char *buf, char *end, const void *ptr,
+			     struct printf_spec spec)
+{
+	/*
+	 * default is to _not_ leak addresses, so hash before printing,
+	 * unless no_hash_pointers is specified on the command line.
+	 */
+	if (unlikely(no_hash_pointers))
+		return pointer_string(buf, end, ptr, spec);
+
+	return ptr_to_id(buf, end, ptr, spec);
+}
+
 int kptr_restrict __read_mostly;
 
 static noinline_for_stack
@@ -857,7 +874,7 @@ char *restricted_pointer(char *buf, char *end, const void *ptr,
 	switch (kptr_restrict) {
 	case 0:
 		/* Handle as %p, hash and do _not_ leak addresses. */
-		return ptr_to_id(buf, end, ptr, spec);
+		return default_pointer(buf, end, ptr, spec);
 	case 1: {
 		const struct cred *cred;
 
@@ -2226,10 +2243,6 @@ char *fwnode_string(char *buf, char *end, struct fwnode_handle *fwnode,
 	return widen_string(buf, buf - buf_start, end, spec);
 }
 
-/* Disable pointer hashing if requested */
-bool no_hash_pointers __ro_after_init;
-EXPORT_SYMBOL_GPL(no_hash_pointers);
-
 int __init no_hash_pointers_enable(char *str)
 {
 	if (no_hash_pointers)
@@ -2458,7 +2471,7 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 	case 'e':
 		/* %pe with a non-ERR_PTR gets treated as plain %p */
 		if (!IS_ERR(ptr))
-			break;
+			return default_pointer(buf, end, ptr, spec);
 		return err_ptr(buf, end, ptr, spec);
 	case 'u':
 	case 'k':
@@ -2468,16 +2481,9 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 		default:
 			return error_string(buf, end, "(einval)", spec);
 		}
+	default:
+		return default_pointer(buf, end, ptr, spec);
 	}
-
-	/*
-	 * default is to _not_ leak addresses, so hash before printing,
-	 * unless no_hash_pointers is specified on the command line.
-	 */
-	if (unlikely(no_hash_pointers))
-		return pointer_string(buf, end, ptr, spec);
-	else
-		return ptr_to_id(buf, end, ptr, spec);
 }
 
 /*
-- 
2.34.1



