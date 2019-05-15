Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75E801EE92
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731563AbfEOLXL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:23:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:33490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731326AbfEOLXL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:23:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 763F7206BF;
        Wed, 15 May 2019 11:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919390;
        bh=jkLFPE0Btsk4k/1uPATuEs2Vl549eC/EjkT7x9ITssY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EuCxPZoMJ2NOlqz2V365ZsttsprpBH4UvWpcS6vVyJO1sR7xW1arMKPiNafwvBA8A
         c04yMoEE/2/7rFbBtGdArHJ/pMeMkzxPPn0q0A3NC/V5CIHNiom7zqV64uu5nkaLZi
         nuwAICe6iLEA0WFl5iv7Fux7mnfKIlWKCO1pbjQI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tigran Tadevosyan <tigran.tadevosyan@arm.com>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 058/113] ARM: 8856/1: NOMMU: Fix CCR register faulty initialization when MPU is disabled
Date:   Wed, 15 May 2019 12:55:49 +0200
Message-Id: <20190515090658.008272513@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090652.640988966@linuxfoundation.org>
References: <20190515090652.640988966@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index ec29de2500764..cab89479d15ef 100644
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



