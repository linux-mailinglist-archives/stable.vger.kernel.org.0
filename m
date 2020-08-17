Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96C1F247735
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729324AbgHQPVJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:21:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:42998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729314AbgHQPVE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:21:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F22620716;
        Mon, 17 Aug 2020 15:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597677663;
        bh=fw0ThbpYQA6LIUcE4wTI9DtbAVDrXtiAyNGq0cTApy8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tMow1++WzTTisx6mYEad+uooRMpEWc0midTGEELQk/OOuXa9Agw4Nw9bk0UVAN2s2
         Y8jT2DeQvGlz9XgWFTt//xt/37A5/2y/szJ047bXHG8oMd6msu7tfWY7hLlOoi9dEe
         sey//2a2PqRkOT8AwvOdyAPEskJPCToYyTm+mZSM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tiezhu Yang <yangtiezhu@loongson.cn>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 064/464] irqchip/loongson-htvec: Check return value of irq_domain_translate_onecell()
Date:   Mon, 17 Aug 2020 17:10:17 +0200
Message-Id: <20200817143836.831774252@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



