Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83837167843
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:48:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729087AbgBUHs2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:48:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:44550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729082AbgBUHs2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:48:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2247A207FD;
        Fri, 21 Feb 2020 07:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271307;
        bh=n2JVUqLD6dZ9KQSNGJH4Pva7c4CMFDtj28KH4mVguYo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hi6QdrHMhV3U9mRlUrSkDgYNS0P4sxrAUYOmbs5+nyakTDQIrIYYZO7KJfTbV37+k
         F7w1eiomuNya4Yh0PPJGcj0heQPYXqwL4+XJHgdQQJQhntFFNmVrQ1M6RC3HIORgZE
         l9LWtN46wQ4NsKpc5Bai4CqZH7TxYS+GzqEG7zH4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 079/399] irqchip/gic-v3-its: Fix get_vlpi_map() breakage with doorbells
Date:   Fri, 21 Feb 2020 08:36:44 +0100
Message-Id: <20200221072410.026921716@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



