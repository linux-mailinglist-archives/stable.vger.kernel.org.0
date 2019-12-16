Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 097E012147D
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:12:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730635AbfLPSLp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:11:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:55990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730148AbfLPSLo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:11:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C952206E0;
        Mon, 16 Dec 2019 18:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519903;
        bh=+TcQCskO8Yxad2UV+B9L/vAH6xNMwSDamhI/wfm7YAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m/5eskF93S5FJ+NRw70wLbEQxKCsJISHINo2QcRxq3oAoyu88QDEVFtxIxTHA4aYu
         2/o+iKGTfQUv15qpBSVabXqOqE5wPwy5EJ3gXGla/CIt6HAdt2cj5mI+PLT2rlvj3M
         Bnil/YzBgKJQGG8dOc2xNLBwhN1DpiZ8PkBGqDHw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 5.3 114/180] pinctrl: samsung: Fix device node refcount leaks in Exynos wakeup controller init
Date:   Mon, 16 Dec 2019 18:49:14 +0100
Message-Id: <20191216174839.220927863@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174806.018988360@linuxfoundation.org>
References: <20191216174806.018988360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

commit 5c7f48dd14e892e3e920dd6bbbd52df79e1b3b41 upstream.

In exynos_eint_wkup_init() the for_each_child_of_node() loop is used
with a break to find a matching child node.  Although each iteration of
for_each_child_of_node puts the previous node, but early exit from loop
misses it.  This leads to leak of device node.

Cc: <stable@vger.kernel.org>
Fixes: 43b169db1841 ("pinctrl: add exynos4210 specific extensions for samsung pinctrl driver")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pinctrl/samsung/pinctrl-exynos.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/pinctrl/samsung/pinctrl-exynos.c
+++ b/drivers/pinctrl/samsung/pinctrl-exynos.c
@@ -506,6 +506,7 @@ int exynos_eint_wkup_init(struct samsung
 				bank->nr_pins, &exynos_eint_irqd_ops, bank);
 		if (!bank->irq_domain) {
 			dev_err(dev, "wkup irq domain add failed\n");
+			of_node_put(wkup_np);
 			return -ENXIO;
 		}
 
@@ -520,8 +521,10 @@ int exynos_eint_wkup_init(struct samsung
 		weint_data = devm_kcalloc(dev,
 					  bank->nr_pins, sizeof(*weint_data),
 					  GFP_KERNEL);
-		if (!weint_data)
+		if (!weint_data) {
+			of_node_put(wkup_np);
 			return -ENOMEM;
+		}
 
 		for (idx = 0; idx < bank->nr_pins; ++idx) {
 			irq = irq_of_parse_and_map(bank->of_node, idx);
@@ -538,10 +541,13 @@ int exynos_eint_wkup_init(struct samsung
 		}
 	}
 
-	if (!muxed_banks)
+	if (!muxed_banks) {
+		of_node_put(wkup_np);
 		return 0;
+	}
 
 	irq = irq_of_parse_and_map(wkup_np, 0);
+	of_node_put(wkup_np);
 	if (!irq) {
 		dev_err(dev, "irq number for muxed EINTs not found\n");
 		return 0;


