Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0838E1218D1
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:46:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728173AbfLPR4M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 12:56:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:54072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728167AbfLPR4L (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 12:56:11 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC09721582;
        Mon, 16 Dec 2019 17:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576518971;
        bh=ve+3iNDqCTuyOdRt5L/xzqgglC4MCykNyOpj+ObyHM8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nBb8zlH/izUzX1Zf/6WMDa1wqfqvhGAbJ8GSgwzbYaZE0LvhJAbixIF8uMmDCY0Ht
         Iz7wSSMY+vj9KVbCWJva7g0KWcEIb4LyxNz7c2/8+BfNpVB4a71YeQOOvYkj1rA8q5
         yRAqqi0tgnWrEfsAzE02vI4ZBblXqXGfGBKeV4Zo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zenghui Yu <yuzenghui@huawei.com>,
        Marc Zyngier <maz@kernel.org>,
        Eric Auger <eric.auger@redhat.com>
Subject: [PATCH 4.14 140/267] KVM: arm/arm64: vgic: Dont rely on the wrong pending table
Date:   Mon, 16 Dec 2019 18:47:46 +0100
Message-Id: <20191216174910.154735152@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174848.701533383@linuxfoundation.org>
References: <20191216174848.701533383@linuxfoundation.org>
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
@@ -331,8 +331,8 @@ retry:
 int vgic_v3_save_pending_tables(struct kvm *kvm)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
-	int last_byte_offset = -1;
 	struct vgic_irq *irq;
+	gpa_t last_ptr = ~(gpa_t)0;
 	int ret;
 	u8 val;
 
@@ -352,11 +352,11 @@ int vgic_v3_save_pending_tables(struct k
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


