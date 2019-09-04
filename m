Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54FC6A8F34
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388191AbfIDSC0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:02:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:42248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388738AbfIDSCX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:02:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4671622CEA;
        Wed,  4 Sep 2019 18:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620142;
        bh=Dtb2xlJUXaI7h1jTZ4aYV373tHKBE5AMbf5Ac85jxRs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nva/gb+kuXpOzuusUE1ui5RSfmjUpumLjT/VL6cMO71rGT5ffaftJWxYDJm7yUqq5
         2/GyfRoh8foUnpm7mKb/jkIRNZF0ytX8JeibUFdSweQ2vsH+Z+p3+Qi74ztNKSX5m8
         ajDRaBrkrBrMMH1zMWVUxg03HbeLksPk10CcMuII=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zenghui Yu <yuzenghui@huawei.com>,
        Heyi Guo <guoheyi@huawei.com>, Marc Zyngier <maz@kernel.org>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 80/83] KVM: arm/arm64: vgic: Fix potential deadlock when ap_list is long
Date:   Wed,  4 Sep 2019 19:54:12 +0200
Message-Id: <20190904175310.676208472@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175303.488266791@linuxfoundation.org>
References: <20190904175303.488266791@linuxfoundation.org>
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
index 6440b56ec90e2..1934dc8a2ce09 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -196,6 +196,13 @@ static int vgic_irq_cmp(void *priv, struct list_head *a, struct list_head *b)
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



