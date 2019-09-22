Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9F00BA7E9
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393364AbfIVTA3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 15:00:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:36148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395191AbfIVTA2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 15:00:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7BFA2184D;
        Sun, 22 Sep 2019 19:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178827;
        bh=8LVBhwOe9iKmTrHRY8JxBQfug0KuqOv9YxaYUxIzXu8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V2BJaXzd9hJybCIWNbBbXHjCc8QWdOubnpvQGsVAwoZeAgtogEuLivYaRhEz4mj3F
         pE9mOsrjP6YS+6faXZycDmbla23XwEOt/3lkEM3i2OL0j4q84ZK9WEV43rfIlaCT4M
         BED/A7KlapmX3/f4ntsCofkEdl4et2zvuAK4yGpk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 38/60] arm64: kpti: ensure patched kernel text is fetched from PoU
Date:   Sun, 22 Sep 2019 14:59:11 -0400
Message-Id: <20190922185934.4305-38-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922185934.4305-1-sashal@kernel.org>
References: <20190922185934.4305-1-sashal@kernel.org>
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
index 3ceec224d3d24..3b95e3126eebb 100644
--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -263,6 +263,15 @@ skip_pgd:
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

