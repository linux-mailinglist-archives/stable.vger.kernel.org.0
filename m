Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2179812169E
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730686AbfLPSM3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:12:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:57438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730952AbfLPSM2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:12:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8ED62166E;
        Mon, 16 Dec 2019 18:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519947;
        bh=PHBl7xJvR/pmjiITQEmO7ueYAFIPDrnVsE5yaoW6tvU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0OFuJyExtsOUFcM8TlFU5FjsCvasOz+/1lnIPyvamiduq2Syf5q0XXyNdSWYxbgUM
         /mYzmc8Bc90xqFNJ381YIgXc0nLY9VdzLzdnucCus/tuBe6a9zlqdp7n70yN3kd33W
         Jmw95Xi1yPgOMpnF2vfoEHbGGK9/m2YLXk0B6FV4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 5.3 117/180] pinctrl: samsung: Fix device node refcount leaks in S3C64xx wakeup controller init
Date:   Mon, 16 Dec 2019 18:49:17 +0100
Message-Id: <20191216174839.551751721@linuxfoundation.org>
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

commit 7f028caadf6c37580d0f59c6c094ed09afc04062 upstream.

In s3c64xx_eint_eint0_init() the for_each_child_of_node() loop is used
with a break to find a matching child node.  Although each iteration of
for_each_child_of_node puts the previous node, but early exit from loop
misses it.  This leads to leak of device node.

Cc: <stable@vger.kernel.org>
Fixes: 61dd72613177 ("pinctrl: Add pinctrl-s3c64xx driver")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pinctrl/samsung/pinctrl-s3c64xx.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/pinctrl/samsung/pinctrl-s3c64xx.c
+++ b/drivers/pinctrl/samsung/pinctrl-s3c64xx.c
@@ -704,8 +704,10 @@ static int s3c64xx_eint_eint0_init(struc
 		return -ENODEV;
 
 	data = devm_kzalloc(dev, sizeof(*data), GFP_KERNEL);
-	if (!data)
+	if (!data) {
+		of_node_put(eint0_np);
 		return -ENOMEM;
+	}
 	data->drvdata = d;
 
 	for (i = 0; i < NUM_EINT0_IRQ; ++i) {
@@ -714,6 +716,7 @@ static int s3c64xx_eint_eint0_init(struc
 		irq = irq_of_parse_and_map(eint0_np, i);
 		if (!irq) {
 			dev_err(dev, "failed to get wakeup EINT IRQ %d\n", i);
+			of_node_put(eint0_np);
 			return -ENXIO;
 		}
 
@@ -721,6 +724,7 @@ static int s3c64xx_eint_eint0_init(struc
 						 s3c64xx_eint0_handlers[i],
 						 data);
 	}
+	of_node_put(eint0_np);
 
 	bank = d->pin_banks;
 	for (i = 0; i < d->nr_banks; ++i, ++bank) {


