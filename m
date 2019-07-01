Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8304026FEB
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 22:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730766AbfEVTXI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 15:23:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:44006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730760AbfEVTXI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 15:23:08 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CFDF220675;
        Wed, 22 May 2019 19:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558552987;
        bh=t5xRMUEEpDNJ3nOdGBJbwH704jBjmeeKEfBphf6hj0E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n2HxLgM4G/OMB8O8GlZOfhcK6mgrOyrVKM2U5lgsKywlGuUldPX8n5mbhZDTCH7ap
         pMP8N7Zcxje3PdkOTss3NxWiTrvpV0hqsyA5kXv/LtZ6iF965sX7j8+6bbIVyphPBd
         IwIHf6hlIlu9u/eB0RPjKnL5fuyEHa2JC3SduBsc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Philipp Rudo <prudo@linux.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 064/375] s390/kexec_file: Fix detection of text segment in ELF loader
Date:   Wed, 22 May 2019 15:16:04 -0400
Message-Id: <20190522192115.22666-64-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522192115.22666-1-sashal@kernel.org>
References: <20190522192115.22666-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Philipp Rudo <prudo@linux.ibm.com>

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

