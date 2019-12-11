Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D86DA11AFA5
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:14:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731637AbfLKPOb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:14:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:39946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731214AbfLKPOb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:14:31 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2722D2465B;
        Wed, 11 Dec 2019 15:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077270;
        bh=5oMM/cvm6A3aBgzOUr6D1IuzknA4XLlLnZ3txtfxgbY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CFwZ8L7dJotIQWT0/MLpuLNb5NMTo/1D/zCs1m/0N6EqeCZ3GxEmLlYqJFpRujtDG
         Os77BcKVRFdg42vBP9AEhY581ybDnwUSYCw7zRBSnRrzGcc/jbbbAKb+h3Yy53V/6M
         InufLyTVOHmRxtEVQkeBBjl1Lf+xovQvxh9B1og0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zenghui Yu <yuzenghui@huawei.com>,
        Marc Zyngier <maz@kernel.org>,
        Eric Auger <eric.auger@redhat.com>
Subject: [PATCH 5.3 080/105] KVM: arm/arm64: vgic: Dont rely on the wrong pending table
Date:   Wed, 11 Dec 2019 16:06:09 +0100
Message-Id: <20191211150257.967838938@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150221.153659747@linuxfoundation.org>
References: <20191211150221.153659747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zenghui Yu <yuzenghui@huawei.com>

commit ca185b260951d3b55108c0b95e188682d8a507b7 upstream.

It's possible that two LPIs locate in the same "byte_offset" but target
two different vcpus, where their pending status are indicated by two
different pending tables.  In such a scenario, using last_byte_offset
optimization will lead KVM relying on the wrong pending table entry.
Let us use last_ptr instead, which can be treated as a byte index into
a pending table and also, can be vcpu specific.

Fixes: 280771252c1b ("KVM: arm64: vgic-v3: KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES")
Cc: stable@vger.kernel.org
Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Acked-by: Eric Auger <eric.auger@redhat.com>
Link: https://lore.kernel.org/r/20191029071919.177-4-yuzenghui@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 virt/kvm/arm/vgic/vgic-v3.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -363,8 +363,8 @@ retry:
 int vgic_v3_save_pending_tables(struct kvm *kvm)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
-	int last_byte_offset = -1;
 	struct vgic_irq *irq;
+	gpa_t last_ptr = ~(gpa_t)0;
 	int ret;
 	u8 val;
 
@@ -384,11 +384,11 @@ int vgic_v3_save_pending_tables(struct k
 		bit_nr = irq->intid % BITS_PER_BYTE;
 		ptr = pendbase + byte_offset;
 
-		if (byte_offset != last_byte_offset) {
+		if (ptr != last_ptr) {
 			ret = kvm_read_guest_lock(kvm, ptr, &val, 1);
 			if (ret)
 				return ret;
-			last_byte_offset = byte_offset;
+			last_ptr = ptr;
 		}
 
 		stored = val & (1U << bit_nr);


