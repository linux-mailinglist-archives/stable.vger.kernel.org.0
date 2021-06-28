Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9786D3B62D2
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236534AbhF1Oth (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:49:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:51824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235741AbhF1Opg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:45:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D7CB61CD2;
        Mon, 28 Jun 2021 14:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890854;
        bh=3nNXwGY6/CtzdLpo740JpzmycN4ggCl0iGIXwQXwbFI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FH4jCLq8jeGECoWWyI/cYUCoCBhNmd4sBKkIKwkv/YX2hIYMdtLCyyS2Vv1wAgKfV
         jq/rPNtOPUf4YTDl7Yzxb745LScVpPQLIIaYFAvX8AhNRf260xoOdIJJzymndZOWKw
         AZegUqR2TMvVYIqSadguvQNsNo2MK7qiw/oZv2VgXCJyCf7B+HE9oWIKZKFaV0D2Sn
         Ayqk1ERSxGIOgMv4YFYkdIc94VuwLuFDPnMtfCQz29D2dRK9kkHkYvKZQyHonrs8y+
         Ek+gxwvsH19+rrRFk05wRheL70gocSi3z5+kAq1iz4SEnMQgOSOo5zubbzRiMU2Rx4
         c4hwTF/y5NpQQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Auger <eric.auger@redhat.com>, Stable@vger.kernel.org,
        Gavin Shan <gshan@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.19 077/109] KVM: arm/arm64: Fix KVM_VGIC_V3_ADDR_TYPE_REDIST read
Date:   Mon, 28 Jun 2021 10:32:33 -0400
Message-Id: <20210628143305.32978-78-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143305.32978-1-sashal@kernel.org>
References: <20210628143305.32978-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.196-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.196-rc1
X-KernelTest-Deadline: 2021-06-30T14:32+00:00
X-stable: review
X-Patchwork-Hint: Ignore
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
 virt/kvm/arm/vgic/vgic-kvm-device.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
index 6ada2432e37c..71d92096776e 100644
--- a/virt/kvm/arm/vgic/vgic-kvm-device.c
+++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
@@ -95,8 +95,8 @@ int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write)
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
-- 
2.30.2

