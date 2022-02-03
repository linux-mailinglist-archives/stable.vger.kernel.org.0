Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7564A8E51
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:37:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355099AbiBCUhG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:37:06 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:36244 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355160AbiBCUfE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:35:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AEA89B8354B;
        Thu,  3 Feb 2022 20:35:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ED4DC340E8;
        Thu,  3 Feb 2022 20:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920501;
        bh=HPNkYZ6HbCou+CsnDqdrKXygkWm/hAwXXOrhmqblAW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q/3n+T5frMNhAba4GHVUdoMKQwQTx+fmYqxfTiUen4uwm94xqIxG8PKu5AZKwAgUJ
         RyS1oJoxr8Y2gmFd3PCQisp8Icj357FrWQmL82PGB0B04IBtQIqcNphc3d01JXtYCe
         niAT4AAZZUFzu8pW3fgLmdwvm/49JcYr+3Pfpp7xOSMAaUPknaousE0O5hSYkS52OQ
         x9e4yvDbNrUszraF12UgENP+MFjfc9g2yXysR/dO0Prqsla7eay0ABJbkqLC4oyZZI
         bjV8vFlM4n+Gnfcthj09KmtxdTW7Neww4a5pqrRhFHHEmtuIRHYLg/A2fAxioGuRhB
         sgKpYsN8rr7HQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andi Kleen <ak@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>, mingo@redhat.com,
        acme@kernel.org, tglx@linutronix.de, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org,
        linux-perf-users@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 09/25] x86/perf: Avoid warning for Arch LBR without XSAVE
Date:   Thu,  3 Feb 2022 15:34:30 -0500
Message-Id: <20220203203447.3570-9-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203203447.3570-1-sashal@kernel.org>
References: <20220203203447.3570-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

[ Upstream commit 8c16dc047b5dd8f7b3bf4584fa75733ea0dde7dc ]

Some hypervisors support Arch LBR, but without the LBR XSAVE support.
The current Arch LBR init code prints a warning when the xsave size (0) is
unexpected. Avoid printing the warning for the "no LBR XSAVE" case.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20211215204029.150686-1-ak@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/lbr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/events/intel/lbr.c b/arch/x86/events/intel/lbr.c
index 9c1a013d56822..bd8516e6c353c 100644
--- a/arch/x86/events/intel/lbr.c
+++ b/arch/x86/events/intel/lbr.c
@@ -1734,6 +1734,9 @@ static bool is_arch_lbr_xsave_available(void)
 	 * Check the LBR state with the corresponding software structure.
 	 * Disable LBR XSAVES support if the size doesn't match.
 	 */
+	if (xfeature_size(XFEATURE_LBR) == 0)
+		return false;
+
 	if (WARN_ON(xfeature_size(XFEATURE_LBR) != get_lbr_state_size()))
 		return false;
 
-- 
2.34.1

