Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DEDA4699E4
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:02:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345521AbhLFPES (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:04:18 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:54090 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345427AbhLFPDy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:03:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64AF761319;
        Mon,  6 Dec 2021 15:00:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49D71C341C1;
        Mon,  6 Dec 2021 15:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638802824;
        bh=dGZ+aeRUEVUU05MXRfDYMHAomsv3n0+3INXDhZ1iz0c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YozdksmL58aNtPBNWHNtUJbWWu6hxccCwQQSxczsl74TH4WEDDS9JEO0UFbBY7Fi/
         ycVAE8zqlvpzjhWfTt1JBVxwN1jw/lC0Sm9rusiaFvS4wKokHcS79u9zAfIhmL9Ui8
         hTxamLG/kbDRSgHEBR4y2YXlZRhkI2xXqBJ0fB+A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Takashi Iwai <tiwai@suse.de>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 15/52] ARM: socfpga: Fix crash with CONFIG_FORTIRY_SOURCE
Date:   Mon,  6 Dec 2021 15:55:59 +0100
Message-Id: <20211206145548.424698947@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145547.892668902@linuxfoundation.org>
References: <20211206145547.892668902@linuxfoundation.org>
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
index 5bc6ea87cdf74..1b41e23db98ef 100644
--- a/arch/arm/mach-socfpga/core.h
+++ b/arch/arm/mach-socfpga/core.h
@@ -44,7 +44,7 @@ extern void __iomem *sdr_ctl_base_addr;
 u32 socfpga_sdram_self_refresh(u32 sdr_base);
 extern unsigned int socfpga_sdram_self_refresh_sz;
 
-extern char secondary_trampoline, secondary_trampoline_end;
+extern char secondary_trampoline[], secondary_trampoline_end[];
 
 extern unsigned long socfpga_cpu1start_addr;
 
diff --git a/arch/arm/mach-socfpga/platsmp.c b/arch/arm/mach-socfpga/platsmp.c
index 15c8ce8965f43..ff1d13d3ef72e 100644
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
 
 		writel(virt_to_phys(secondary_startup),
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
 
 		writel(virt_to_phys(secondary_startup),
 		       sys_manager_base_addr + (socfpga_cpu1start_addr & 0x00000fff));
-- 
2.33.0



