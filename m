Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6133A2E40F4
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:01:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440293AbgL1ON6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:13:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:48914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440248AbgL1ON5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:13:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E69A622CB2;
        Mon, 28 Dec 2020 14:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164796;
        bh=isl4+ySKdxpAqkV8qastGXs+Tt8IJeVjB/0Mlkibikc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LrinNhfdJb1u733SOFzqoiWa6ot4m8b3R/SktPR0gHNorcE59FLkDKPMFFe9kjCcd
         1BVnAv34J1syF7OwYIDE8zX+V1137s+VnjR09+NlKVxgM5mQq8t0uduV4nm76j/YSN
         C2t10BOB3CygtKHiVYJn0T766z8GSkuGTn42MGrU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Sverdlin <alexander.sverdlin@nokia.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 301/717] MIPS: Dont round up kernel sections size for memblock_add()
Date:   Mon, 28 Dec 2020 13:44:59 +0100
Message-Id: <20201228125035.450181086@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Sverdlin <alexander.sverdlin@nokia.com>

[ Upstream commit d121f125af22a16f0f679293756d28a9691fa46d ]

Linux doesn't own the memory immediately after the kernel image. On Octeon
bootloader places a shared structure right close after the kernel _end,
refer to "struct cvmx_bootinfo *octeon_bootinfo" in cavium-octeon/setup.c.

If check_kernel_sections_mem() rounds the PFNs up, first memblock_alloc()
inside early_init_dt_alloc_memory_arch() <= device_tree_init() returns
memory block overlapping with the above octeon_bootinfo structure, which
is being overwritten afterwards.

Fixes: a94e4f24ec83 ("MIPS: init: Drop boot_mem_map")
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/kernel/setup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/kernel/setup.c b/arch/mips/kernel/setup.c
index ca579deef9391..9d11f68a9e8bb 100644
--- a/arch/mips/kernel/setup.c
+++ b/arch/mips/kernel/setup.c
@@ -498,8 +498,8 @@ static void __init request_crashkernel(struct resource *res)
 
 static void __init check_kernel_sections_mem(void)
 {
-	phys_addr_t start = PFN_PHYS(PFN_DOWN(__pa_symbol(&_text)));
-	phys_addr_t size = PFN_PHYS(PFN_UP(__pa_symbol(&_end))) - start;
+	phys_addr_t start = __pa_symbol(&_text);
+	phys_addr_t size = __pa_symbol(&_end) - start;
 
 	if (!memblock_is_region_memory(start, size)) {
 		pr_info("Kernel sections are not in the memory maps\n");
-- 
2.27.0



