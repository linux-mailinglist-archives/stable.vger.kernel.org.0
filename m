Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 048351F2692
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 01:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730793AbgFHX06 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:26:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:54908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732085AbgFHX05 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:26:57 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6C2920775;
        Mon,  8 Jun 2020 23:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658816;
        bh=C2yTplfXnz0lDxjv2W+yY3SAan1E8kfM48w4mLwAyDU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p/4mw442XFZL75TAEbzJIEFtcMJ0lzTpjaJ2Yi5tW58nMG4K2it/SBoNxlCh8vfit
         M8o/sUZfL4+/ccC26HpLZM5JtdFWVM7jerDecKpBmu70YJ0QGdgeuAsbC+Z+MwA7ri
         o3b3D6uroB1Es/zye/tGn0cLlP8p4Gu592b5vCCg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.9 12/50] ARM: 8978/1: mm: make act_mm() respect THREAD_SIZE
Date:   Mon,  8 Jun 2020 19:26:02 -0400
Message-Id: <20200608232640.3370262-12-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608232640.3370262-1-sashal@kernel.org>
References: <20200608232640.3370262-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit e1de94380af588bdf6ad6f0cc1f75004c35bc096 ]

Recent work with KASan exposed the folling hard-coded bitmask
in arch/arm/mm/proc-macros.S:

  bic     rd, sp, #8128
  bic     rd, rd, #63

This forms the bitmask 0x1FFF that is coinciding with
(PAGE_SIZE << THREAD_SIZE_ORDER) - 1, this code was assuming
that THREAD_SIZE is always 8K (8192).

As KASan was increasing THREAD_SIZE_ORDER to 2, I ran into
this bug.

Fix it by this little oneline suggested by Ard:

  bic     rd, sp, #(THREAD_SIZE - 1) & ~63

Where THREAD_SIZE is defined using THREAD_SIZE_ORDER.

We have to also include <linux/const.h> since the THREAD_SIZE
expands to use the _AC() macro.

Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Suggested-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mm/proc-macros.S | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mm/proc-macros.S b/arch/arm/mm/proc-macros.S
index f8bb65032b79..796e8f675a93 100644
--- a/arch/arm/mm/proc-macros.S
+++ b/arch/arm/mm/proc-macros.S
@@ -4,6 +4,7 @@
  *  VMA_VM_FLAGS
  *  VM_EXEC
  */
+#include <linux/const.h>
 #include <asm/asm-offsets.h>
 #include <asm/thread_info.h>
 
@@ -34,7 +35,7 @@
  * act_mm - get current->active_mm
  */
 	.macro	act_mm, rd
-	bic	\rd, sp, #8128
+	bic	\rd, sp, #(THREAD_SIZE - 1) & ~63
 	bic	\rd, \rd, #63
 	ldr	\rd, [\rd, #TI_TASK]
 	ldr	\rd, [\rd, #TSK_ACTIVE_MM]
-- 
2.25.1

