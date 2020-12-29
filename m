Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C7B22E752E
	for <lists+stable@lfdr.de>; Wed, 30 Dec 2020 00:16:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbgL2XPx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Dec 2020 18:15:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:37886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726161AbgL2XPx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Dec 2020 18:15:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B236223DB;
        Tue, 29 Dec 2020 23:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1609283702;
        bh=I+kANtDsJWBoHJ0KQZKqJmAYuK8D3gsAukkRlX/7QCI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=CtY4oX0zTLAE2dJBLxDOUdDiDo0R01dc7Tx6WhjESeNp+PoaTLkcP1NA4w+R6xF5V
         eBIGghV4Vk6zt65SU+LRyVBRmqiQACrYXS5wzXAfJc6h2C4XormG5YGHmqrX4Uz0Dx
         3BFe+GLfxuzo+ShKMaLU248iKc5GiOi5aLVDHuVY=
Date:   Tue, 29 Dec 2020 15:15:01 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, borntraeger@de.ibm.com,
        gor@linux.ibm.com, hca@linux.ibm.com, iii@linux.ibm.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        zaslonko@linux.ibm.com
Subject:  [patch 14/16] lib/zlib: fix inflating zlib streams on
 s390
Message-ID: <20201229231501.ix0FESQg2%akpm@linux-foundation.org>
In-Reply-To: <20201229151349.3285926ec0d1f65a27ac8534@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
