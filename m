Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD72E329106
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:22:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243156AbhCAUSf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:18:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:38410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242376AbhCAUHI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:07:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E05C653A6;
        Mon,  1 Mar 2021 17:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621556;
        bh=LHXl/GE30Fqn9Z23pMI4r04dn6VenSwKqPGKpocKTwI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PSb3hGkdH8JUTMCYvE2xE1PxzWi8BSco98uQxuxZlUbHfywhU3YDkSfO82/2ZYwOp
         C3UCvVof7zb4D9/4aU7jEZ3KzLSDbs30SJS91LPP6bBDCDdNVk5ImtleBXmN3u3/Nr
         6w0olXih4+lkIHqnkMZQfEj0Yc8+wA07DkSAvt3Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Will Deacon <will@kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 558/775] arm64: Add missing ISB after invalidating TLB in __primary_switch
Date:   Mon,  1 Mar 2021 17:12:06 +0100
Message-Id: <20210301161229.057663358@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit 9d41053e8dc115c92b8002c3db5f545d7602498b ]

Although there has been a bit of back and forth on the subject, it
appears that invalidating TLBs requires an ISB instruction when FEAT_ETS
is not implemented by the CPU.

>From the bible:

  | In an implementation that does not implement FEAT_ETS, a TLB
  | maintenance instruction executed by a PE, PEx, can complete at any
  | time after it is issued, but is only guaranteed to be finished for a
  | PE, PEx, after the execution of DSB by the PEx followed by a Context
  | synchronization event

Add the missing ISB in __primary_switch, just in case.

Fixes: 3c5e9f238bc4 ("arm64: head.S: move KASLR processing out of __enable_mmu()")
Suggested-by: Will Deacon <will@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Link: https://lore.kernel.org/r/20210224093738.3629662-3-maz@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/head.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index a0dc987724eda..7ec430e18f95e 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -882,6 +882,7 @@ SYM_FUNC_START_LOCAL(__primary_switch)
 
 	tlbi	vmalle1				// Remove any stale TLB entries
 	dsb	nsh
+	isb
 
 	msr	sctlr_el1, x19			// re-enable the MMU
 	isb
-- 
2.27.0



