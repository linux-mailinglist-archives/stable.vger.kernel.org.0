Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9527D68EEA
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 16:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388606AbfGOOKn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 10:10:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:40862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388669AbfGOOKm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 10:10:42 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72E1B206B8;
        Mon, 15 Jul 2019 14:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563199841;
        bh=Aa20z2hwguTgvagup2iWVwNzGjHe3N1ptoZOEn/D3nE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u6G3VUywn3FXENppq/8p4kRqs/auIIwkjX25Mxawbp9Wv88YUomG9yLa44SVueUEm
         7Ot70YWJiLXZJtazdhthlvzEPdrytFcTzhXyExJ0uJ+4gwyyLQ/CSqKPtmLm1zQ9MO
         EuvwJkEupQLOQf9mZrcNP5AFR8p+S6mYgPXpmDVg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Julien Thierry <julien.thierry@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.1 123/219] arm64: Do not enable IRQs for ct_user_exit
Date:   Mon, 15 Jul 2019 10:02:04 -0400
Message-Id: <20190715140341.6443-123-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715140341.6443-1-sashal@kernel.org>
References: <20190715140341.6443-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julien Thierry <julien.thierry@arm.com>

[ Upstream commit 9034f6251572a4744597c51dea5ab73a55f2b938 ]

For el0_dbg and el0_error, DAIF bits get explicitly cleared before
calling ct_user_exit.

When context tracking is disabled, DAIF gets set (almost) immediately
after. When context tracking is enabled, among the first things done
is disabling IRQs.

What is actually needed is:
- PSR.D = 0 so the system can be debugged (should be already the case)
- PSR.A = 0 so async error can be handled during context tracking

Do not clear PSR.I in those two locations.

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: James Morse <james.morse@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Julien Thierry <julien.thierry@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/entry.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index c50a7a75f2e0..6a3890393963 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -855,7 +855,7 @@ el0_dbg:
 	mov	x1, x25
 	mov	x2, sp
 	bl	do_debug_exception
-	enable_daif
+	enable_da_f
 	ct_user_exit
 	b	ret_to_user
 el0_inv:
@@ -907,7 +907,7 @@ el0_error_naked:
 	enable_dbg
 	mov	x0, sp
 	bl	do_serror
-	enable_daif
+	enable_da_f
 	ct_user_exit
 	b	ret_to_user
 ENDPROC(el0_error)
-- 
2.20.1

