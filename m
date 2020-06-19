Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 754AA201726
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389313AbgFSQe5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:34:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:43368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389303AbgFSOuZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:50:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D54DC20776;
        Fri, 19 Jun 2020 14:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578225;
        bh=asa8ONHvLvSLrkUv5RGqx9vJCcv05F7tTMtmQgGoEZs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VhzMK27gjld7/GhmVRtR1dy21/5qrhbgUf/kqEGVJ2RaE9KUBOqK2sBCJ99yGxaRz
         V+mLNkkSlje2rlJ1vKLDzFdnr0Txc0vJktZJasCEmLWBuonn0DOYw5hgyD1+qWlStD
         qwLjh9IR4T0kPFxrRF+tOPuZEQ+X5xvxYnnaQfqg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 091/190] ARM: 8978/1: mm: make act_mm() respect THREAD_SIZE
Date:   Fri, 19 Jun 2020 16:32:16 +0200
Message-Id: <20200619141638.139733524@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141633.446429600@linuxfoundation.org>
References: <20200619141633.446429600@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 5461d589a1e2..60ac7c5999a9 100644
--- a/arch/arm/mm/proc-macros.S
+++ b/arch/arm/mm/proc-macros.S
@@ -5,6 +5,7 @@
  *  VMA_VM_FLAGS
  *  VM_EXEC
  */
+#include <linux/const.h>
 #include <asm/asm-offsets.h>
 #include <asm/thread_info.h>
 
@@ -30,7 +31,7 @@
  * act_mm - get current->active_mm
  */
 	.macro	act_mm, rd
-	bic	\rd, sp, #8128
+	bic	\rd, sp, #(THREAD_SIZE - 1) & ~63
 	bic	\rd, \rd, #63
 	ldr	\rd, [\rd, #TI_TASK]
 	.if (TSK_ACTIVE_MM > IMM12_MASK)
-- 
2.25.1



