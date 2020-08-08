Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1718823FB59
	for <lists+stable@lfdr.de>; Sun,  9 Aug 2020 01:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727840AbgHHXhH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Aug 2020 19:37:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:49992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727834AbgHHXhH (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Aug 2020 19:37:07 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4969220716;
        Sat,  8 Aug 2020 23:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596929827;
        bh=BSX9EcTnUekZaIJkQio+Eo14SvKz1ux0nZh1+7uibnk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nTaSD538e8S5vKBicQoars1cYk23evCgKf+9YQYwzKAtiLu48xb+xrNXYZDL4hh0H
         BJ4YhwYqvMOWPhxAO17a6C9LDRWwyVMPSpOM4guvv7ZmbTi1XmUypYF7FZSjDtlur5
         rcghnF7FO+/4SUAE2FNqHZtGSXESD4Nlhs33Facw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tiezhu Yang <yangtiezhu@loongson.cn>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 59/72] irqchip/loongson-htvec: Fix potential resource leak
Date:   Sat,  8 Aug 2020 19:35:28 -0400
Message-Id: <20200808233542.3617339-59-sashal@kernel.org>
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

[ Upstream commit 652d54e77a438cf38a5731d8f9983c81e72dc429 ]

In the function htvec_of_init(), system resource "parent_irq"
was not released in an error case. Thus add a jump target for
the completion of the desired exception handling.

Fixes: 818e915fbac5 ("irqchip: Add Loongson HyperTransport Vector support")
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/1594087972-21715-4-git-send-email-yangtiezhu@loongson.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-loongson-htvec.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-loongson-htvec.c b/drivers/irqchip/irq-loongson-htvec.c
index 1ece9337c78dc..b36d403383230 100644
--- a/drivers/irqchip/irq-loongson-htvec.c
+++ b/drivers/irqchip/irq-loongson-htvec.c
@@ -192,7 +192,7 @@ static int htvec_of_init(struct device_node *node,
 	if (!priv->htvec_domain) {
 		pr_err("Failed to create IRQ domain\n");
 		err = -ENOMEM;
-		goto iounmap_base;
+		goto irq_dispose;
 	}
 
 	htvec_reset(priv);
@@ -203,6 +203,9 @@ static int htvec_of_init(struct device_node *node,
 
 	return 0;
 
+irq_dispose:
+	for (; i > 0; i--)
+		irq_dispose_mapping(parent_irq[i - 1]);
 iounmap_base:
 	iounmap(priv->base);
 free_priv:
-- 
2.25.1

