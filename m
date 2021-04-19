Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25FE0364326
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240174AbhDSNO6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:14:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:47986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240257AbhDSNN2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:13:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B4D94613AC;
        Mon, 19 Apr 2021 13:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618837937;
        bh=46JedHWo30ypvYrPVxpZd3sFM7/UwPdy0xbk1KlwYCo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZX16F3qjeRLqFbK6T7ucYoudafRi0dH98ohGxgua95zztUaDdc+jnZp8KKLXH33oV
         1bPO0ktWEYAjJM7LJ9VPvTWEUtkevFhqyiFgjJWYLqwg0w2zd4sMdP5yZvReIZ0+q/
         HV8f3xQassaiZzGLqeBapkSAqkNMvwYeCuSHrUrg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Collingbourne <pcc@google.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 5.11 062/122] arm64: fix inline asm in load_unaligned_zeropad()
Date:   Mon, 19 Apr 2021 15:05:42 +0200
Message-Id: <20210419130532.284720554@linuxfoundation.org>
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

From: Peter Collingbourne <pcc@google.com>

commit 185f2e5f51c2029efd9dd26cceb968a44fe053c6 upstream.

The inline asm's addr operand is marked as input-only, however in
the case where an exception is taken it may be modified by the BIC
instruction on the exception path. Fix the problem by using a temporary
register as the destination register for the BIC instruction.

Signed-off-by: Peter Collingbourne <pcc@google.com>
Cc: stable@vger.kernel.org
Link: https://linux-review.googlesource.com/id/I84538c8a2307d567b4f45bb20b715451005f9617
Link: https://lore.kernel.org/r/20210401165110.3952103-1-pcc@google.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/word-at-a-time.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/arch/arm64/include/asm/word-at-a-time.h
+++ b/arch/arm64/include/asm/word-at-a-time.h
@@ -53,7 +53,7 @@ static inline unsigned long find_zero(un
  */
 static inline unsigned long load_unaligned_zeropad(const void *addr)
 {
-	unsigned long ret, offset;
+	unsigned long ret, tmp;
 
 	/* Load word from unaligned pointer addr */
 	asm(
@@ -61,9 +61,9 @@ static inline unsigned long load_unalign
 	"2:\n"
 	"	.pushsection .fixup,\"ax\"\n"
 	"	.align 2\n"
-	"3:	and	%1, %2, #0x7\n"
-	"	bic	%2, %2, #0x7\n"
-	"	ldr	%0, [%2]\n"
+	"3:	bic	%1, %2, #0x7\n"
+	"	ldr	%0, [%1]\n"
+	"	and	%1, %2, #0x7\n"
 	"	lsl	%1, %1, #0x3\n"
 #ifndef __AARCH64EB__
 	"	lsr	%0, %0, %1\n"
@@ -73,7 +73,7 @@ static inline unsigned long load_unalign
 	"	b	2b\n"
 	"	.popsection\n"
 	_ASM_EXTABLE(1b, 3b)
-	: "=&r" (ret), "=&r" (offset)
+	: "=&r" (ret), "=&r" (tmp)
 	: "r" (addr), "Q" (*(unsigned long *)addr));
 
 	return ret;


