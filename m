Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ED9A1B6791
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:08:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728718AbgDWXHE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:07:04 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51234 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728709AbgDWXHE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:07:04 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvU-0004hm-BW; Fri, 24 Apr 2020 00:06:36 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvR-00E6qI-Tl; Fri, 24 Apr 2020 00:06:33 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Arvind Sankar" <nivedita@alum.mit.edu>,
        "Ingo Molnar" <mingo@kernel.org>,
        "Ard Biesheuvel" <ardb@kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Hans de Goede" <hdegoede@redhat.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        linux-efi@vger.kernel.org
Date:   Fri, 24 Apr 2020 00:06:07 +0100
Message-ID: <lsq.1587683028.856459089@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 140/245] x86/efistub: Disable paging at mixed mode entry
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ardb@kernel.org>

commit 4911ee401b7ceff8f38e0ac597cbf503d71e690c upstream.

The EFI mixed mode entry code goes through the ordinary startup_32()
routine before jumping into the kernel's EFI boot code in 64-bit
mode. The 32-bit startup code must be entered with paging disabled,
but this is not documented as a requirement for the EFI handover
protocol, and so we should disable paging explicitly when entering
the kernel from 32-bit EFI firmware.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Cc: Arvind Sankar <nivedita@alum.mit.edu>
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-efi@vger.kernel.org
Link: https://lkml.kernel.org/r/20191224132909.102540-4-ardb@kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/boot/compressed/head_64.S | 5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -216,6 +216,11 @@ ENTRY(efi32_stub_entry)
 	leal	efi32_config(%ebp), %eax
 	movl	%eax, efi_config(%ebp)
 
+	/* Disable paging */
+	movl	%cr0, %eax
+	btrl	$X86_CR0_PG_BIT, %eax
+	movl	%eax, %cr0
+
 	jmp	startup_32
 ENDPROC(efi32_stub_entry)
 #endif

