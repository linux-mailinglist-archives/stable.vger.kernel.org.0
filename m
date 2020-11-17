Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E85C2B6567
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:55:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730834AbgKQNzL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:55:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:59260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730353AbgKQNYP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:24:15 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5628F2463D;
        Tue, 17 Nov 2020 13:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619454;
        bh=48yqQFvySyRUMvAYdzKQQop6x6PWM0Pcl/6wfYB8kaU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kGJOGl9PMDAro07veUc8Yh1OS9Rft7ZqEtEReAolB1PXaffaoFSwZTBeapSwSby5M
         UTxMovZmVz0J94UP1dfAuym99VKT9eII7s7LTs3CjuEb09gdAUyJtfL1weFXdYWl10
         O8CVxn1iJuMSejpvPfzwJgYT8QavXaDkjwZnDA90=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Santosh Shukla <sashukla@nvidia.com>,
        Gavin Shan <gshan@redhat.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 004/151] KVM: arm64: Force PTE mapping on fault resulting in a device mapping
Date:   Tue, 17 Nov 2020 14:03:54 +0100
Message-Id: <20201117122121.604510537@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122121.381905960@linuxfoundation.org>
References: <20201117122121.381905960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Santosh Shukla <sashukla@nvidia.com>

[ Upstream commit 91a2c34b7d6fadc9c5d9433c620ea4c32ee7cae8 ]

VFIO allows a device driver to resolve a fault by mapping a MMIO
range. This can be subsequently result in user_mem_abort() to
try and compute a huge mapping based on the MMIO pfn, which is
a sure recipe for things to go wrong.

Instead, force a PTE mapping when the pfn faulted in has a device
mapping.

Fixes: 6d674e28f642 ("KVM: arm/arm64: Properly handle faulting of device mappings")
Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Santosh Shukla <sashukla@nvidia.com>
[maz: rewritten commit message]
Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/1603711447-11998-2-git-send-email-sashukla@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 virt/kvm/arm/mmu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 8700402f3000d..03a586ab6d27b 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1756,6 +1756,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (kvm_is_device_pfn(pfn)) {
 		mem_type = PAGE_S2_DEVICE;
 		flags |= KVM_S2PTE_FLAG_IS_IOMAP;
+		force_pte = true;
 	} else if (logging_active) {
 		/*
 		 * Faults on pages in a memslot with logging enabled
-- 
2.27.0



