Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13C511ACC6F
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 18:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728418AbgDPQAO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 12:00:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:35834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2895486AbgDPN11 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:27:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 954EF206E9;
        Thu, 16 Apr 2020 13:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587043647;
        bh=9rhqvEuNgLKVybdVBhhFkvqMLIXVgJEnGG2Ns6goGf4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W2VL4DdhdVILEOOWYlEPqZ8O6knXysQUvpOLrP4B+W82LQymr0+JDuG8C6JJmno04
         UiWRm9qfBbbWkoqfO/hUZWOccPX0HXTwTFi+nq93hfFZmQU9T/ZejSJD+q+inhwI2+
         5wwfJmPnlwobWe48zpNPFRczAKdtQJQ4OPIRtMM4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Silvio Cesare <silvio.cesare@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 043/146] slub: improve bit diffusion for freelist ptr obfuscation
Date:   Thu, 16 Apr 2020 15:23:04 +0200
Message-Id: <20200416131248.601053147@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131242.353444678@linuxfoundation.org>
References: <20200416131242.353444678@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/slub.c
+++ b/mm/slub.c
@@ -249,7 +249,7 @@ static inline void *freelist_ptr(const s
 				 unsigned long ptr_addr)
 {
 #ifdef CONFIG_SLAB_FREELIST_HARDENED
-	return (void *)((unsigned long)ptr ^ s->random ^ ptr_addr);
+	return (void *)((unsigned long)ptr ^ s->random ^ swab(ptr_addr));
 #else
 	return ptr;
 #endif


