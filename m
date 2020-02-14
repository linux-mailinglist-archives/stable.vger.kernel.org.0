Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A305115DBDD
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 16:51:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730621AbgBNPuz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 10:50:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:55462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730639AbgBNPuz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:50:55 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4AEB2467D;
        Fri, 14 Feb 2020 15:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695454;
        bh=n2JVUqLD6dZ9KQSNGJH4Pva7c4CMFDtj28KH4mVguYo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kema/uYnuXbilJWXmFADWREglNiK5waIyIp3neihfgS+Paq57qYjA0eQUulzJaq0Z
         qDYFcpoAd9kqVYnFFG/asx269rt6OD2HQPUbAY8u3F3jyKIQQ/1MAphT34fdixxLmU
         w/iN541dTniRKfYHLoeKRBPcJX+GlqLIfrm6/LRY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marc Zyngier <maz@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.5 093/542] irqchip/gic-v3-its: Fix get_vlpi_map() breakage with doorbells
Date:   Fri, 14 Feb 2020 10:41:25 -0500
Message-Id: <20200214154854.6746-93-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit 093bf439fee0d40ade7e309c1288b409cdc3b38f ]

When updating an LPI configuration, get_vlpi_map() may be passed a
irq_data structure relative to an ITS domain (the normal case) or one
that is relative to the core GICv3 domain in the case of a GICv4
doorbell.

In the latter case, special care must be take not to dereference
the irq_chip data as an its_dev structure, as that isn't what is
stored there. Instead, check *first* whether the IRQ is forwarded
to a vcpu, and only then try to obtain the vlpi mapping.

Fixes: c1d4d5cd203c ("irqchip/gic-v3-its: Add its_vlpi_map helpers")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Reported-by: Zenghui Yu <yuzenghui@huawei.com>
Link: https://lore.kernel.org/r/20200122085609.658-1-yuzenghui@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v3-its.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index e05673bcd52bd..b704214390c0f 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -1170,13 +1170,14 @@ static void its_send_vclear(struct its_device *dev, u32 event_id)
  */
 static struct its_vlpi_map *get_vlpi_map(struct irq_data *d)
 {
-	struct its_device *its_dev = irq_data_get_irq_chip_data(d);
-	u32 event = its_get_event_id(d);
+	if (irqd_is_forwarded_to_vcpu(d)) {
+		struct its_device *its_dev = irq_data_get_irq_chip_data(d);
+		u32 event = its_get_event_id(d);
 
-	if (!irqd_is_forwarded_to_vcpu(d))
-		return NULL;
+		return dev_event_to_vlpi_map(its_dev, event);
+	}
 
-	return dev_event_to_vlpi_map(its_dev, event);
+	return NULL;
 }
 
 static void lpi_write_config(struct irq_data *d, u8 clr, u8 set)
-- 
2.20.1

