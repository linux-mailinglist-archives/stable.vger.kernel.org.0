Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C868043A128
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:35:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235563AbhJYTh1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:37:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:53620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236417AbhJYTeh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:34:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE5E16117A;
        Mon, 25 Oct 2021 19:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190239;
        bh=tZDxhnml6J/pYC6SCT4v70fUfCAV5raH4h8fIzLk93Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CM3i0/b3sFE5ED6I7O3xrNUrTIZvbGhDc1mQHoJAXlXvCGt1g3qJkZOj309SkhztE
         tmg/gdYtXBqMWGnWlh/E9OXwfDvh/xJ00pc9JY9AqOHPsUGV90/T9kFcLjl6lhujmX
         4hJOo3dck7ABrWWGD+89sOVKq5zMiXPMuW0h7hAA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 10/95] xtensa: xtfpga: Try software restart before simulating CPU reset
Date:   Mon, 25 Oct 2021 21:14:07 +0200
Message-Id: <20211025190958.333595627@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190956.374447057@linuxfoundation.org>
References: <20211025190956.374447057@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 59b7f11f2a3e..538e6748e85a 100644
--- a/arch/xtensa/platforms/xtfpga/setup.c
+++ b/arch/xtensa/platforms/xtfpga/setup.c
@@ -51,8 +51,12 @@ void platform_power_off(void)
 
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



