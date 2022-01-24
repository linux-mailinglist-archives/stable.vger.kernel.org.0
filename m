Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F344749A314
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:02:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2366120AbiAXXwV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:52:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1844616AbiAXXJy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:09:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06DDEC09F825;
        Mon, 24 Jan 2022 13:17:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B8122B81061;
        Mon, 24 Jan 2022 21:17:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DABA9C340E4;
        Mon, 24 Jan 2022 21:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059075;
        bh=o9mh0CAuKVwblnD04YxsdWNf415LLvY4f8KISait108=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JgXWoP6z7V+LlnZz5VUf1vKVswJB+TN1ZoeeSz3C+08T9JS23ys/e9+SQJ3JX+mBA
         X8Rg7lGFX5Q3sGMx7jxqpXrKE6OqS/h80q9klHqx92QRCzIHAR2S0thHZV6A0SBVxs
         xpuHcgdKgTjIDVubGhHNWZ4FXI3UHNrnrrEGGyVM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0496/1039] iommu/amd: X2apic mode: mask/unmask interrupts on suspend/resume
Date:   Mon, 24 Jan 2022 19:38:05 +0100
Message-Id: <20220124184141.922088375@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Levitsky <mlevitsk@redhat.com>

[ Upstream commit 1980105e3cfc2215c75b4f6b172661d675c467d1 ]

Use IRQCHIP_MASK_ON_SUSPEND to make the core irq code to
mask the iommu interrupt on suspend and unmask it on the resume.

Since now the unmask function updates the INTX settings,
that will restore them on resume from s3/s4.

Since IRQCHIP_MASK_ON_SUSPEND is only effective for interrupts
which are not wakeup sources, remove IRQCHIP_SKIP_SET_WAKE flag
and instead implement a dummy .irq_set_wake which doesn't allow
the interrupt to become a wakeup source.

Fixes: 66929812955bb ("iommu/amd: Add support for X2APIC IOMMU interrupts")

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Link: https://lore.kernel.org/r/20211123161038.48009-5-mlevitsk@redhat.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/init.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index 9e895bb8086a6..b94822fc2c9f7 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -2104,6 +2104,11 @@ static int intcapxt_set_affinity(struct irq_data *irqd,
 	return 0;
 }
 
+static int intcapxt_set_wake(struct irq_data *irqd, unsigned int on)
+{
+	return on ? -EOPNOTSUPP : 0;
+}
+
 static struct irq_chip intcapxt_controller = {
 	.name			= "IOMMU-MSI",
 	.irq_unmask		= intcapxt_unmask_irq,
@@ -2111,7 +2116,8 @@ static struct irq_chip intcapxt_controller = {
 	.irq_ack		= irq_chip_ack_parent,
 	.irq_retrigger		= irq_chip_retrigger_hierarchy,
 	.irq_set_affinity       = intcapxt_set_affinity,
-	.flags			= IRQCHIP_SKIP_SET_WAKE,
+	.irq_set_wake		= intcapxt_set_wake,
+	.flags			= IRQCHIP_MASK_ON_SUSPEND,
 };
 
 static const struct irq_domain_ops intcapxt_domain_ops = {
-- 
2.34.1



