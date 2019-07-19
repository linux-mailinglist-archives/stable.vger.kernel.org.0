Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB54E6DB8C
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387620AbfGSEJn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:09:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:44326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387737AbfGSEJn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:09:43 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E57C218D2;
        Fri, 19 Jul 2019 04:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563509382;
        bh=Mxzkh0Mw3Ybv4Xxihb2x+5icZh42/pDH9SvH9L+IcJM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s4zp87tam1B9eKIGrbohlSccERv0RAxOlaT0TeKPxv+2T2iTXoFSNf1AnAlrHGPcO
         Vep6TY1XVGzTAFXy4PwyZvcof2G2rvPes3hRWpyPEIG21Bke9qbR0uFJjaSxpzqfq9
         Y7VSGfQtLGj5bILDuFNPND9tz7Jfqo4ksgqA6mdo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 064/101] arm64: assembler: Switch ESB-instruction with a vanilla nop if !ARM64_HAS_RAS
Date:   Fri, 19 Jul 2019 00:06:55 -0400
Message-Id: <20190719040732.17285-64-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719040732.17285-1-sashal@kernel.org>
References: <20190719040732.17285-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Morse <james.morse@arm.com>

[ Upstream commit 2b68a2a963a157f024c67c0697b16f5f792c8a35 ]

The ESB-instruction is a nop on CPUs that don't implement the RAS
extensions. This lets us use it in places like the vectors without
having to use alternatives.

If someone disables CONFIG_ARM64_RAS_EXTN, this instruction still has
its RAS extensions behaviour, but we no longer read DISR_EL1 as this
register does depend on alternatives.

This could go wrong if we want to synchronize an SError from a KVM
guest. On a CPU that has the RAS extensions, but the KConfig option
was disabled, we consume the pending SError with no chance of ever
reading it.

Hide the ESB-instruction behind the CONFIG_ARM64_RAS_EXTN option,
outputting a regular nop if the feature has been disabled.

Reported-by: Julien Thierry <julien.thierry@arm.com>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/assembler.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index f90f5d83b228..5a97ac853168 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -112,7 +112,11 @@
  * RAS Error Synchronization barrier
  */
 	.macro  esb
+#ifdef CONFIG_ARM64_RAS_EXTN
 	hint    #16
+#else
+	nop
+#endif
 	.endm
 
 /*
-- 
2.20.1

