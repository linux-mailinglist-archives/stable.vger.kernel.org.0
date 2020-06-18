Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E0CE1FE2CF
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730452AbgFRCEP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:04:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:56400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726893AbgFRBXJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:23:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5BE520776;
        Thu, 18 Jun 2020 01:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443388;
        bh=NDaq8fRA9wHmcZVVZsgyu3DjX1K94VnVGfHoZ36/JAs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lWBIpeW0d9M4vowv824mb84zKHDOAqITTi3mu61lWSQC7niu0k+KVm7e+Owi5WEPH
         tMMgGWgQBjq5e4JzPlOpKznOqcpMPEelHGTbhiIUQq7WfRuKepCrS/c0MxDB/2ytQv
         bqe6byXK+oVsKWE8gndkGAViKUqH6S/epc2cOwWg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pingfan Liu <kernelfans@gmail.com>,
        Hari Bathini <hbathini@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.19 038/172] powerpc/crashkernel: Take "mem=" option into account
Date:   Wed, 17 Jun 2020 21:20:04 -0400
Message-Id: <20200618012218.607130-38-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618012218.607130-1-sashal@kernel.org>
References: <20200618012218.607130-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pingfan Liu <kernelfans@gmail.com>

[ Upstream commit be5470e0c285a68dc3afdea965032f5ddc8269d7 ]

'mem=" option is an easy way to put high pressure on memory during
some test. Hence after applying the memory limit, instead of total
mem, the actual usable memory should be considered when reserving mem
for crashkernel. Otherwise the boot up may experience OOM issue.

E.g. it would reserve 4G prior to the change and 512M afterward, if
passing
crashkernel="2G-4G:384M,4G-16G:512M,16G-64G:1G,64G-128G:2G,128G-:4G",
and mem=5G on a 256G machine.

This issue is powerpc specific because it puts higher priority on
fadump and kdump reservation than on "mem=". Referring the following
code:
    if (fadump_reserve_mem() == 0)
            reserve_crashkernel();
    ...
    /* Ensure that total memory size is page-aligned. */
    limit = ALIGN(memory_limit ?: memblock_phys_mem_size(), PAGE_SIZE);
    memblock_enforce_memory_limit(limit);

While on other arches, the effect of "mem=" takes a higher priority
and pass through memblock_phys_mem_size() before calling
reserve_crashkernel().

Signed-off-by: Pingfan Liu <kernelfans@gmail.com>
Reviewed-by: Hari Bathini <hbathini@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/1585749644-4148-1-git-send-email-kernelfans@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/machine_kexec.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kernel/machine_kexec.c b/arch/powerpc/kernel/machine_kexec.c
index 63f5a9311a29..094c37fb07a9 100644
--- a/arch/powerpc/kernel/machine_kexec.c
+++ b/arch/powerpc/kernel/machine_kexec.c
@@ -116,11 +116,12 @@ void machine_kexec(struct kimage *image)
 
 void __init reserve_crashkernel(void)
 {
-	unsigned long long crash_size, crash_base;
+	unsigned long long crash_size, crash_base, total_mem_sz;
 	int ret;
 
+	total_mem_sz = memory_limit ? memory_limit : memblock_phys_mem_size();
 	/* use common parsing */
-	ret = parse_crashkernel(boot_command_line, memblock_phys_mem_size(),
+	ret = parse_crashkernel(boot_command_line, total_mem_sz,
 			&crash_size, &crash_base);
 	if (ret == 0 && crash_size > 0) {
 		crashk_res.start = crash_base;
@@ -179,6 +180,7 @@ void __init reserve_crashkernel(void)
 	/* Crash kernel trumps memory limit */
 	if (memory_limit && memory_limit <= crashk_res.end) {
 		memory_limit = crashk_res.end + 1;
+		total_mem_sz = memory_limit;
 		printk("Adjusted memory limit for crashkernel, now 0x%llx\n",
 		       memory_limit);
 	}
@@ -187,7 +189,7 @@ void __init reserve_crashkernel(void)
 			"for crashkernel (System RAM: %ldMB)\n",
 			(unsigned long)(crash_size >> 20),
 			(unsigned long)(crashk_res.start >> 20),
-			(unsigned long)(memblock_phys_mem_size() >> 20));
+			(unsigned long)(total_mem_sz >> 20));
 
 	if (!memblock_is_region_memory(crashk_res.start, crash_size) ||
 	    memblock_reserve(crashk_res.start, crash_size)) {
-- 
2.25.1

