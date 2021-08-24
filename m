Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A86A3F5499
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 02:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234633AbhHXA4A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Aug 2021 20:56:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:47676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234217AbhHXAzT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Aug 2021 20:55:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 901A061440;
        Tue, 24 Aug 2021 00:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629766471;
        bh=RraiY9EupY4eMBstcRZsBdE0zqlScNj3R6G7l/dTIn8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Oq19UaEIbPaFAxU2FdA+P8YIJWXjF1mlUHNR52Ov1ujBbq5QMSfWcl38QaHj9fXqy
         tAzKal7lEjXG1GlZs6M7miAZ7ATKmvvVXB1A8AOSkygfrKrf/x5t5bAAp+aeGJ/cJy
         qFTgIoHlxTH8+Wxdz3oXIUMFI2Pj47EfUWQAyR66tW/Jyo4CHD3TxfU5ZuUTjrw6US
         XohhthC5l3oPeUJ9BDjVsepnIeFGPBZncsziV3r6AwRiiTByOmNL87RVDCuV2efVgB
         BqtzgxjZMJwkOowC2igLM2m/wodcTkT9YT5zjEuGqWZZ9gVCU1Rqo6u5haERn9kjXs
         UqgYp1ESnkUSQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oupton@google.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.13 26/26] arm64: initialize all of CNTHCTL_EL2
Date:   Mon, 23 Aug 2021 20:53:56 -0400
Message-Id: <20210824005356.630888-26-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824005356.630888-1-sashal@kernel.org>
References: <20210824005356.630888-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit bde8fff82e4a4b0f000dbf4d5eadab2079be0b56 ]

In __init_el2_timers we initialize CNTHCTL_EL2.{EL1PCEN,EL1PCTEN} with a
RMW sequence, leaving all other bits UNKNOWN.

In general, we should initialize all bits in a register rather than
using an RMW sequence, since most bits are UNKNOWN out of reset, and as
new bits are added to the reigster their reset value might not result in
expected behaviour.

In the case of CNTHCTL_EL2, FEAT_ECV added a number of new control bits
in previously RES0 bits, which reset to UNKNOWN values, and may cause
issues for EL1 and EL0:

* CNTHCTL_EL2.ECV enables the CNTPOFF_EL2 offset (which itself resets to
  an UNKNOWN value) at EL0 and EL1. Since the offset could reset to
  distinct values across CPUs, when the control bit resets to 1 this
  could break timekeeping generally.

* CNTHCTL_EL2.{EL1TVT,EL1TVCT} trap EL0 and EL1 accesses to the EL1
  virtual timer/counter registers to EL2. When reset to 1, this could
  cause unexpected traps to EL2.

Initializing these bits to zero avoids these problems, and all other
bits in CNTHCTL_EL2 other than EL1PCEN and EL1PCTEN can safely be reset
to zero.

This patch ensures we initialize CNTHCTL_EL2 accordingly, only setting
EL1PCEN and EL1PCTEN, and setting all other bits to zero.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@google.com>
Cc: Will Deacon <will@kernel.org>
Reviewed-by: Oliver Upton <oupton@google.com>
Acked-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20210818161535.52786-1-mark.rutland@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/el2_setup.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
index 21fa330f498d..b83fb24954b7 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -33,8 +33,7 @@
  * EL2.
  */
 .macro __init_el2_timers
-	mrs	x0, cnthctl_el2
-	orr	x0, x0, #3			// Enable EL1 physical timers
+	mov	x0, #3				// Enable EL1 physical timers
 	msr	cnthctl_el2, x0
 	msr	cntvoff_el2, xzr		// Clear virtual offset
 .endm
-- 
2.30.2

