Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1A892DE943
	for <lists+stable@lfdr.de>; Fri, 18 Dec 2020 19:50:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726096AbgLRStq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Dec 2020 13:49:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:59290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725854AbgLRStq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Dec 2020 13:49:46 -0500
Date:   Fri, 18 Dec 2020 10:49:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608317345;
        bh=n1ALUsLuthK3THRzpu05wC1KtQ4LCQT0qoaiWX8fr4s=;
        h=From:To:Subject:From;
        b=krsyRS56snK+/WKuk1WgvTkaK0hTrJ0GCt0GsSSDgwT9LFfsqNF+71nOfs1biqb/R
         /HwI6gEZ3YVFDLMWzha+JVl12IXzZmndLhL+rMcb6gJXVsgVkdf8ZjrnFVAUmrtBZF
         Oucdr09HH1d4kqJ0wuqDH3w70k59GCP573SwsOzg=
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, zaslonko@linux.ibm.com,
        stable@vger.kernel.org, hca@linux.ibm.com, gor@linux.ibm.com,
        borntraeger@de.ibm.com, iii@linux.ibm.com
Subject:  + lib-zlib-fix-inflating-zlib-streams-on-s390.patch added
 to -mm tree
Message-ID: <20201218184902.eN8WB%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: lib/zlib: fix inflating zlib streams on s390
has been added to the -mm tree.  Its filename is
     lib-zlib-fix-inflating-zlib-streams-on-s390.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-zlib-fix-inflating-zlib-streams-on-s390.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-zlib-fix-inflating-zlib-streams-on-s390.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ilya Leoshkevich <iii@linux.ibm.com>
Subject: lib/zlib: fix inflating zlib streams on s390

Decompressing zlib streams on s390 fails with "incorrect data check"
error.

Userspace zlib checks inflate_state.flags in order to byteswap checksums
only for zlib streams, and s390 hardware inflate code, which was ported
from there, tries to match this behavior.  At the same time, kernel zlib
does not use inflate_state.flags, so it contains essentially random
values.  For many use cases either zlib stream is zeroed out or checksum
is not used, so this problem is masked, but at least SquashFS is still
affected.

Fix by always passing a checksum to and from the hardware as is, which
matches zlib_inflate()'s expectations.

Link: https://lkml.kernel.org/r/20201215155551.894884-1-iii@linux.ibm.com
Fixes: 126196100063 ("lib/zlib: add s390 hardware support for kernel zlib_inflate")
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Tested-by: Christian Borntraeger <borntraeger@de.ibm.com>
Acked-by: Mikhail Zaslonko <zaslonko@linux.ibm.com>
Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Mikhail Zaslonko <zaslonko@linux.ibm.com>
Cc: <stable@vger.kernel.org>	[5.6+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/zlib_dfltcc/dfltcc_inflate.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/zlib_dfltcc/dfltcc_inflate.c~lib-zlib-fix-inflating-zlib-streams-on-s390
+++ a/lib/zlib_dfltcc/dfltcc_inflate.c
@@ -125,7 +125,7 @@ dfltcc_inflate_action dfltcc_inflate(
     param->ho = (state->write - state->whave) & ((1 << HB_BITS) - 1);
     if (param->hl)
         param->nt = 0; /* Honor history for the first block */
-    param->cv = state->flags ? REVERSE(state->check) : state->check;
+    param->cv = state->check;
 
     /* Inflate */
     do {
@@ -138,7 +138,7 @@ dfltcc_inflate_action dfltcc_inflate(
     state->bits = param->sbb;
     state->whave = param->hl;
     state->write = (param->ho + param->hl) & ((1 << HB_BITS) - 1);
-    state->check = state->flags ? REVERSE(param->cv) : param->cv;
+    state->check = param->cv;
     if (cc == DFLTCC_CC_OP2_CORRUPT && param->oesc != 0) {
         /* Report an error if stream is corrupted */
         state->mode = BAD;
_

Patches currently in -mm which might be from iii@linux.ibm.com are

lib-zlib-fix-inflating-zlib-streams-on-s390.patch

