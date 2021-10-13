Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82CD642B1AC
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 02:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237250AbhJMA7i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 20:59:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:43232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237511AbhJMA6v (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Oct 2021 20:58:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 45AEC60F23;
        Wed, 13 Oct 2021 00:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634086609;
        bh=Kw7lkG9kOuWj0W+L7dSn2mt0ZsB27lwqqvz5rScPANU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sNVdv0xF/zmfI5EriZY+4WTR/HxdBkKyAfQVMbe3T0xEQlJzR0vX5gZ7LmY6VcMTc
         8WgyctOt+w/iFXHLeeKZF+k/Uhn+2J2g89cUawCuNeyToPAF5o2ZGqHXD7c2SwJUkD
         jCdQp0VzRgmNMbrUvwDdNKcNKMcVH53oE4oEu6PDkk+YK1C/RL8+Q9Ze+OKzkmC5Qc
         7tbWb6Yl00BqtbaqcYJrmrV2IlwlDdl4kAjefQ7cOe9K0m/IWmRk+KUwErRiFwajZX
         S98wn5Voq4kTYDAgTqKN9hB6K95gZZGw6+fd/179Uz/cQwtR1BeMREHiIL+2j+WNY0
         8ILsrmYiSV2gA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Sasha Levin <sashal@kernel.org>, chris@zankel.net,
        linux-xtensa@linux-xtensa.org
Subject: [PATCH AUTOSEL 4.9 2/4] xtensa: xtfpga: Try software restart before simulating CPU reset
Date:   Tue, 12 Oct 2021 20:56:41 -0400
Message-Id: <20211013005644.700705-2-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211013005644.700705-1-sashal@kernel.org>
References: <20211013005644.700705-1-sashal@kernel.org>
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
index 982e7c22e7ca..db5122765f16 100644
--- a/arch/xtensa/platforms/xtfpga/setup.c
+++ b/arch/xtensa/platforms/xtfpga/setup.c
@@ -54,8 +54,12 @@ void platform_power_off(void)
 
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

