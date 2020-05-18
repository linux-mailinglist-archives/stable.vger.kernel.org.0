Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A33FE1D844A
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732890AbgERSFG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:05:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:52512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732887AbgERSFF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:05:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2D2420715;
        Mon, 18 May 2020 18:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589825105;
        bh=c+kKypr0TA5TgWuMuZZZ+dMSCVKlESVb8rQtUPAIsOI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1tDqJwRDmAenEyQ2Vk4bXWYuFm7YMKC8/w3jzaKGFV2cbVDO4BZRJE+ELQYetwqx1
         3EtQbxX+Zp0fYkyg267cq+sDiEfgCdzKCox84Wxc6oBkizAgHvuA0deTCmaBn/G74W
         m70fTIxO4aULDcOSqLoHK8ancvcZxnec6Iw7Gd9E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.6 132/194] gcc-10: mark more functions __init to avoid section mismatch warnings
Date:   Mon, 18 May 2020 19:37:02 +0200
Message-Id: <20200518173542.433611594@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
References: <20200518173531.455604187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

commit e99332e7b4cda6e60f5b5916cf9943a79dbef902 upstream.

It seems that for whatever reason, gcc-10 ends up not inlining a couple
of functions that used to be inlined before.  Even if they only have one
single callsite - it looks like gcc may have decided that the code was
unlikely, and not worth inlining.

The code generation difference is harmless, but caused a few new section
mismatch errors, since the (now no longer inlined) function wasn't in
the __init section, but called other init functions:

   Section mismatch in reference from the function kexec_free_initrd() to the function .init.text:free_initrd_mem()
   Section mismatch in reference from the function tpm2_calc_event_log_size() to the function .init.text:early_memremap()
   Section mismatch in reference from the function tpm2_calc_event_log_size() to the function .init.text:early_memunmap()

So add the appropriate __init annotation to make modpost not complain.
In both cases there were trivially just a single callsite from another
__init function.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/firmware/efi/tpm.c |    2 +-
 init/initramfs.c           |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/firmware/efi/tpm.c
+++ b/drivers/firmware/efi/tpm.c
@@ -16,7 +16,7 @@
 int efi_tpm_final_log_size;
 EXPORT_SYMBOL(efi_tpm_final_log_size);
 
-static int tpm2_calc_event_log_size(void *data, int count, void *size_info)
+static int __init tpm2_calc_event_log_size(void *data, int count, void *size_info)
 {
 	struct tcg_pcr_event2_head *header;
 	int event_size, size = 0;
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -542,7 +542,7 @@ void __weak free_initrd_mem(unsigned lon
 }
 
 #ifdef CONFIG_KEXEC_CORE
-static bool kexec_free_initrd(void)
+static bool __init kexec_free_initrd(void)
 {
 	unsigned long crashk_start = (unsigned long)__va(crashk_res.start);
 	unsigned long crashk_end   = (unsigned long)__va(crashk_res.end);


