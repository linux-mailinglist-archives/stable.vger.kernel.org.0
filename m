Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 519E3226B73
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730048AbgGTPqO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:46:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:40832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730624AbgGTPqN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:46:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1B3A206E9;
        Mon, 20 Jul 2020 15:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595259972;
        bh=HiOwwL2PD7FMOr0KZzLMBCmQbQEHfWXdnGdrVeZt+Ic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eLIjisXL5utLz7idy2NoB6MpPZlx9eBU0ZI3q2mZpY+0frl+9/iIc6jIxwxhc+W1M
         nfS/t+GvLkwrRVDhyoRiXrV3s+GRV4v5h/7MaqYjnN2FzRIjH6r/cFigjvVxvwbuIK
         M05KwD4nEWLjIq4rvhAWE8JbXSPmESvEAwIRwQFc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 4.14 029/125] KVM: arm64: Fix definition of PAGE_HYP_DEVICE
Date:   Mon, 20 Jul 2020 17:36:08 +0200
Message-Id: <20200720152804.386719090@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152802.929969555@linuxfoundation.org>
References: <20200720152802.929969555@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will@kernel.org>

commit 68cf617309b5f6f3a651165f49f20af1494753ae upstream.

PAGE_HYP_DEVICE is intended to encode attribute bits for an EL2 stage-1
pte mapping a device. Unfortunately, it includes PROT_DEVICE_nGnRE which
encodes attributes for EL1 stage-1 mappings such as UXN and nG, which are
RES0 for EL2, and DBM which is meaningless as TCR_EL2.HD is not set.

Fix the definition of PAGE_HYP_DEVICE so that it doesn't set RES0 bits
at EL2.

Acked-by: Marc Zyngier <maz@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200708162546.26176-1-will@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/include/asm/pgtable-prot.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/include/asm/pgtable-prot.h
+++ b/arch/arm64/include/asm/pgtable-prot.h
@@ -65,7 +65,7 @@
 #define PAGE_HYP		__pgprot(_HYP_PAGE_DEFAULT | PTE_HYP | PTE_HYP_XN)
 #define PAGE_HYP_EXEC		__pgprot(_HYP_PAGE_DEFAULT | PTE_HYP | PTE_RDONLY)
 #define PAGE_HYP_RO		__pgprot(_HYP_PAGE_DEFAULT | PTE_HYP | PTE_RDONLY | PTE_HYP_XN)
-#define PAGE_HYP_DEVICE		__pgprot(PROT_DEVICE_nGnRE | PTE_HYP)
+#define PAGE_HYP_DEVICE		__pgprot(_PROT_DEFAULT | PTE_ATTRINDX(MT_DEVICE_nGnRE) | PTE_HYP | PTE_HYP_XN)
 
 #define PAGE_S2			__pgprot(_PROT_DEFAULT | PTE_S2_MEMATTR(MT_S2_NORMAL) | PTE_S2_RDONLY)
 #define PAGE_S2_DEVICE		__pgprot(_PROT_DEFAULT | PTE_S2_MEMATTR(MT_S2_DEVICE_nGnRE) | PTE_S2_RDONLY | PTE_UXN)


