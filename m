Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EEDD42B186
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 02:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237183AbhJMA6q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 20:58:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:42478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237188AbhJMA6Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Oct 2021 20:58:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 07A2760EBB;
        Wed, 13 Oct 2021 00:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634086573;
        bh=iFXk+FB0I1OuAahp1gYzQf2FJWqwEOwoD/erpq3GnFo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KmvdMotnpwf8lHJ0uuojEAYBlFAyHIkLl1gGkzq4+dml8JHUZd2eEvIGnOoiZIZpc
         DH1pV+Mql8TT7ds0GygHQxWVFVUNVbWqVuuue9rYrTrAQAzulJeK/CDxJ1yVx7m6Bc
         Pg/O4kVF9NYecjTag+uxDFPOd8jiTJgBmd0biPI3/YBq+Sj6UfxNjut+RDX5JtJEHw
         C5ACtEvsMax/TMEzJA6nR3CWft13xcV/gVTaYFF/bwTMpRnMbro6Zx7YA/wyYaoQwO
         PEgD5G1PcG4PH3YF2rvE/OnyS+HmEAHnTIpB6bFCPmNeaFfs7+6rkRiFWR2rizxm/g
         6ncbdDNdTobSA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Sasha Levin <sashal@kernel.org>, chris@zankel.net,
        linux-xtensa@linux-xtensa.org
Subject: [PATCH AUTOSEL 5.4 4/6] xtensa: xtfpga: Try software restart before simulating CPU reset
Date:   Tue, 12 Oct 2021 20:56:00 -0400
Message-Id: <20211013005603.700363-4-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211013005603.700363-1-sashal@kernel.org>
References: <20211013005603.700363-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 012e974501a270d8dfd4ee2039e1fdf7579c907e ]

Rebooting xtensa images loaded with the '-kernel' option in qemu does
not work. When executing a reboot command, the qemu session either hangs
or experiences an endless sequence of error messages.

  Kernel panic - not syncing: Unrecoverable error in exception handler

Reset code jumps to the CPU restart address, but Linux can not recover
from there because code and data in the kernel init sections have been
discarded and overwritten at this point.

XTFPGA platforms have a means to reset the CPU by writing 0xdead into a
specific FPGA IO address. When used in QEMU the kernel image loaded with
the '-kernel' option gets restored to its original state allowing the
machine to boot successfully.

Use that mechanism to attempt a platform reset. If it does not work,
fall back to the existing mechanism.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/xtensa/platforms/xtfpga/setup.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/xtensa/platforms/xtfpga/setup.c b/arch/xtensa/platforms/xtfpga/setup.c
index 61c5e2c45439..4edccb4d4a5f 100644
--- a/arch/xtensa/platforms/xtfpga/setup.c
+++ b/arch/xtensa/platforms/xtfpga/setup.c
@@ -50,8 +50,12 @@ void platform_power_off(void)
 
 void platform_restart(void)
 {
-	/* Flush and reset the mmu, simulate a processor reset, and
-	 * jump to the reset vector. */
+	/* Try software reset first. */
+	WRITE_ONCE(*(u32 *)XTFPGA_SWRST_VADDR, 0xdead);
+
+	/* If software reset did not work, flush and reset the mmu,
+	 * simulate a processor reset, and jump to the reset vector.
+	 */
 	cpu_reset();
 	/* control never gets here */
 }
-- 
2.33.0

