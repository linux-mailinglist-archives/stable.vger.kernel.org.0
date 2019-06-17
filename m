Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B51E49402
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729375AbfFQVXn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:23:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:48880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729127AbfFQVXj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:23:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D71F42063F;
        Mon, 17 Jun 2019 21:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806618;
        bh=KcMuKTI5gDno5w4zQGw5XRL5F7L95Z/bmJYo59bCvjY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vRjQ7zTla8mQU0ORLc8+0AFOvyViiq57EVObM1HAoZ6Ppb5p/xYMiToaNGK/LVPf/
         t/9Rfg28vDleF7f79vZWUljuIXZ6mPdHjQsBTxuK4nFIy0UxJf0Dt6/6H//D/S79c8
         6lPFdYYdz736IZK0CX2ZLo2IkET1L1uaDocM/SII=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.1 114/115] powerpc: Fix kexec failure on book3s/32
Date:   Mon, 17 Jun 2019 23:10:14 +0200
Message-Id: <20190617210805.662683030@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210759.929316339@linuxfoundation.org>
References: <20190617210759.929316339@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@c-s.fr>

commit 6c284228eb356a1ec62a704b4d2329711831eaed upstream.

In the old days, _PAGE_EXEC didn't exist on 6xx aka book3s/32.
Therefore, allthough __mapin_ram_chunk() was already mapping kernel
text with PAGE_KERNEL_TEXT and the rest with PAGE_KERNEL, the entire
memory was executable. Part of the memory (first 512kbytes) was
mapped with BATs instead of page table, but it was also entirely
mapped as executable.

In commit 385e89d5b20f ("powerpc/mm: add exec protection on
powerpc 603"), we started adding exec protection to some 6xx, namely
the 603, for pages mapped via pagetables.

Then, in commit 63b2bc619565 ("powerpc/mm/32s: Use BATs for
STRICT_KERNEL_RWX"), the exec protection was extended to BAT mapped
memory, so that really only the kernel text could be executed.

The problem here is that kexec is based on copying some code into
upper part of memory then executing it from there in order to install
a fresh new kernel at its definitive location.

However, the code is position independant and first part of it is
just there to deactivate the MMU and jump to the second part. So it
is possible to run this first part inplace instead of running the
copy. Once the MMU is off, there is no protection anymore and the
second part of the code will just run as before.

Reported-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Fixes: 63b2bc619565 ("powerpc/mm/32s: Use BATs for STRICT_KERNEL_RWX")
Cc: stable@vger.kernel.org # v5.1+
Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Tested-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/include/asm/kexec.h       |    3 +++
 arch/powerpc/kernel/machine_kexec_32.c |    4 +++-
 2 files changed, 6 insertions(+), 1 deletion(-)

--- a/arch/powerpc/include/asm/kexec.h
+++ b/arch/powerpc/include/asm/kexec.h
@@ -94,6 +94,9 @@ static inline bool kdump_in_progress(voi
 	return crashing_cpu >= 0;
 }
 
+void relocate_new_kernel(unsigned long indirection_page, unsigned long reboot_code_buffer,
+			 unsigned long start_address) __noreturn;
+
 #ifdef CONFIG_KEXEC_FILE
 extern const struct kexec_file_ops kexec_elf64_ops;
 
--- a/arch/powerpc/kernel/machine_kexec_32.c
+++ b/arch/powerpc/kernel/machine_kexec_32.c
@@ -30,7 +30,6 @@ typedef void (*relocate_new_kernel_t)(
  */
 void default_machine_kexec(struct kimage *image)
 {
-	extern const unsigned char relocate_new_kernel[];
 	extern const unsigned int relocate_new_kernel_size;
 	unsigned long page_list;
 	unsigned long reboot_code_buffer, reboot_code_buffer_phys;
@@ -58,6 +57,9 @@ void default_machine_kexec(struct kimage
 				reboot_code_buffer + KEXEC_CONTROL_PAGE_SIZE);
 	printk(KERN_INFO "Bye!\n");
 
+	if (!IS_ENABLED(CONFIG_FSL_BOOKE) && !IS_ENABLED(CONFIG_44x))
+		relocate_new_kernel(page_list, reboot_code_buffer_phys, image->start);
+
 	/* now call it */
 	rnk = (relocate_new_kernel_t) reboot_code_buffer;
 	(*rnk)(page_list, reboot_code_buffer_phys, image->start);


