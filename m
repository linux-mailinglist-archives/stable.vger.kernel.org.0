Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FFE633B9D6
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:09:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231181AbhCOOGw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:06:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:36764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233362AbhCOOBg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:01:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E0D6264FA6;
        Mon, 15 Mar 2021 14:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816864;
        bh=ZSDDJqmx1ezviwIfBelKE+p28/Gdv9yUJNdgvYPx34A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rAVD+Fx5uhitcip78PmKLvZVbNZhZk4sSDomTQOR/xX0ha+4kIire3Vj1glyOBb+d
         kkYMSu/Hr813F+XwOQOd7jm2opcfi9WOnhoJfYjSxHAH8fhAFFVLJlSbRo+ghNYgur
         /Kb9USZN6iF7OTZD9jH8xPUpGni9O8S6pjTYLoeo=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Auger <eric.auger@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        Andrew Jones <drjones@redhat.com>
Subject: [PATCH 4.19 117/120] KVM: arm64: Fix exclusive limit for IPA size
Date:   Mon, 15 Mar 2021 14:57:48 +0100
Message-Id: <20210315135723.811477229@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135720.002213995@linuxfoundation.org>
References: <20210315135720.002213995@linuxfoundation.org>
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
Cc: stable@vger.kernel.org # 4.4, 4.9, 4.14, 4.19
Reviewed-by: Andrew Jones <drjones@redhat.com>
Link: https://lore.kernel.org/r/20210311100016.3830038-3-maz@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 virt/kvm/arm/mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -2080,7 +2080,7 @@ int kvm_arch_prepare_memory_region(struc
 	 * Prevent userspace from creating a memory region outside of the IPA
 	 * space addressable by the KVM guest IPA space.
 	 */
-	if (memslot->base_gfn + memslot->npages >=
+	if (memslot->base_gfn + memslot->npages >
 	    (KVM_PHYS_SIZE >> PAGE_SHIFT))
 		return -EFAULT;
 


