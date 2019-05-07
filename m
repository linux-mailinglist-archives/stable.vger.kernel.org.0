Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC6C15C53
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 08:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727777AbfEGFfV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 01:35:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:55316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727760AbfEGFfQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:35:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1103521479;
        Tue,  7 May 2019 05:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207315;
        bh=CqM25Liyll1vUZ+oKuFskUUke6oAbdea2XABoh0OlYE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XWk22WJD4Bn64dhVWKXO7glZYVd4lqIym4OH7iKKPl70LwOEDOlhdf6Dex3sJMGOu
         eu6bjUo6UUxKrgOL7BxGNFuErcXlCYdDX8/RNsI/I/5dvH6A3cXsxtTnv2jlM7ccsO
         6OP9sO6+YsrF9e5s2bMnqYp0kWqzHM7YHvtQabZY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tigran Tadevosyan <tigran.tadevosyan@arm.com>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.0 81/99] ARM: 8856/1: NOMMU: Fix CCR register faulty initialization when MPU is disabled
Date:   Tue,  7 May 2019 01:32:15 -0400
Message-Id: <20190507053235.29900-81-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053235.29900-1-sashal@kernel.org>
References: <20190507053235.29900-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tigran Tadevosyan <tigran.tadevosyan@arm.com>

[ Upstream commit c3143967807adb1357c36b68a7563fc0c4e1f615 ]

When CONFIG_ARM_MPU is not defined, the base address of v7M SCB register
is not initialized with correct value. This prevents enabling I/D caches
when the L1 cache poilcy is applied in kernel.

Fixes: 3c24121039c9da14692eb48f6e39565b28c0f3cf ("ARM: 8756/1: NOMMU: Postpone MPU activation till __after_proc_init")
Signed-off-by: Tigran Tadevosyan <tigran.tadevosyan@arm.com>
Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/kernel/head-nommu.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/kernel/head-nommu.S b/arch/arm/kernel/head-nommu.S
index ec29de250076..cab89479d15e 100644
--- a/arch/arm/kernel/head-nommu.S
+++ b/arch/arm/kernel/head-nommu.S
@@ -133,9 +133,9 @@ __secondary_data:
  */
 	.text
 __after_proc_init:
-#ifdef CONFIG_ARM_MPU
 M_CLASS(movw	r12, #:lower16:BASEADDR_V7M_SCB)
 M_CLASS(movt	r12, #:upper16:BASEADDR_V7M_SCB)
+#ifdef CONFIG_ARM_MPU
 M_CLASS(ldr	r3, [r12, 0x50])
 AR_CLASS(mrc	p15, 0, r3, c0, c1, 4)          @ Read ID_MMFR0
 	and	r3, r3, #(MMFR0_PMSA)           @ PMSA field
-- 
2.20.1

