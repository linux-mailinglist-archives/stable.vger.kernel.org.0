Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADC3433B5BD
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:56:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231511AbhCONzR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:55:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:58660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231224AbhCONyo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:54:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E946964F33;
        Mon, 15 Mar 2021 13:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816483;
        bh=RQtF6aHqWz8EBVznGslYSQ6SzT6WihpDLg7h8pkNDpI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xf38cCiPJO2RHcNI0/ipWZnFFCbRKAMFLOZIk20pRZtwPe8OOW/Hp6sYScq1FTM0V
         rZ6ogHtbEd8jCcpx9y2J6RMPQAMM1kgTv9ItwM7greiGPsdByNDnccPtR86bts1cvH
         CcCKwWz2eXlX9QXq+XDZne+cG8PymOejY4m2XOjE=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Auger <eric.auger@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        Andrew Jones <drjones@redhat.com>
Subject: [PATCH 4.4 70/75] KVM: arm64: Fix exclusive limit for IPA size
Date:   Mon, 15 Mar 2021 14:52:24 +0100
Message-Id: <20210315135210.547754615@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135208.252034256@linuxfoundation.org>
References: <20210315135208.252034256@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Marc Zyngier <maz@kernel.org>

Commit 262b003d059c6671601a19057e9fe1a5e7f23722 upstream.

When registering a memslot, we check the size and location of that
memslot against the IPA size to ensure that we can provide guest
access to the whole of the memory.

Unfortunately, this check rejects memslot that end-up at the exact
limit of the addressing capability for a given IPA size. For example,
it refuses the creation of a 2GB memslot at 0x8000000 with a 32bit
IPA space.

Fix it by relaxing the check to accept a memslot reaching the
limit of the IPA space.

Fixes: c3058d5da222 ("arm/arm64: KVM: Ensure memslots are within KVM_PHYS_SIZE")
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org # 4.4, 4.9
Reviewed-by: Andrew Jones <drjones@redhat.com>
Link: https://lore.kernel.org/r/20210311100016.3830038-3-maz@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/kvm/mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -1789,7 +1789,7 @@ int kvm_arch_prepare_memory_region(struc
 	 * Prevent userspace from creating a memory region outside of the IPA
 	 * space addressable by the KVM guest IPA space.
 	 */
-	if (memslot->base_gfn + memslot->npages >=
+	if (memslot->base_gfn + memslot->npages >
 	    (KVM_PHYS_SIZE >> PAGE_SHIFT))
 		return -EFAULT;
 


