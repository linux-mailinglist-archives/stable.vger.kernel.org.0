Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEC8C3F665D
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238413AbhHXRXG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:23:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:59930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239757AbhHXRVF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:21:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 452E461425;
        Tue, 24 Aug 2021 17:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824600;
        bh=0sUSQoid7+5waY/u+6a/VasJYT6MGBquoB32XuFkT5g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QFHfGN0Wi6i60A5nSnfXVUKpvTXNYIB1C+MISJSYYjR3uFd67WBe+tzSecEnTZvo1
         HE3M/qGYyJBNmv2AZP1KVmnH8goCsIhssY7tYGTNFm3u4gbW2HPFSqq1i2dUv9NX2D
         gU3y9EIxhC4PhLDauCBhxBG2F6NGrMw3qI0roz9g9ANU15Nm+XJRyoeDByAvNd8+IF
         Oln65ulDNyUt8RlaLOM6nzUmVBjYLbkYiQ42Wvf3WVRbHadhMLbYQDsJVhX1wVad2H
         vI7wZKfcLAD8hMgirOYrkPdD1vechnh2xHJQefORVBjMKjwDrAEgaDFWYTWmA1ssHE
         h9hN1kVCwb5ng==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bixuan Cui <cuibixuan@huawei.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.19 30/84] genirq/msi: Ensure deactivation on teardown
Date:   Tue, 24 Aug 2021 13:01:56 -0400
Message-Id: <20210824170250.710392-31-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170250.710392-1-sashal@kernel.org>
References: <20210824170250.710392-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.205-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.205-rc1
X-KernelTest-Deadline: 2021-08-26T17:02+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bixuan Cui <cuibixuan@huawei.com>

commit dbbc93576e03fbe24b365fab0e901eb442237a8a upstream.

msi_domain_alloc_irqs() invokes irq_domain_activate_irq(), but
msi_domain_free_irqs() does not enforce deactivation before tearing down
the interrupts.

This happens when PCI/MSI interrupts are set up and never used before being
torn down again, e.g. in error handling pathes. The only place which cleans
that up is the error handling path in msi_domain_alloc_irqs().

Move the cleanup from msi_domain_alloc_irqs() into msi_domain_free_irqs()
to cure that.

Fixes: f3b0946d629c ("genirq/msi: Make sure PCI MSIs are activated early")
Signed-off-by: Bixuan Cui <cuibixuan@huawei.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210518033117.78104-1-cuibixuan@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/irq/msi.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/kernel/irq/msi.c b/kernel/irq/msi.c
index 604974f2afb1..88269dd5a8ca 100644
--- a/kernel/irq/msi.c
+++ b/kernel/irq/msi.c
@@ -477,11 +477,6 @@ skip_activate:
 	return 0;
 
 cleanup:
-	for_each_msi_vector(desc, i, dev) {
-		irq_data = irq_domain_get_irq_data(domain, i);
-		if (irqd_is_activated(irq_data))
-			irq_domain_deactivate_irq(irq_data);
-	}
 	msi_domain_free_irqs(domain, dev);
 	return ret;
 }
@@ -494,7 +489,15 @@ cleanup:
  */
 void msi_domain_free_irqs(struct irq_domain *domain, struct device *dev)
 {
+	struct irq_data *irq_data;
 	struct msi_desc *desc;
+	int i;
+
+	for_each_msi_vector(desc, i, dev) {
+		irq_data = irq_domain_get_irq_data(domain, i);
+		if (irqd_is_activated(irq_data))
+			irq_domain_deactivate_irq(irq_data);
+	}
 
 	for_each_msi_entry(desc, dev) {
 		/*
-- 
2.30.2

