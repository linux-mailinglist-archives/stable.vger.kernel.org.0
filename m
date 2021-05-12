Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58C7737C7BD
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236092AbhELQCU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:02:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:38790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238122AbhELP5X (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:57:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D9B661CBF;
        Wed, 12 May 2021 15:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833422;
        bh=ggCQpBeM2JRKY7bpvBaPrhmFbtbPgeDzF/fRmH+Asxw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wBIU4E7sprYO/Q7sToRAPoRuyl9SHjizDJMGFlwAqa4TeDPo9rFQXZCc94UDz9omD
         O17mxUBNot9jGByAw5NVZWfp2TEwtWvernblQv3/nAne+drbnIM9tOGYE94CK89/YX
         HPhhSzHGIfoWThnu8PAiXOYMVs7GfzEXitNsJ3Kk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Auger <eric.auger@redhat.com>,
        Gavin Shan <gshan@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Stable@vger.kernel.org
Subject: [PATCH 5.11 108/601] KVM: arm/arm64: Fix KVM_VGIC_V3_ADDR_TYPE_REDIST read
Date:   Wed, 12 May 2021 16:43:05 +0200
Message-Id: <20210512144831.396232099@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Auger <eric.auger@redhat.com>

commit 94ac0835391efc1a30feda6fc908913ec012951e upstream.

When reading the base address of the a REDIST region
through KVM_VGIC_V3_ADDR_TYPE_REDIST we expect the
redistributor region list to be populated with a single
element.

However list_first_entry() expects the list to be non empty.
Instead we should use list_first_entry_or_null which effectively
returns NULL if the list is empty.

Fixes: dbd9733ab674 ("KVM: arm/arm64: Replace the single rdist region by a list")
Cc: <Stable@vger.kernel.org> # v4.18+
Signed-off-by: Eric Auger <eric.auger@redhat.com>
Reported-by: Gavin Shan <gshan@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20210412150034.29185-1-eric.auger@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/vgic/vgic-kvm-device.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -87,8 +87,8 @@ int kvm_vgic_addr(struct kvm *kvm, unsig
 			r = vgic_v3_set_redist_base(kvm, 0, *addr, 0);
 			goto out;
 		}
-		rdreg = list_first_entry(&vgic->rd_regions,
-					 struct vgic_redist_region, list);
+		rdreg = list_first_entry_or_null(&vgic->rd_regions,
+						 struct vgic_redist_region, list);
 		if (!rdreg)
 			addr_ptr = &undef_value;
 		else


