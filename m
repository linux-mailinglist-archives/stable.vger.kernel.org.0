Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D940115F152
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 19:03:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730725AbgBNSBg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 13:01:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:37636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731830AbgBNP4I (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:56:08 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA39124685;
        Fri, 14 Feb 2020 15:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695767;
        bh=FLZzOL6P9wTGzHQT/Jx3T0luRs0YyHB9UZhwVaCmjqM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qohPAfKSxy/jbnHoxt93Tm4CpCvnLUxvGFo0kjJoGqvSpXyPEz1xBkrlR+tT1jbOz
         dR0uPbaIbdOpL9dwDw9/U0frfK+3WjXxuZkj7mvViJLhkHPOa2x6xx5cgc1jU7EYWj
         ykqS7Wzhpn9UJfjZrKwl8jsS4YR0qMC3/p0Lh/uQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Brown <broonie@kernel.org>, Will Deacon <will@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.5 334/542] arm64: kernel: Correct annotation of end of el0_sync
Date:   Fri, 14 Feb 2020 10:45:26 -0500
Message-Id: <20200214154854.6746-334-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 73d6890fe8ff40e357039b626537ac82d8782aeb ]

Commit 582f95835a8fc812c ("arm64: entry: convert el0_sync to C") caused
the ENDPROC() annotating the end of el0_sync to be placed after the code
for el0_sync_compat. This replaced the previous annotation where it was
located after all the cases that are now converted to C, including after
the currently unannotated el0_irq_compat and el0_error_compat. Move the
annotation to the end of the function and add separate annotations for
the _compat ones.

Fixes: 582f95835a8fc812c (arm64: entry: convert el0_sync to C)
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/entry.S | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 7c6a0a41676f8..d54d165b286a3 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -653,6 +653,7 @@ el0_sync:
 	mov	x0, sp
 	bl	el0_sync_handler
 	b	ret_to_user
+ENDPROC(el0_sync)
 
 #ifdef CONFIG_COMPAT
 	.align	6
@@ -661,16 +662,18 @@ el0_sync_compat:
 	mov	x0, sp
 	bl	el0_sync_compat_handler
 	b	ret_to_user
-ENDPROC(el0_sync)
+ENDPROC(el0_sync_compat)
 
 	.align	6
 el0_irq_compat:
 	kernel_entry 0, 32
 	b	el0_irq_naked
+ENDPROC(el0_irq_compat)
 
 el0_error_compat:
 	kernel_entry 0, 32
 	b	el0_error_naked
+ENDPROC(el0_error_compat)
 #endif
 
 	.align	6
-- 
2.20.1

