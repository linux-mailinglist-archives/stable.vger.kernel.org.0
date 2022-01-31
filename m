Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC374A4288
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:12:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359851AbiAaLMP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:12:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377479AbiAaLKD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:10:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DCD2C07979B;
        Mon, 31 Jan 2022 03:07:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3EAB36114D;
        Mon, 31 Jan 2022 11:07:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25739C340E8;
        Mon, 31 Jan 2022 11:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627262;
        bh=gurpRK8pRh//+KMIzS4LXQmB8sq083h/1t9ww78Celw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a69CZ1GklbPuT54r+Jhsn1Y6MTwC7ZtMRiBXvjYm9VznjVakCV8taKfbiuUKYd6wy
         PpVn2F1btJz3wijjNORzh3zJP7w3N/Wj4sd8BtU2pbMz8VVKiKKDupA2RFDmhJnLv7
         +VPYbMNteUdu6BgRqaCLRNm9Z1HsP6wHpMLzQoPU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Ard Biesheuvel <ardb@kernel.org>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 5.15 005/171] ARM: 9179/1: uaccess: avoid alignment faults in copy_[from|to]_kernel_nofault
Date:   Mon, 31 Jan 2022 11:54:30 +0100
Message-Id: <20220131105230.151611980@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
References: <20220131105229.959216821@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

commit 15420269b02a63ed8c1841905d8b8b2403246004 upstream.

The helpers that are used to implement copy_from_kernel_nofault() and
copy_to_kernel_nofault() cast a void* to a pointer to a wider type,
which may result in alignment faults on ARM if the compiler decides to
use double-word or multiple-word load/store instructions.

Only configurations that define CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
are affected, given that commit 2423de2e6f4d ("ARM: 9115/1: mm/maccess:
fix unaligned copy_{from,to}_kernel_nofault") ensures that dst and src
are sufficiently aligned otherwise.

So use the unaligned accessors for accessing dst and src in cases where
they may be misaligned.

Cc: <stable@vger.kernel.org> # depends on 2423de2e6f4d
Fixes: 2df4c9a741a0 ("ARM: 9112/1: uaccess: add __{get,put}_kernel_nofault")
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/include/asm/uaccess.h |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/arch/arm/include/asm/uaccess.h
+++ b/arch/arm/include/asm/uaccess.h
@@ -11,6 +11,7 @@
 #include <linux/string.h>
 #include <asm/memory.h>
 #include <asm/domain.h>
+#include <asm/unaligned.h>
 #include <asm/unified.h>
 #include <asm/compiler.h>
 
@@ -497,7 +498,10 @@ do {									\
 	}								\
 	default: __err = __get_user_bad(); break;			\
 	}								\
-	*(type *)(dst) = __val;						\
+	if (IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS))		\
+		put_unaligned(__val, (type *)(dst));			\
+	else								\
+		*(type *)(dst) = __val; /* aligned by caller */		\
 	if (__err)							\
 		goto err_label;						\
 } while (0)
@@ -507,7 +511,9 @@ do {									\
 	const type *__pk_ptr = (dst);					\
 	unsigned long __dst = (unsigned long)__pk_ptr;			\
 	int __err = 0;							\
-	type __val = *(type *)src;					\
+	type __val = IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)	\
+		     ? get_unaligned((type *)(src))			\
+		     : *(type *)(src);	/* aligned by caller */		\
 	switch (sizeof(type)) {						\
 	case 1: __put_user_asm_byte(__val, __dst, __err, ""); break;	\
 	case 2:	__put_user_asm_half(__val, __dst, __err, ""); break;	\


