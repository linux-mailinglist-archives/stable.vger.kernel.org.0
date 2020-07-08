Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC53F218CED
	for <lists+stable@lfdr.de>; Wed,  8 Jul 2020 18:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730093AbgGHQZ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jul 2020 12:25:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:48596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730325AbgGHQZ6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Jul 2020 12:25:58 -0400
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 695AF206C3;
        Wed,  8 Jul 2020 16:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594225557;
        bh=A63ZF9isoOHcAShHjxSg07aPaeYvVWE8/8tCJ3b/Ns8=;
        h=From:To:Cc:Subject:Date:From;
        b=C9c/I/sAa4L/WqgOPd2tZXYcVS9aLHG0xS6eCZv7VC1V7CIM9bYjHAxR2sGsr4mRW
         rJSRlECV+snc1WW5/PO0wt9dXbbvk6njwNcACV4nJJYYK8H2zRyUNdUaiHYJjqAX9E
         JwDEut0zdat/4rTCnamwuOWF5ld5tyfDL17Wk0rA=
From:   Will Deacon <will@kernel.org>
To:     linux-arm-kernel@lists.infradead.org
Cc:     kvmarm@lists.cs.columbia.edu, kernel-team@android.com,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>, stable@vger.kernel.org
Subject: [PATCH] KVM: arm64: Fix definition of PAGE_HYP_DEVICE
Date:   Wed,  8 Jul 2020 17:25:46 +0100
Message-Id: <20200708162546.26176-1-will@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

PAGE_HYP_DEVICE is intended to encode attribute bits for an EL2 stage-1
pte mapping a device. Unfortunately, it includes PROT_DEVICE_nGnRE which
encodes attributes for EL1 stage-1 mappings such as UXN and nG, which are
RES0 for EL2, and DBM which is meaningless as TCR_EL2.HD is not set.

Fix the definition of PAGE_HYP_DEVICE so that it doesn't set RES0 bits
at EL2.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Will Deacon <will@kernel.org>
---
Marc -- I'm happy to take this as a fix via arm64 with your Ack.
Please just let me know.

 arch/arm64/include/asm/pgtable-prot.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/pgtable-prot.h b/arch/arm64/include/asm/pgtable-prot.h
index 2e7e0f452301..4d867c6446c4 100644
--- a/arch/arm64/include/asm/pgtable-prot.h
+++ b/arch/arm64/include/asm/pgtable-prot.h
@@ -67,7 +67,7 @@ extern bool arm64_use_ng_mappings;
 #define PAGE_HYP		__pgprot(_HYP_PAGE_DEFAULT | PTE_HYP | PTE_HYP_XN)
 #define PAGE_HYP_EXEC		__pgprot(_HYP_PAGE_DEFAULT | PTE_HYP | PTE_RDONLY)
 #define PAGE_HYP_RO		__pgprot(_HYP_PAGE_DEFAULT | PTE_HYP | PTE_RDONLY | PTE_HYP_XN)
-#define PAGE_HYP_DEVICE		__pgprot(PROT_DEVICE_nGnRE | PTE_HYP)
+#define PAGE_HYP_DEVICE		__pgprot(_PROT_DEFAULT | PTE_ATTRINDX(MT_DEVICE_nGnRE) | PTE_HYP | PTE_HYP_XN)
 
 #define PAGE_S2_MEMATTR(attr)						\
 	({								\
-- 
2.27.0.383.g050319c2ae-goog

