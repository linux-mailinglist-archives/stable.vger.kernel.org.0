Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21C34328A21
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:16:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239434AbhCASMv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:12:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:58730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238808AbhCASGT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:06:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B83765289;
        Mon,  1 Mar 2021 17:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619866;
        bh=FMTIAskHSirGDsjErX5ojXmmcW4YtK36HKWLoeg+Y6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AqDkCmU8bV53gBRSff0HIagHvserhKIOTn6yaOAMmeREL+sTvGTOW/SeyZexqHW0S
         tS8PnJFUd8zU4lQzF3W+VlmXIxHglSBiOSqPK0Op4o1EF5vqMS9Fg0tegk0WL2265P
         hNGlSiRD7EaJf4Tp/6K5lGHXFX7qZi3G8DFlBOHI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.10 609/663] powerpc/32s: Add missing call to kuep_lock on syscall entry
Date:   Mon,  1 Mar 2021 17:14:17 +0100
Message-Id: <20210301161211.978994505@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

commit 57fdfbce89137ae85cd5cef48be168040a47dd13 upstream.

Userspace Execution protection and fast syscall entry were implemented
independently from each other and were both merged in kernel 5.2,
leading to syscall entry missing userspace execution protection.

On syscall entry, execution of user space memory must be
locked in the same way as on exception entry.

Fixes: b86fb88855ea ("powerpc/32: implement fast entry for syscalls on non BOOKE")
Cc: stable@vger.kernel.org
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/c65e105b63aaf74f91a14f845bc77192350b84a6.1612796617.git.christophe.leroy@csgroup.eu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/entry_32.S |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/powerpc/kernel/entry_32.S
+++ b/arch/powerpc/kernel/entry_32.S
@@ -347,6 +347,9 @@ trace_syscall_entry_irq_off:
 
 	.globl	transfer_to_syscall
 transfer_to_syscall:
+#ifdef CONFIG_PPC_BOOK3S_32
+	kuep_lock r11, r12
+#endif
 #ifdef CONFIG_TRACE_IRQFLAGS
 	andi.	r12,r9,MSR_EE
 	beq-	trace_syscall_entry_irq_off


