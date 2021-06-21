Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F36143AE8EA
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 14:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbhFUMVE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 08:21:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30393 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229710AbhFUMVE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Jun 2021 08:21:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624277930;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=uZntDKbSLD8RTnNrN+qTlHrQxiWvindPPJsg1DA4mrw=;
        b=g0VeXiOecE6grkVi7rYD5HpQxMT9J4PG5PgzW5ZcXI13kkJjKpJRcYF5ykkvnDKVwXwEcx
        XPp+W66EqRLAyfh/h/nOAs0PBBJcUA9U1g5OWHcKU/HAWgDtjOsc6c7h34xlGBJhZq4yb+
        yvGxlxluVYlHEkxCeiNvGXk0YYYO8nM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-157-HHOQSb8_PvyMpJYi2nIVVw-1; Mon, 21 Jun 2021 08:18:48 -0400
X-MC-Unique: HHOQSb8_PvyMpJYi2nIVVw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 734431084F56;
        Mon, 21 Jun 2021 12:18:47 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-112-27.ams2.redhat.com [10.36.112.27])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CF7295D9F0;
        Mon, 21 Jun 2021 12:18:42 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        stable@vger.kernel.org, maz@kernel.org,
        linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Subject: [PATCH] KVM: arm/arm64: Fix KVM_VGIC_V3_ADDR_TYPE_REDIST read
Date:   Mon, 21 Jun 2021 14:18:39 +0200
Message-Id: <20210621121839.792649-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When reading the base address of the a REDIST region
through KVM_VGIC_V3_ADDR_TYPE_REDIST we expect the
redistributor region list to be populated with a single
element.

However list_first_entry() expects the list to be non empty.
Instead we should use list_first_entry_or_null which effectively
returns NULL if the list is empty.

Fixes: dbd9733ab674 ("KVM: arm/arm64: Replace the single rdist region by a list")
Cc: <Stable@vger.kernel.org> # v4.19
Signed-off-by: Eric Auger <eric.auger@redhat.com>
Reported-by: Gavin Shan <gshan@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20210412150034.29185-1-eric.auger@redhat.com
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
2.26.3

