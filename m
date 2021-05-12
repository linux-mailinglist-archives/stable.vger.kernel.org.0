Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB1637CEF6
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345233AbhELRH5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:07:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:42824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244806AbhELQvL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:51:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 866A561C91;
        Wed, 12 May 2021 16:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620836372;
        bh=CGfC9W18/Jox6ympwiH29ypYoRjyQwKxo3cJZuWlpA4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xvpujQE/UQuGxhCYJEZ0FV0spShMso5kz76+60gjW+qO7Q7lMRriThhL0l75434kd
         ko+SqwkNzF4e158mMp7DciQ1G0Oj70jAp1Xca8yhW4Ibw8TBmDRTGAmIb6iQna91Jo
         tGMu4ORUyoiqlVaOwgafBwtJb2+j13gqCDXbLevU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Auger <eric.auger@redhat.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.12 127/677] KVM: arm64: Fix KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION read
Date:   Wed, 12 May 2021 16:42:53 +0200
Message-Id: <20210512144841.434120890@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Auger <eric.auger@redhat.com>

commit 53b16dd6ba5cf64ed147ac3523ec34651d553cb0 upstream.

The doc says:
"The characteristics of a specific redistributor region can
 be read by presetting the index field in the attr data.
 Only valid for KVM_DEV_TYPE_ARM_VGIC_V3"

Unfortunately the existing code fails to read the input attr data.

Fixes: 04c110932225 ("KVM: arm/arm64: Implement KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION")
Cc: stable@vger.kernel.org#v4.17+
Signed-off-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20210405163941.510258-3-eric.auger@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/vgic/vgic-kvm-device.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -226,6 +226,9 @@ static int vgic_get_common_attr(struct k
 		u64 addr;
 		unsigned long type = (unsigned long)attr->attr;
 
+		if (copy_from_user(&addr, uaddr, sizeof(addr)))
+			return -EFAULT;
+
 		r = kvm_vgic_addr(dev->kvm, type, &addr, false);
 		if (r)
 			return (r == -ENODEV) ? -ENXIO : r;


