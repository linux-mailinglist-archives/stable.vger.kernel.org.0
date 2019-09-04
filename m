Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A02B6A905D
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389137AbfIDSJO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:09:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:52386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389905AbfIDSJN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:09:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 368332087E;
        Wed,  4 Sep 2019 18:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620552;
        bh=lUGqCZxST7X7Ol2xlVxrEgPWhSrYJdo+luBd/UyI7PQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tu+Aq4TFiyHF0s9fxP1SDzYhH3RnDPDRCEXPHNJAPH3kVPQpRIdnZ7U/rqL1AQqIC
         MxJhYzvgMfmnTtoBdn06R5pmjyEcvmttzAioz+UGcyE4dPyl43u7XYWusEW/TMEL6Y
         H4bO8SNKM6Uwg0Ksw5oCyJIotixuB5jWcBUYhoAg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zenghui Yu <yuzenghui@huawei.com>,
        Heyi Guo <guoheyi@huawei.com>, Marc Zyngier <maz@kernel.org>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 85/93] KVM: arm/arm64: vgic: Fix potential deadlock when ap_list is long
Date:   Wed,  4 Sep 2019 19:54:27 +0200
Message-Id: <20190904175310.455546296@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175302.845828956@linuxfoundation.org>
References: <20190904175302.845828956@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit d4a8061a7c5f7c27a2dc002ee4cb89b3e6637e44 ]

If the ap_list is longer than 256 entries, merge_final() in list_sort()
will call the comparison callback with the same element twice, causing
a deadlock in vgic_irq_cmp().

Fix it by returning early when irqa == irqb.

Cc: stable@vger.kernel.org # 4.7+
Fixes: 8e4447457965 ("KVM: arm/arm64: vgic-new: Add IRQ sorting")
Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Heyi Guo <guoheyi@huawei.com>
[maz: massaged commit log and patch, added Fixes and Cc-stable]
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 virt/kvm/arm/vgic/vgic.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index 250cd72c95a52..4040a33cdc902 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -244,6 +244,13 @@ static int vgic_irq_cmp(void *priv, struct list_head *a, struct list_head *b)
 	bool penda, pendb;
 	int ret;
 
+	/*
+	 * list_sort may call this function with the same element when
+	 * the list is fairly long.
+	 */
+	if (unlikely(irqa == irqb))
+		return 0;
+
 	spin_lock(&irqa->irq_lock);
 	spin_lock_nested(&irqb->irq_lock, SINGLE_DEPTH_NESTING);
 
-- 
2.20.1



