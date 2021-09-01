Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C98F33FDC91
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345383AbhIAMvZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:51:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:53708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346422AbhIAMuN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:50:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DCB0561100;
        Wed,  1 Sep 2021 12:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630500104;
        bh=RraiY9EupY4eMBstcRZsBdE0zqlScNj3R6G7l/dTIn8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j7qtVvcveoVp0/eRXkJ7jn7QXJ4OPjucytnb2mnw2ojjvzp150tdm2PO9VnuOJrIe
         /fU0GL5BgSiJbFVHxbznaPZRfAlvVuPT2IeJFJS58raKzMGvivPDOfeiMbdaObC0/L
         of+2ieqPM+BZhydWtZpeAql6up0N8VtEAqu4Ga20=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oupton@google.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 097/113] arm64: initialize all of CNTHCTL_EL2
Date:   Wed,  1 Sep 2021 14:28:52 +0200
Message-Id: <20210901122305.187252773@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122301.984263453@linuxfoundation.org>
References: <20210901122301.984263453@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



