Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6B8E328E40
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241579AbhCAT0t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:26:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:46144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241411AbhCATVo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:21:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3611864F96;
        Mon,  1 Mar 2021 17:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619470;
        bh=c6gpCmsCymry7e27fJgHF3wxpi7KEAg6KJWb6r0QVBo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AsL2cV7cO73KOqtAdGONWxYQWAS9R2Y15cab2HGPAJO/KNQDMgUmeoYuYXmvXyEFB
         RM8Ilg384uVxGSlxXjrNJIAeXQdJGVmnRGvAABdan/BoZT7ZvjUlOk0U4zWs6xsWg6
         52BaUJib5ZnghAPOKCcG/NFRWfgGkf4hybYbSC+M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Will Deacon <will@kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 466/663] arm64: Add missing ISB after invalidating TLB in __primary_switch
Date:   Mon,  1 Mar 2021 17:11:54 +0100
Message-Id: <20210301161204.917767509@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
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
index d8d9caf02834e..e7550a5289fef 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -985,6 +985,7 @@ SYM_FUNC_START_LOCAL(__primary_switch)
 
 	tlbi	vmalle1				// Remove any stale TLB entries
 	dsb	nsh
+	isb
 
 	msr	sctlr_el1, x19			// re-enable the MMU
 	isb
-- 
2.27.0



