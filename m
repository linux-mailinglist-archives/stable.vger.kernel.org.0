Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE8C21FBD85
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 20:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730997AbgFPSFY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 14:05:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:39390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730877AbgFPSFX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 14:05:23 -0400
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8BFC2067B;
        Tue, 16 Jun 2020 18:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592330723;
        bh=VAYvsH1jRCSS90G+7vpZ7/XZx07fVSrI+A8KnTl5vdA=;
        h=Date:From:To:Subject:From;
        b=LEro6Shn+dbI429cOPd7kg3dt+9NHbmBXvoeGmARyqJgXHYmukTX0l9D23/SoJXB7
         Gy7lj05/I1zK/6fbBXfficBIsuCTHdDZUllTXq0zENH5xENlL+5BXO78WMLiIURL1l
         0ejgGlDebGc8884Du6cm+RryahF/QNwVW18oE9fE=
Date:   Tue, 16 Jun 2020 11:05:22 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        stable@vger.kernel.org, serge@hallyn.com, rientjes@google.com,
        mhocko@suse.com, joe@perches.com, jmorris@namei.org,
        Jason@zx2c4.com, jarkko.sakkinen@linux.intel.com,
        hannes@cmpxchg.org, dhowells@redhat.com, dan.carpenter@oracle.com,
        longman@redhat.com
Subject:  + mm-slab-use-memzero_explicit-in-kzfree.patch added to -mm
 tree
Message-ID: <20200616180522.rmP8T%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/slab: use memzero_explicit() in kzfree()
has been added to the -mm tree.  Its filename is
     mm-slab-use-memzero_explicit-in-kzfree.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slab-use-memzero_explicit-in-kzfree.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slab-use-memzero_explicit-in-kzfree.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Waiman Long <longman@redhat.com>
Subject: mm/slab: use memzero_explicit() in kzfree()

The kzfree() function is normally used to clear some sensitive
information, like encryption keys, in the buffer before freeing it back to
the pool.  Memset() is currently used for buffer clearing.  However
unlikely, there is still a non-zero probability that the compiler may
choose to optimize away the memory clearing especially if LTO is being
used in the future.  To make sure that this optimization will never
happen, memzero_explicit(), which is introduced in v3.18, is now used in
kzfree() to future-proof it.

Link: http://lkml.kernel.org/r/20200616154311.12314-2-longman@redhat.com
Fixes: 3ef0e5ba4673 ("slab: introduce kzfree()")
Signed-off-by: Waiman Long <longman@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: James Morris <jmorris@namei.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Joe Perches <joe@perches.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "Jason A . Donenfeld" <Jason@zx2c4.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab_common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/slab_common.c~mm-slab-use-memzero_explicit-in-kzfree
+++ a/mm/slab_common.c
@@ -1726,7 +1726,7 @@ void kzfree(const void *p)
 	if (unlikely(ZERO_OR_NULL_PTR(mem)))
 		return;
 	ks = ksize(mem);
-	memset(mem, 0, ks);
+	memzero_explicit(mem, ks);
 	kfree(mem);
 }
 EXPORT_SYMBOL(kzfree);
_

Patches currently in -mm which might be from longman@redhat.com are

mm-slab-use-memzero_explicit-in-kzfree.patch
mm-treewide-rename-kzfree-to-kfree_sensitive.patch

