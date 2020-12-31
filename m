Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC35B2E819A
	for <lists+stable@lfdr.de>; Thu, 31 Dec 2020 19:24:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726669AbgLaSYO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Dec 2020 13:24:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:34132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726579AbgLaSYO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 31 Dec 2020 13:24:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 63732224BD;
        Thu, 31 Dec 2020 18:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1609438992;
        bh=qY5OdqO3IUAVHvrVkTHp74z2hZ0Ljubm/B0ZIFqN8Co=;
        h=Date:From:To:Subject:From;
        b=GN6W+po+mtq86HHg3Rv5HK0L23EakAtxJmXgGwHJ/Y0lUPJwOKp/5ER07cNSK+JI3
         FC2XevUQlybjZ6VnJyl6ngrk/h7XNU9WVmrXctT5v7+W6uniXjvXTOGQBnMskJtASB
         mb2NmndUUoYNCw2+vHJDJ+S2fc0PZs8yC7nleSUs=
Date:   Thu, 31 Dec 2020 10:23:12 -0800
From:   akpm@linux-foundation.org
To:     borntraeger@de.ibm.com, gor@linux.ibm.com, hca@linux.ibm.com,
        iii@linux.ibm.com, mm-commits@vger.kernel.org,
        stable@vger.kernel.org, zaslonko@linux.ibm.com
Subject:  [merged]
 lib-zlib-fix-inflating-zlib-streams-on-s390.patch removed from -mm tree
Message-ID: <20201231182312.3lAg6JsAQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: lib/zlib: fix inflating zlib streams on s390
has been removed from the -mm tree.  Its filename was
     lib-zlib-fix-inflating-zlib-streams-on-s390.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


