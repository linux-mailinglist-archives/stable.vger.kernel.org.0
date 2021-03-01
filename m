Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62E6632859D
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:59:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234958AbhCAQz2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:55:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:51730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235765AbhCAQti (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:49:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B70C64EFB;
        Mon,  1 Mar 2021 16:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616340;
        bh=YG4wK7MIfwQCfm7BPfH4HHYivUgNgaMlKndAI7ZqUlg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=moJOoDiRBSG/q8tdgc2rOOOYGs3q6/jLwtxgqhbMCT6Jr5NeDHPft+aE8X4oBPurV
         gjOjbwjg90Sc0mGj7MIhmi0SpgLZxsi0AmtD9zkYh/0jMsqvoAtGuj+vYZ1Y2CN055
         CiEi2CRCy+M5YsiOTtyjquREeUb9btBalBnMb14I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Will Deacon <will@kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 117/176] arm64: Add missing ISB after invalidating TLB in __primary_switch
Date:   Mon,  1 Mar 2021 17:13:10 +0100
Message-Id: <20210301161026.797040142@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161020.931630716@linuxfoundation.org>
References: <20210301161020.931630716@linuxfoundation.org>
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
index bd24c8aed6120..30d1e850b16ae 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -756,6 +756,7 @@ __primary_switch:
 
 	tlbi	vmalle1				// Remove any stale TLB entries
 	dsb	nsh
+	isb
 
 	msr	sctlr_el1, x19			// re-enable the MMU
 	isb
-- 
2.27.0



