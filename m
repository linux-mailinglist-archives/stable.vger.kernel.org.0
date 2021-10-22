Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3245437035
	for <lists+stable@lfdr.de>; Fri, 22 Oct 2021 04:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232584AbhJVCyn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Oct 2021 22:54:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:33206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232520AbhJVCym (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 Oct 2021 22:54:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D232A6058D;
        Fri, 22 Oct 2021 02:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634871146;
        bh=8D4R/P2YZUAbGMaBfQ5HcK9p1FFkmq22HAe9oMkeN4U=;
        h=Date:From:To:Subject:From;
        b=0GLlsZ5/VhEQrlrBCZzS6F5SsxtBiMy+Udl+FtkQ9MsK6lDX1fk49AJNWdsK6IpLC
         19OtEvLZ/qkKK9/kBQBKLQ4Bb9ollGqiIAEBNASZX1ou3nt/QoQ4VyiJZ5XtfybVL8
         FqHp+MR04SgxdpK+S/xpt3QEfJSOD21GqNmRH87w=
Date:   Thu, 21 Oct 2021 19:52:25 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, dvyukov@google.com, jordy@pwning.systems,
        keescook@chromium.org, mm-commits@vger.kernel.org, rppt@kernel.org,
        stable@vger.kernel.org
Subject:  +
 mm-secretmem-avoid-letting-secretmem_users-drop-to-zero.patch added to -mm
 tree
Message-ID: <20211022025225.aMPRKX0sS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/secretmem: avoid letting secretmem_users drop to zero
has been added to the -mm tree.  Its filename is
     mm-secretmem-avoid-letting-secretmem_users-drop-to-zero.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-secretmem-avoid-letting-secretmem_users-drop-to-zero.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-secretmem-avoid-letting-secretmem_users-drop-to-zero.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: mm/secretmem: avoid letting secretmem_users drop to zero

Quoting Dmitry: "refcount_inc() needs to be done before fd_install(). 
After fd_install() finishes, the fd can be used by userspace and we can
have secret data in memory before the refcount_inc().

A straightforward misuse where a user will predict the returned fd in
another thread before the syscall returns and will use it to store secret
data is somewhat dubious because such a user just shoots themself in the
foot.

But a more interesting misuse would be to close the predicted fd and
decrement the refcount before the corresponding refcount_inc, this way one
can briefly drop the refcount to zero while there are other users of
secretmem."

Move fd_install() after refcount_inc().

Link: https://lkml.kernel.org/r/20211021154046.880251-1-keescook@chromium.org
Link: https://lore.kernel.org/lkml/CACT4Y+b1sW6-Hkn8HQYw_SsT7X3tp-CJNh2ci0wG3ZnQz9jjig@mail.gmail.com
Fixes: 9a436f8ff631 ("PM: hibernate: disable when there are active secretmem users")
Signed-off-by: Kees Cook <keescook@chromium.org>
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Jordy Zomer <jordy@pwning.systems>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/secretmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/secretmem.c~mm-secretmem-avoid-letting-secretmem_users-drop-to-zero
+++ a/mm/secretmem.c
@@ -217,8 +217,8 @@ SYSCALL_DEFINE1(memfd_secret, unsigned i
 
 	file->f_flags |= O_LARGEFILE;
 
-	fd_install(fd, file);
 	refcount_inc(&secretmem_users);
+	fd_install(fd, file);
 	return fd;
 
 err_put_fd:
_

Patches currently in -mm which might be from keescook@chromium.org are

mm-secretmem-avoid-letting-secretmem_users-drop-to-zero.patch
kasan-test-bypass-__alloc_size-checks.patch
rapidio-avoid-bogus-__alloc_size-warning.patch
compiler-attributes-add-__alloc_size-for-better-bounds-checking.patch
slab-clean-up-function-prototypes.patch
slab-add-__alloc_size-attributes-for-better-bounds-checking.patch
mm-kvmalloc-add-__alloc_size-attributes-for-better-bounds-checking.patch
mm-vmalloc-add-__alloc_size-attributes-for-better-bounds-checking.patch
mm-page_alloc-add-__alloc_size-attributes-for-better-bounds-checking.patch
percpu-add-__alloc_size-attributes-for-better-bounds-checking.patch
kasan-test-consolidate-workarounds-for-unwanted-__alloc_size-protection.patch
maintainers-add-exec-binfmt-section-with-myself-and-eric.patch
binfmt_elf-reintroduce-using-map_fixed_noreplace.patch

