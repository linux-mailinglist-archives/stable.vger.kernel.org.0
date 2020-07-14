Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88A6F21FCE8
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 21:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730282AbgGNTMQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 15:12:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:42230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729696AbgGNSrO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:47:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64E8C22AAE;
        Tue, 14 Jul 2020 18:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594752434;
        bh=eybEVYZ0H2G8SQhFRuRRNr1i0BUSzfEQItUdB7NkyYo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xysHCSUv1M3HPKvzGp2hshq7Toks8SczF0DgUYnaq8ST9yXmiLGRRlxXWG+89eacy
         BpIjHGkkD3hP+ja/tp/kFp8aums04bYEHQExyoAZgw6whtFw5i7IbUESjBQrI1SI2v
         Z+qXYdxg1hgw4cUcJNCKZZWqo9RmOFmvS/1NwT78=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 4.19 41/58] KVM: arm64: Fix definition of PAGE_HYP_DEVICE
Date:   Tue, 14 Jul 2020 20:44:14 +0200
Message-Id: <20200714184058.162642865@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184056.149119318@linuxfoundation.org>
References: <20200714184056.149119318@linuxfoundation.org>
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
 
 #define PAGE_S2_MEMATTR(attr)						\
 	({								\


