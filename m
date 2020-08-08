Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C70223FB5C
	for <lists+stable@lfdr.de>; Sun,  9 Aug 2020 01:49:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725950AbgHHXhL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Aug 2020 19:37:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:50010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727845AbgHHXhI (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Aug 2020 19:37:08 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73C7020791;
        Sat,  8 Aug 2020 23:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596929828;
        bh=fw0ThbpYQA6LIUcE4wTI9DtbAVDrXtiAyNGq0cTApy8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qdyiWtVJAws9u6geLhAcFU6yJ5rX53Sh2agp8XhL930kHAsgdQ45iuP6wZXx0Z6P5
         mUv+0pgv4/34kbxUt5ti7MchPigG5WmHlYwPByARIYkSoi5ci6X4kGu9sGyeZgq1x7
         hbMuQmEAVl3cX6PNOfcSAZD/Isz3aNlgyY4Hvf9k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tiezhu Yang <yangtiezhu@loongson.cn>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 60/72] irqchip/loongson-htvec: Check return value of irq_domain_translate_onecell()
Date:   Sat,  8 Aug 2020 19:35:29 -0400
Message-Id: <20200808233542.3617339-60-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200808233542.3617339-1-sashal@kernel.org>
References: <20200808233542.3617339-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit dbec37048d27cee36e103e113b5f9b1852bfe997 ]

Check the return value of irq_domain_translate_onecell() due to
it may returns -EINVAL if failed.

Fixes: 818e915fbac5 ("irqchip: Add Loongson HyperTransport Vector support")
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/1594087972-21715-5-git-send-email-yangtiezhu@loongson.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-loongson-htvec.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-loongson-htvec.c b/drivers/irqchip/irq-loongson-htvec.c
index b36d403383230..720cf96ae90ee 100644
--- a/drivers/irqchip/irq-loongson-htvec.c
+++ b/drivers/irqchip/irq-loongson-htvec.c
@@ -109,11 +109,14 @@ static struct irq_chip htvec_irq_chip = {
 static int htvec_domain_alloc(struct irq_domain *domain, unsigned int virq,
 			      unsigned int nr_irqs, void *arg)
 {
+	int ret;
 	unsigned long hwirq;
 	unsigned int type, i;
 	struct htvec *priv = domain->host_data;
 
-	irq_domain_translate_onecell(domain, arg, &hwirq, &type);
+	ret = irq_domain_translate_onecell(domain, arg, &hwirq, &type);
+	if (ret)
+		return ret;
 
 	for (i = 0; i < nr_irqs; i++) {
 		irq_domain_set_info(domain, virq + i, hwirq + i, &htvec_irq_chip,
-- 
2.25.1

