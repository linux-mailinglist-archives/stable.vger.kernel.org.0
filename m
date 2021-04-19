Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C12B3643CC
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240969AbhDSNVg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:21:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:56334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241019AbhDSNTq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:19:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 02B85613E9;
        Mon, 19 Apr 2021 13:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618838124;
        bh=46JedHWo30ypvYrPVxpZd3sFM7/UwPdy0xbk1KlwYCo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mDpOe4aG+IsftMpWcIHYngKLbvVwh4w8rquv0lzrOq4s5StnnUcC4mqeIhl4SJNMv
         6ojMDRwqF+MdCfRcRI5wwcMLsXFYxk65ML4qaLbX1wCIeylGo4Nmi6S65ZFfbZggjl
         PxJ5/gvdr865GZ69ZdAZXTjgQk8+Sm7gJriNeJq0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Collingbourne <pcc@google.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 5.10 052/103] arm64: fix inline asm in load_unaligned_zeropad()
Date:   Mon, 19 Apr 2021 15:06:03 +0200
Message-Id: <20210419130529.602217419@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130527.791982064@linuxfoundation.org>
References: <20210419130527.791982064@linuxfoundation.org>
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


