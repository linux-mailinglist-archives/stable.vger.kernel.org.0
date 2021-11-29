Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 225324623C3
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 22:50:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232289AbhK2VyD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 16:54:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232398AbhK2Vvx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 16:51:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B02FC0F4B13;
        Mon, 29 Nov 2021 10:25:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C45F7B815DB;
        Mon, 29 Nov 2021 18:25:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAAABC53FAD;
        Mon, 29 Nov 2021 18:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210340;
        bh=M+PHgp3FQ13zYAqDWhSXFEp5Tw2qjySumZ5hPHWjOl8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pDh8P6dSSiSY+mAumRVyuX3iB2OIZzmIedj0RN1PDS7dSgVHEpGu51cSyBRRcaqm8
         wRM314rv7R1IiBcbVdUW9C+YsJFYkOWcoJPQJL3b2eWdGWdsaxxQnWdRA8hVCHgGBL
         JZEb9ix+mSyApgFxyshcgR7/oh8d5qbEncwCuXuA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Takashi Iwai <tiwai@suse.de>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 54/92] ARM: socfpga: Fix crash with CONFIG_FORTIRY_SOURCE
Date:   Mon, 29 Nov 2021 19:18:23 +0100
Message-Id: <20211129181709.223344279@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181707.392764191@linuxfoundation.org>
References: <20211129181707.392764191@linuxfoundation.org>
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
index fc2608b18a0d0..18f01190dcfd4 100644
--- a/arch/arm/mach-socfpga/core.h
+++ b/arch/arm/mach-socfpga/core.h
@@ -33,7 +33,7 @@ extern void __iomem *sdr_ctl_base_addr;
 u32 socfpga_sdram_self_refresh(u32 sdr_base);
 extern unsigned int socfpga_sdram_self_refresh_sz;
 
-extern char secondary_trampoline, secondary_trampoline_end;
+extern char secondary_trampoline[], secondary_trampoline_end[];
 
 extern unsigned long socfpga_cpu1start_addr;
 
diff --git a/arch/arm/mach-socfpga/platsmp.c b/arch/arm/mach-socfpga/platsmp.c
index fbb80b883e5dd..201191cf68f32 100644
--- a/arch/arm/mach-socfpga/platsmp.c
+++ b/arch/arm/mach-socfpga/platsmp.c
@@ -20,14 +20,14 @@
 
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
@@ -45,12 +45,12 @@ static int socfpga_boot_secondary(unsigned int cpu, struct task_struct *idle)
 
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



