Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4412E9A54
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 17:13:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729589AbhADQId (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 11:08:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:38732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728637AbhADQBm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 11:01:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90B9E2251E;
        Mon,  4 Jan 2021 16:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609776087;
        bh=jhm/B5OpPhNWdpC2OjByY/9D+qGhR18HHOvJ1eE8rEI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wNrpmi4qJJs9WJq/2gbyxxhyOrejmtwVsG4Z7cFYwo5H8RDB/PxK+3XK9c63VQF5U
         Ou1YTmndSdL9VvydZGgNdXdU0cxywJqj1ZhVDuua6cPdHdZCsYBfLNmL3R6rvK1Xxo
         TEu78Xsh8wzGrea+fEh1cPc72loJrxgCCaZ8kuCY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilya Leoshkevich <iii@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Mikhail Zaslonko <zaslonko@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 16/63] lib/zlib: fix inflating zlib streams on s390
Date:   Mon,  4 Jan 2021 16:57:09 +0100
Message-Id: <20210104155709.601396478@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210104155708.800470590@linuxfoundation.org>
References: <20210104155708.800470590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilya Leoshkevich <iii@linux.ibm.com>

commit f0bb29e8c4076444d32df00c8d32e169ceecf283 upstream.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 lib/zlib_dfltcc/dfltcc_inflate.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/zlib_dfltcc/dfltcc_inflate.c
+++ b/lib/zlib_dfltcc/dfltcc_inflate.c
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


