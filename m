Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B53C1A6AD5
	for <lists+stable@lfdr.de>; Mon, 13 Apr 2020 19:03:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732337AbgDMRD1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Apr 2020 13:03:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732285AbgDMRD0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Apr 2020 13:03:26 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE611C0A3BDC
        for <stable@vger.kernel.org>; Mon, 13 Apr 2020 10:03:25 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id i3so679006pgk.1
        for <stable@vger.kernel.org>; Mon, 13 Apr 2020 10:03:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=x3mFfnqIPOP4ncfNP0YhubiozqQilUbpwFxKlgs4RG0=;
        b=KYGbZbMQIm+29jnu0eBWep2Qpj7EUvj5OxD18/BoGKgdOz1l2iQ4m2+w31Kngvf+IH
         GcdjexN1wyYzyEXPR/VDhTZqH4PPZ9aO5A0EhO34o1qIGUcUdSrX3tTNDE92i1Q4l3b2
         VkukPsfy99O9hYBOYWhWV8FNhH0NyJVlseFP4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=x3mFfnqIPOP4ncfNP0YhubiozqQilUbpwFxKlgs4RG0=;
        b=IMCpLwH8Zg45iEF32SuRtWLpHySnnvgGEst2Bp6ZxvW7ve1LMMXzguH1PZ+oCiA5o7
         a7rJbC8MpYUovRYTYFpJYGDQ9LBlH6kACDigAmOMy9WQQKzGtQJwn8pfntuVrbxNnddq
         nk8SrI7yuRafI3EOFb1+qU9Z6Uc6EmMW2ry8vlDfyrXQOkV/4OK/VzabyRDXTwUsWV19
         2TOb6dOHne9c/sfcqWZl0JMeJqbXZWCL3wOZJPIkw47Y1miiHzQ2UH6dyredXjvEBCve
         caU4N0PHburEACLq9KqVlK3ykD6gdpkkorLlH6gAOfSphXFbhrdGpCR7IDfYol+Tzq5R
         u3Gg==
X-Gm-Message-State: AGi0PubAVVxmgsRtXzMS2p+ZCnr/udgdI0JL4KHuSk+mSkt82p7n7qL7
        SnfsH5nWFO0du+cnIPTfn3AFDw==
X-Google-Smtp-Source: APiQypK+y+cSTgULVptvqPAEXP1nOjIP7Z7QJApT2P8bmIcUgUTc1PHRqR/55e1rGZXJ8M5bffdmzg==
X-Received: by 2002:a63:dd0c:: with SMTP id t12mr16114334pgg.429.1586797405295;
        Mon, 13 Apr 2020 10:03:25 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id d5sm9088113pfa.59.2020.04.13.10.03.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2020 10:03:24 -0700 (PDT)
Date:   Mon, 13 Apr 2020 10:03:23 -0700
From:   Kees Cook <keescook@chromium.org>
To:     gregkh@linuxfoundation.org
Cc:     akpm@linux-foundation.org, cl@linux.com, iamjoonsoo.kim@lge.com,
        penberg@kernel.org, rientjes@google.com, silvio.cesare@gmail.com,
        stable@vger.kernel.org
Subject: [PATCH][v4.19][v4.14] slub: improve bit diffusion for freelist ptr
 obfuscation
Message-ID: <202004131001.20346EB0E7@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 1ad53d9fa3f6168ebcf48a50e08b170432da2257 upstream.

Under CONFIG_SLAB_FREELIST_HARDENED=y, the obfuscation was relatively weak
in that the ptr and ptr address were usually so close that the first XOR
would result in an almost entirely 0-byte value[1], leaving most of the
"secret" number ultimately being stored after the third XOR.  A single
blind memory content exposure of the freelist was generally sufficient to
learn the secret.

Add a swab() call to mix bits a little more.  This is a cheap way (1
cycle) to make attacks need more than a single exposure to learn the
secret (or to know _where_ the exposure is in memory).

kmalloc-32 freelist walk, before:

ptr              ptr_addr            stored value      secret
ffff90c22e019020@ffff90c22e019000 is 86528eb656b3b5bd (86528eb656b3b59d)
ffff90c22e019040@ffff90c22e019020 is 86528eb656b3b5fd (86528eb656b3b59d)
ffff90c22e019060@ffff90c22e019040 is 86528eb656b3b5bd (86528eb656b3b59d)
ffff90c22e019080@ffff90c22e019060 is 86528eb656b3b57d (86528eb656b3b59d)
ffff90c22e0190a0@ffff90c22e019080 is 86528eb656b3b5bd (86528eb656b3b59d)
...

after:

ptr              ptr_addr            stored value      secret
ffff9eed6e019020@ffff9eed6e019000 is 793d1135d52cda42 (86528eb656b3b59d)
ffff9eed6e019040@ffff9eed6e019020 is 593d1135d52cda22 (86528eb656b3b59d)
ffff9eed6e019060@ffff9eed6e019040 is 393d1135d52cda02 (86528eb656b3b59d)
ffff9eed6e019080@ffff9eed6e019060 is 193d1135d52cdae2 (86528eb656b3b59d)
ffff9eed6e0190a0@ffff9eed6e019080 is f93d1135d52cdac2 (86528eb656b3b59d)

[1] https://blog.infosectcbr.com.au/2020/03/weaknesses-in-linux-kernel-heap.html

Fixes: 2482ddec670f ("mm: add SLUB free list pointer obfuscation")
Reported-by: Silvio Cesare <silvio.cesare@gmail.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: <stable@vger.kernel.org>
Link: http://lkml.kernel.org/r/202003051623.AF4F8CB@keescook
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[kees: Backport to v4.19 which doesn't call kasan_reset_untag()]
Signed-off-by: Kees Cook <keescook@chromium.org>
---
This requires that commit d5767057c9a76a29f073dad66b7fa12a90e8c748 is
also cherry-picked into -stable.
---
 mm/slub.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/slub.c b/mm/slub.c
index 9b7b989273d4..d8116a43a287 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -249,7 +249,7 @@ static inline void *freelist_ptr(const struct kmem_cache *s, void *ptr,
 				 unsigned long ptr_addr)
 {
 #ifdef CONFIG_SLAB_FREELIST_HARDENED
-	return (void *)((unsigned long)ptr ^ s->random ^ ptr_addr);
+	return (void *)((unsigned long)ptr ^ s->random ^ swab(ptr_addr));
 #else
 	return ptr;
 #endif
-- 
2.20.1


-- 
Kees Cook
