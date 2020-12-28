Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E94DA2E3B47
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:49:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405814AbgL1NsN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:48:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:49122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405805AbgL1NsL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:48:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C9E520738;
        Mon, 28 Dec 2020 13:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163245;
        bh=i8TmNjc1zhg9lK9uMMkZ+mwseLB8CutiwTGvjagY6ls=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qwphl4aCI+Y1in2A3K+txPAXJFzGAjab+VihH85IHNj6SzDGuft6dPbxanSQA2+As
         A0C09lPXNM53K0aLLQU+uVO8S9uNjCyEHJt44vkJJcYP1sUthNQdSRAG7I7ZsGWHFX
         0BjK+JuQ6dGvbX00PhA0sO3nGTlPSBpAJelDgy5A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Sverdlin <alexander.sverdlin@nokia.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 220/453] MIPS: Dont round up kernel sections size for memblock_add()
Date:   Mon, 28 Dec 2020 13:47:36 +0100
Message-Id: <20201228124947.803587883@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
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
index b8884de89c81e..82e44b31aad59 100644
--- a/arch/mips/kernel/setup.c
+++ b/arch/mips/kernel/setup.c
@@ -529,8 +529,8 @@ static void __init request_crashkernel(struct resource *res)
 
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



