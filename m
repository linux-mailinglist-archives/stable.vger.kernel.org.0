Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D629F39091
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 17:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731110AbfFGPs2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 11:48:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:33736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729595AbfFGPs0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 11:48:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A160B2146E;
        Fri,  7 Jun 2019 15:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559922506;
        bh=cwnOVLmKEpvRBFH0Ig6PE4Oh87H1P0aBPwbVLs1vVGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xW6pz3zv5LCueT4gtQPdEBEv38P0PzckQapYO8jOV3yRUeSOdwn5bj3TP7W0EYdRt
         BTfhRUmZar8DUwrVtUxOPm8Dm7T81ap8Rah45wrmbdBIOlzUElVfwTf0PRIbxPYv9r
         iqr/JaIWfypi5ueDuYL2A8g+IuHaGiyqu1/V0NN4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thiago Jung Bauermann <bauerman@linux.ibm.com>,
        Dave Young <dyoung@redhat.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.1 38/85] powerpc/kexec: Fix loading of kernel + initramfs with kexec_file_load()
Date:   Fri,  7 Jun 2019 17:39:23 +0200
Message-Id: <20190607153853.944107768@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607153849.101321647@linuxfoundation.org>
References: <20190607153849.101321647@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thiago Jung Bauermann <bauerman@linux.ibm.com>

commit 8b909e3548706cbebc0a676067b81aadda57f47e upstream.

Commit b6664ba42f14 ("s390, kexec_file: drop arch_kexec_mem_walk()")
changed kexec_add_buffer() to skip searching for a memory location if
kexec_buf.mem is already set, and use the address that is there.

In powerpc code we reuse a kexec_buf variable for loading both the
kernel and the initramfs by resetting some of the fields between those
uses, but not mem. This causes kexec_add_buffer() to try to load the
kernel at the same address where initramfs will be loaded, which is
naturally rejected:

  # kexec -s -l --initrd initramfs vmlinuz
  kexec_file_load failed: Invalid argument

Setting the mem field before every call to kexec_add_buffer() fixes
this regression.

Fixes: b6664ba42f14 ("s390, kexec_file: drop arch_kexec_mem_walk()")
Cc: stable@vger.kernel.org # v5.0+
Signed-off-by: Thiago Jung Bauermann <bauerman@linux.ibm.com>
Reviewed-by: Dave Young <dyoung@redhat.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/kexec_elf_64.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/arch/powerpc/kernel/kexec_elf_64.c
+++ b/arch/powerpc/kernel/kexec_elf_64.c
@@ -547,6 +547,7 @@ static int elf_exec_load(struct kimage *
 		kbuf.memsz = phdr->p_memsz;
 		kbuf.buf_align = phdr->p_align;
 		kbuf.buf_min = phdr->p_paddr + base;
+		kbuf.mem = KEXEC_BUF_MEM_UNKNOWN;
 		ret = kexec_add_buffer(&kbuf);
 		if (ret)
 			goto out;
@@ -581,7 +582,8 @@ static void *elf64_load(struct kimage *i
 	struct kexec_buf kbuf = { .image = image, .buf_min = 0,
 				  .buf_max = ppc64_rma_size };
 	struct kexec_buf pbuf = { .image = image, .buf_min = 0,
-				  .buf_max = ppc64_rma_size, .top_down = true };
+				  .buf_max = ppc64_rma_size, .top_down = true,
+				  .mem = KEXEC_BUF_MEM_UNKNOWN };
 
 	ret = build_elf_exec_info(kernel_buf, kernel_len, &ehdr, &elf_info);
 	if (ret)
@@ -606,6 +608,7 @@ static void *elf64_load(struct kimage *i
 		kbuf.bufsz = kbuf.memsz = initrd_len;
 		kbuf.buf_align = PAGE_SIZE;
 		kbuf.top_down = false;
+		kbuf.mem = KEXEC_BUF_MEM_UNKNOWN;
 		ret = kexec_add_buffer(&kbuf);
 		if (ret)
 			goto out;
@@ -638,6 +641,7 @@ static void *elf64_load(struct kimage *i
 	kbuf.bufsz = kbuf.memsz = fdt_size;
 	kbuf.buf_align = PAGE_SIZE;
 	kbuf.top_down = true;
+	kbuf.mem = KEXEC_BUF_MEM_UNKNOWN;
 	ret = kexec_add_buffer(&kbuf);
 	if (ret)
 		goto out;


