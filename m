Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EB96364303
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:17:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240280AbhDSNNb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:13:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:46768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239965AbhDSNL4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:11:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5729D61363;
        Mon, 19 Apr 2021 13:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618837882;
        bh=0ttpp1tFUad2GVwo5g+HNV/6LPtUXvYCpjWK+8R+0t0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OuiwRzG+o8RG6nYF+PnRjuXgO4UYizqQriYOe0QzJbltxLKewUuYbL0Q4JrQWS+a1
         5ZwcO9ubFlsvFDfkTIykHCPLOjupV9zc0/ZwAYmigfOjmHI3RIBQPPyKQvWsNXpKZJ
         vsU/H7dGMI8B/SeqGjpBjLT97xCIX7xiUYR4Hiis=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Steven Price <steven.price@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.11 088/122] mm: ptdump: fix build failure
Date:   Mon, 19 Apr 2021 15:06:08 +0200
Message-Id: <20210419130533.140802408@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130530.166331793@linuxfoundation.org>
References: <20210419130530.166331793@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

commit 458376913d86bed2fb781b4952eb6861675ef3be upstream.

READ_ONCE() cannot be used for reading PTEs.  Use ptep_get() instead, to
avoid the following errors:

    CC      mm/ptdump.o
  In file included from <command-line>:
  mm/ptdump.c: In function 'ptdump_pte_entry':
  include/linux/compiler_types.h:320:38: error: call to '__compiletime_assert_207' declared with attribute error: Unsupported access size for {READ,WRITE}_ONCE().
    320 |  _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
        |                                      ^
  include/linux/compiler_types.h:301:4: note: in definition of macro '__compiletime_assert'
    301 |    prefix ## suffix();    \
        |    ^~~~~~
  include/linux/compiler_types.h:320:2: note: in expansion of macro '_compiletime_assert'
    320 |  _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
        |  ^~~~~~~~~~~~~~~~~~~
  include/asm-generic/rwonce.h:36:2: note: in expansion of macro 'compiletime_assert'
     36 |  compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long), \
        |  ^~~~~~~~~~~~~~~~~~
  include/asm-generic/rwonce.h:49:2: note: in expansion of macro 'compiletime_assert_rwonce_type'
     49 |  compiletime_assert_rwonce_type(x);    \
        |  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  mm/ptdump.c:114:14: note: in expansion of macro 'READ_ONCE'
    114 |  pte_t val = READ_ONCE(*pte);
        |              ^~~~~~~~~
  make[2]: *** [mm/ptdump.o] Error 1

See commit 481e980a7c19 ("mm: Allow arches to provide ptep_get()") and
commit c0e1c8c22beb ("powerpc/8xx: Provide ptep_get() with 16k pages")
for details.

Link: https://lkml.kernel.org/r/912b349e2bcaa88939904815ca0af945740c6bd4.1618478922.git.christophe.leroy@csgroup.eu
Fixes: 30d621f6723b ("mm: add generic ptdump")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Steven Price <steven.price@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/ptdump.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/ptdump.c
+++ b/mm/ptdump.c
@@ -111,7 +111,7 @@ static int ptdump_pte_entry(pte_t *pte,
 			    unsigned long next, struct mm_walk *walk)
 {
 	struct ptdump_state *st = walk->private;
-	pte_t val = READ_ONCE(*pte);
+	pte_t val = ptep_get(pte);
 
 	if (st->effective_prot)
 		st->effective_prot(st, 4, pte_val(val));


