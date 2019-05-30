Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 753B62F3BB
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729555AbfE3Ebn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:31:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:59634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729559AbfE3DNn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:13:43 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54FE02455E;
        Thu, 30 May 2019 03:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186023;
        bh=0CbJ8rpWm3HT9n56a02/4rzdQVexT5uxY+2zHGbKtZc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N7oQ4nq/4xlGoP344ipSxGbGlgygWp4PvBz0/37W5nqcml8Y6PGGSUlDJFx2vPUjl
         yoQ/qojvISQtBb328Nk3HEh5d5o0+zf6YBynMb178AYbR7Y+DKggiJA5ptVTDG8euU
         AbZUdRhacilhzY9JRD+8GmoN6iQkJiOeAEaWSgfU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Philipp Rudo <prudo@linux.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 094/346] s390/kexec_file: Fix detection of text segment in ELF loader
Date:   Wed, 29 May 2019 20:02:47 -0700
Message-Id: <20190530030545.927308458@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
References: <20190530030540.363386121@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 729829d775c9a5217abc784b2f16087d79c4eec8 ]

To register data for the next kernel (command line, oldmem_base, etc.) the
current kernel needs to find the ELF segment that contains head.S. This is
currently done by checking ifor 'phdr->p_paddr == 0'. This works fine for
the current kernel build but in theory the first few pages could be
skipped. Make the detection more robust by checking if the entry point lies
within the segment.

Signed-off-by: Philipp Rudo <prudo@linux.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/kexec_elf.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kernel/kexec_elf.c b/arch/s390/kernel/kexec_elf.c
index 5a286b012043b..602e7cc26d118 100644
--- a/arch/s390/kernel/kexec_elf.c
+++ b/arch/s390/kernel/kexec_elf.c
@@ -19,10 +19,15 @@ static int kexec_file_add_elf_kernel(struct kimage *image,
 	struct kexec_buf buf;
 	const Elf_Ehdr *ehdr;
 	const Elf_Phdr *phdr;
+	Elf_Addr entry;
 	int i, ret;
 
 	ehdr = (Elf_Ehdr *)kernel;
 	buf.image = image;
+	if (image->type == KEXEC_TYPE_CRASH)
+		entry = STARTUP_KDUMP_OFFSET;
+	else
+		entry = ehdr->e_entry;
 
 	phdr = (void *)ehdr + ehdr->e_phoff;
 	for (i = 0; i < ehdr->e_phnum; i++, phdr++) {
@@ -35,7 +40,7 @@ static int kexec_file_add_elf_kernel(struct kimage *image,
 		buf.mem = ALIGN(phdr->p_paddr, phdr->p_align);
 		buf.memsz = phdr->p_memsz;
 
-		if (phdr->p_paddr == 0) {
+		if (entry - phdr->p_paddr < phdr->p_memsz) {
 			data->kernel_buf = buf.buffer;
 			data->memsz += STARTUP_NORMAL_OFFSET;
 
-- 
2.20.1



