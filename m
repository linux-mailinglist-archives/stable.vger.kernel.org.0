Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1335CBA77F
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:48:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394953AbfIVS64 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 14:58:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:33712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394946AbfIVS6y (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:58:54 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98784206C2;
        Sun, 22 Sep 2019 18:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178733;
        bh=/LpltrAgNejfjNwAl2+uhOAMJdYtq16InXFtN/oWKtc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EQtSs2IyHvuTMw5AcC7yXGF0Q/qf2PNZS1tnUAnMZrSma0U6e+E5hwXE5gIsXJH1D
         JbEaxmKsdUBaXB4/5DYiRMejkgmv3Gz3vu9PCY1pZK4fDESCiyUCs1/qEOHnsAcEJ3
         POeVKOapA0hUx6R+GfrLIt/T7LrPF5MS5M/F30a4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 62/89] arm64: kpti: ensure patched kernel text is fetched from PoU
Date:   Sun, 22 Sep 2019 14:56:50 -0400
Message-Id: <20190922185717.3412-62-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922185717.3412-1-sashal@kernel.org>
References: <20190922185717.3412-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit f32c7a8e45105bd0af76872bf6eef0438ff12fb2 ]

While the MMUs is disabled, I-cache speculation can result in
instructions being fetched from the PoC. During boot we may patch
instructions (e.g. for alternatives and jump labels), and these may be
dirty at the PoU (and stale at the PoC).

Thus, while the MMU is disabled in the KPTI pagetable fixup code we may
load stale instructions into the I-cache, potentially leading to
subsequent crashes when executing regions of code which have been
modified at runtime.

Similarly to commit:

  8ec41987436d566f ("arm64: mm: ensure patched kernel text is fetched from PoU")

... we can invalidate the I-cache after enabling the MMU to prevent such
issues.

The KPTI pagetable fixup code itself should be clean to the PoC per the
boot protocol, so no maintenance is required for this code.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: James Morse <james.morse@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/mm/proc.S | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
index 034a3a2a38ee8..65b0401521846 100644
--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -280,6 +280,15 @@ skip_pgd:
 	msr	sctlr_el1, x18
 	isb
 
+	/*
+	 * Invalidate the local I-cache so that any instructions fetched
+	 * speculatively from the PoC are discarded, since they may have
+	 * been dynamically patched at the PoU.
+	 */
+	ic	iallu
+	dsb	nsh
+	isb
+
 	/* Set the flag to zero to indicate that we're all done */
 	str	wzr, [flag_ptr]
 	ret
-- 
2.20.1

