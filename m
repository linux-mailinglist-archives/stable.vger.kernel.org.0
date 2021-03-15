Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15CDC33B5AB
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:56:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231629AbhCONy7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:54:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:58268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231545AbhCONyg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:54:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C89E64EED;
        Mon, 15 Mar 2021 13:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816475;
        bh=DM80zCVAqR7ECdY7KHXj1Y3CaTwgKu9kBTUJIY+O3Z4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ki6ImO91hMWaEpWKAfa/EINJtifeuzeclUGdykAbS47Nic30iLCA0ki7LHQAMFC6n
         XYIBfN9iR5NifL2hViXyOzCDnYhcNjBE0OR/C4hYpW8gNRdCMKbenWa1Wj23iiVivn
         PxJYY3hlprOwFsVHJ2n3pqdlwtDMvBpagbF02Eg0=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.4 66/75] alpha: get rid of tail-zeroing in __copy_user()
Date:   Mon, 15 Mar 2021 14:52:20 +0100
Message-Id: <20210315135210.417715043@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135208.252034256@linuxfoundation.org>
References: <20210315135208.252034256@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Al Viro <viro@zeniv.linux.org.uk>

commit 085354f907969fb3ee33f236368f6e1dd4c74d62 upstream.

... and adjust copy_from_user() accordingly

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/alpha/include/asm/uaccess.h |    9 +++++----
 arch/alpha/lib/copy_user.S       |   16 +---------------
 arch/alpha/lib/ev6-copy_user.S   |   23 +----------------------
 3 files changed, 7 insertions(+), 41 deletions(-)

--- a/arch/alpha/include/asm/uaccess.h
+++ b/arch/alpha/include/asm/uaccess.h
@@ -396,11 +396,12 @@ copy_to_user(void __user *to, const void
 extern inline long
 copy_from_user(void *to, const void __user *from, long n)
 {
+	long res = n;
 	if (likely(__access_ok((unsigned long)from, n, get_fs())))
-		n = __copy_tofrom_user_nocheck(to, (__force void *)from, n);
-	else
-		memset(to, 0, n);
-	return n;
+		res = __copy_from_user_inatomic(to, from, n);
+	if (unlikely(res))
+		memset(to + (n - res), 0, res);
+	return res;
 }
 
 extern void __do_clear_user(void);
--- a/arch/alpha/lib/copy_user.S
+++ b/arch/alpha/lib/copy_user.S
@@ -126,22 +126,8 @@ $65:
 	bis $31,$31,$0
 $41:
 $35:
-$exitout:
-	ret $31,($28),1
-
 $exitin:
-	/* A stupid byte-by-byte zeroing of the rest of the output
-	   buffer.  This cures security holes by never leaving 
-	   random kernel data around to be copied elsewhere.  */
-
-	mov $0,$1
-$101:
-	EXO ( ldq_u $2,0($6) )
-	subq $1,1,$1
-	mskbl $2,$6,$2
-	EXO ( stq_u $2,0($6) )
-	addq $6,1,$6
-	bgt $1,$101
+$exitout:
 	ret $31,($28),1
 
 	.end __copy_user
--- a/arch/alpha/lib/ev6-copy_user.S
+++ b/arch/alpha/lib/ev6-copy_user.S
@@ -228,33 +228,12 @@ $dirtyentry:
 	bgt $0,$onebyteloop	# U  .. .. ..	: U L U L
 
 $zerolength:
+$exitin:
 $exitout:			# Destination for exception recovery(?)
 	nop			# .. .. .. E
 	nop			# .. .. E  ..
 	nop			# .. E  .. ..
 	ret $31,($28),1		# L0 .. .. ..	: L U L U
 
-$exitin:
-
-	/* A stupid byte-by-byte zeroing of the rest of the output
-	   buffer.  This cures security holes by never leaving 
-	   random kernel data around to be copied elsewhere.  */
-
-	nop
-	nop
-	nop
-	mov	$0,$1
-
-$101:
-	EXO ( stb $31,0($6) )	# L
-	subq $1,1,$1		# E
-	addq $6,1,$6		# E
-	bgt $1,$101		# U
-
-	nop
-	nop
-	nop
-	ret $31,($28),1		# L0
-
 	.end __copy_user
 	EXPORT_SYMBOL(__copy_user)


