Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9016328493
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:42:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234410AbhCAQiL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:38:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:36258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232476AbhCAQbz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:31:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B29DF64F27;
        Mon,  1 Mar 2021 16:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614615862;
        bh=5FauW6J1IEOkgg3VnYsD7Xk4rN8tUkgz0M54MsEALtM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fl+RJPCmvJyGR3zEuOAPnCezhsOULuZR5zsWvRspFQHNBLAu4c8pBioxR50tK5ctS
         nMYRra2QDdn7d5GIw3k6pVifkO/vkr7jy/xe+RPClzLvcg5tcJFRUz2CFyh/BCsu4t
         MNw8g4kGp6dNpEVu13LrQCePx2vfdbJ3KLMMcGCA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Will Deacon <will@kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 086/134] arm64: Add missing ISB after invalidating TLB in __primary_switch
Date:   Mon,  1 Mar 2021 17:13:07 +0100
Message-Id: <20210301161017.804816014@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161013.585393984@linuxfoundation.org>
References: <20210301161013.585393984@linuxfoundation.org>
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
index aba534959377b..3875423836622 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -846,6 +846,7 @@ __primary_switch:
 
 	tlbi	vmalle1				// Remove any stale TLB entries
 	dsb	nsh
+	isb
 
 	msr	sctlr_el1, x19			// re-enable the MMU
 	isb
-- 
2.27.0



