Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6969712A786
	for <lists+stable@lfdr.de>; Wed, 25 Dec 2019 11:40:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbfLYKjF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Dec 2019 05:39:05 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:40583 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726369AbfLYKjE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Dec 2019 05:39:04 -0500
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1ik446-000864-Mh; Wed, 25 Dec 2019 11:38:54 +0100
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id 5CD941C2B1E;
        Wed, 25 Dec 2019 11:38:54 +0100 (CET)
Date:   Wed, 25 Dec 2019 10:38:54 -0000
From:   "tip-bot2 for Ard Biesheuvel" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: efi/urgent] x86/efistub: Disable paging at mixed mode entry
Cc:     Ard Biesheuvel <ardb@kernel.org>, <stable@vger.kernel.org>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Hans de Goede <hdegoede@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20191224132909.102540-4-ardb@kernel.org>
References: <20191224132909.102540-4-ardb@kernel.org>
MIME-Version: 1.0
Message-ID: <157727033419.30329.4854144376331074852.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the efi/urgent branch of tip:

Commit-ID:     4911ee401b7ceff8f38e0ac597cbf503d71e690c
Gitweb:        https://git.kernel.org/tip/4911ee401b7ceff8f38e0ac597cbf503d71e690c
Author:        Ard Biesheuvel <ardb@kernel.org>
AuthorDate:    Tue, 24 Dec 2019 14:29:09 +01:00
Committer:     Ingo Molnar <mingo@kernel.org>
CommitterDate: Wed, 25 Dec 2019 10:46:07 +01:00

x86/efistub: Disable paging at mixed mode entry

The EFI mixed mode entry code goes through the ordinary startup_32()
routine before jumping into the kernel's EFI boot code in 64-bit
mode. The 32-bit startup code must be entered with paging disabled,
but this is not documented as a requirement for the EFI handover
protocol, and so we should disable paging explicitly when entering
the kernel from 32-bit EFI firmware.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Cc: <stable@vger.kernel.org>
Cc: Arvind Sankar <nivedita@alum.mit.edu>
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-efi@vger.kernel.org
Link: https://lkml.kernel.org/r/20191224132909.102540-4-ardb@kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/boot/compressed/head_64.S | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index 58a512e..ee60b81 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -244,6 +244,11 @@ SYM_FUNC_START(efi32_stub_entry)
 	leal	efi32_config(%ebp), %eax
 	movl	%eax, efi_config(%ebp)
 
+	/* Disable paging */
+	movl	%cr0, %eax
+	btrl	$X86_CR0_PG_BIT, %eax
+	movl	%eax, %cr0
+
 	jmp	startup_32
 SYM_FUNC_END(efi32_stub_entry)
 #endif
