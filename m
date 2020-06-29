Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 430E120E2AF
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731284AbgF2VHv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:07:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:53668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729718AbgF2TKQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:10:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9EF91254B0;
        Mon, 29 Jun 2020 15:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593446007;
        bh=w7GlQFTaYFcZ6jych7cJJuYH9oE5jPL9nxOqmIsBkFI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c2sos6CMpTYu+zYEjSOByQ+NZ1oB3g5uHqd03SmudEMo6whW1Kg/skBfDQErTgQ2D
         MG9TDlJ94HFW8jd6hK3vf+RlBcuZS3H1HzGJE4cK7L3Q3FRaMStY4ZFxpBCUTIN2ms
         i5bsJ2aFTCoAZn64P4Vnm6YlrxCKouJEHIUZuy44=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pingfan Liu <kernelfans@gmail.com>,
        Hari Bathini <hbathini@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 014/135] powerpc/crashkernel: Take "mem=" option into account
Date:   Mon, 29 Jun 2020 11:51:08 -0400
Message-Id: <20200629155309.2495516-15-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629155309.2495516-1-sashal@kernel.org>
References: <20200629155309.2495516-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.229-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.229-rc1
X-KernelTest-Deadline: 2020-07-01T15:53+00:00
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
index 8dff2b3712190..a14d9b008f744 100644
--- a/arch/powerpc/kernel/machine_kexec.c
+++ b/arch/powerpc/kernel/machine_kexec.c
@@ -113,11 +113,12 @@ void machine_kexec(struct kimage *image)
 
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
@@ -176,6 +177,7 @@ void __init reserve_crashkernel(void)
 	/* Crash kernel trumps memory limit */
 	if (memory_limit && memory_limit <= crashk_res.end) {
 		memory_limit = crashk_res.end + 1;
+		total_mem_sz = memory_limit;
 		printk("Adjusted memory limit for crashkernel, now 0x%llx\n",
 		       memory_limit);
 	}
@@ -184,7 +186,7 @@ void __init reserve_crashkernel(void)
 			"for crashkernel (System RAM: %ldMB)\n",
 			(unsigned long)(crash_size >> 20),
 			(unsigned long)(crashk_res.start >> 20),
-			(unsigned long)(memblock_phys_mem_size() >> 20));
+			(unsigned long)(total_mem_sz >> 20));
 
 	if (!memblock_is_region_memory(crashk_res.start, crash_size) ||
 	    memblock_reserve(crashk_res.start, crash_size)) {
-- 
2.25.1

