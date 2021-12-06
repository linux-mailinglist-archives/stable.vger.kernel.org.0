Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FBE4469AE8
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:08:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356330AbhLFPLo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:11:44 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:57586 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347107AbhLFPIF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:08:05 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B170B61321;
        Mon,  6 Dec 2021 15:04:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98C1CC341C2;
        Mon,  6 Dec 2021 15:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803076;
        bh=eL40mdcuwcwg14dX1YLltQCctoZvMh7RDj71nkwNu9A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uyR2wv4HUXJZWh7xlC4GCdM+tdeqtAwy4dBjri/fqqbexGz/lhc0m1yS5Ex+4ro6J
         9Y4+7WlHaZ5vhPsliwfeDrajpmbS0hc2r/LJ3Qg8PoMgilycgwEURP2ixeY63q9Jxa
         85t9C4zVh8VMhjxcb2Gg66yzlg44BfKurXW7v3fM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Takashi Iwai <tiwai@suse.de>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 020/106] ARM: socfpga: Fix crash with CONFIG_FORTIRY_SOURCE
Date:   Mon,  6 Dec 2021 15:55:28 +0100
Message-Id: <20211206145556.069885456@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145555.386095297@linuxfoundation.org>
References: <20211206145555.386095297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 187bea472600dcc8d2eb714335053264dd437172 ]

When CONFIG_FORTIFY_SOURCE is set, memcpy() checks the potential
buffer overflow and panics.  The code in sofcpga bootstrapping
contains the memcpy() calls are mistakenly translated as the shorter
size, hence it triggers a panic as if it were overflowing.

This patch changes the secondary_trampoline and *_end definitions
to arrays for avoiding the false-positive crash above.

Fixes: 9c4566a117a6 ("ARM: socfpga: Enable SMP for socfpga")
Suggested-by: Kees Cook <keescook@chromium.org>
Buglink: https://bugzilla.suse.com/show_bug.cgi?id=1192473
Link: https://lore.kernel.org/r/20211117193244.31162-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-socfpga/core.h    | 2 +-
 arch/arm/mach-socfpga/platsmp.c | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-socfpga/core.h b/arch/arm/mach-socfpga/core.h
index 65e1817d8afe6..692a287a8712d 100644
--- a/arch/arm/mach-socfpga/core.h
+++ b/arch/arm/mach-socfpga/core.h
@@ -48,7 +48,7 @@ extern void __iomem *sdr_ctl_base_addr;
 u32 socfpga_sdram_self_refresh(u32 sdr_base);
 extern unsigned int socfpga_sdram_self_refresh_sz;
 
-extern char secondary_trampoline, secondary_trampoline_end;
+extern char secondary_trampoline[], secondary_trampoline_end[];
 
 extern unsigned long socfpga_cpu1start_addr;
 
diff --git a/arch/arm/mach-socfpga/platsmp.c b/arch/arm/mach-socfpga/platsmp.c
index 0ee76772b5074..a272999ce04b9 100644
--- a/arch/arm/mach-socfpga/platsmp.c
+++ b/arch/arm/mach-socfpga/platsmp.c
@@ -31,14 +31,14 @@
 
 static int socfpga_boot_secondary(unsigned int cpu, struct task_struct *idle)
 {
-	int trampoline_size = &secondary_trampoline_end - &secondary_trampoline;
+	int trampoline_size = secondary_trampoline_end - secondary_trampoline;
 
 	if (socfpga_cpu1start_addr) {
 		/* This will put CPU #1 into reset. */
 		writel(RSTMGR_MPUMODRST_CPU1,
 		       rst_manager_base_addr + SOCFPGA_RSTMGR_MODMPURST);
 
-		memcpy(phys_to_virt(0), &secondary_trampoline, trampoline_size);
+		memcpy(phys_to_virt(0), secondary_trampoline, trampoline_size);
 
 		writel(__pa_symbol(secondary_startup),
 		       sys_manager_base_addr + (socfpga_cpu1start_addr & 0x000000ff));
@@ -56,12 +56,12 @@ static int socfpga_boot_secondary(unsigned int cpu, struct task_struct *idle)
 
 static int socfpga_a10_boot_secondary(unsigned int cpu, struct task_struct *idle)
 {
-	int trampoline_size = &secondary_trampoline_end - &secondary_trampoline;
+	int trampoline_size = secondary_trampoline_end - secondary_trampoline;
 
 	if (socfpga_cpu1start_addr) {
 		writel(RSTMGR_MPUMODRST_CPU1, rst_manager_base_addr +
 		       SOCFPGA_A10_RSTMGR_MODMPURST);
-		memcpy(phys_to_virt(0), &secondary_trampoline, trampoline_size);
+		memcpy(phys_to_virt(0), secondary_trampoline, trampoline_size);
 
 		writel(__pa_symbol(secondary_startup),
 		       sys_manager_base_addr + (socfpga_cpu1start_addr & 0x00000fff));
-- 
2.33.0



