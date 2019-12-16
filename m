Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79FF21213BF
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:05:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729415AbfLPSEg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:04:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:41976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729440AbfLPSEf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:04:35 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E243620700;
        Mon, 16 Dec 2019 18:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519475;
        bh=vQ+eRiIY2UwYOBrhgsHle4m1zP2RSoGVKwaTLJoB/Ug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YabEwnC5ck9KXQB1kU/opb9zHCumgVZILkibXOmMUOO0bNxDN/6JIGT4sSIRVRahm
         /inQhMv1qJemsN6eXMCsZ92LGMxP9rNib4zSvbrlSBRQT9VxAK8Awi4iDeKFBbMgHz
         sSCkdkyUCLr1xFbT1Rfuc6tPGctEFPdLRtKD0ovI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 4.19 080/140] pinctrl: samsung: Fix device node refcount leaks in S3C24xx wakeup controller init
Date:   Mon, 16 Dec 2019 18:49:08 +0100
Message-Id: <20191216174808.848506251@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174747.111154704@linuxfoundation.org>
References: <20191216174747.111154704@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

commit 6fbbcb050802d6ea109f387e961b1dbcc3a80c96 upstream.

In s3c24xx_eint_init() the for_each_child_of_node() loop is used with a
break to find a matching child node.  Although each iteration of
for_each_child_of_node puts the previous node, but early exit from loop
misses it.  This leads to leak of device node.

Cc: <stable@vger.kernel.org>
Fixes: af99a7507469 ("pinctrl: Add pinctrl-s3c24xx driver")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pinctrl/samsung/pinctrl-s3c24xx.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/pinctrl/samsung/pinctrl-s3c24xx.c
+++ b/drivers/pinctrl/samsung/pinctrl-s3c24xx.c
@@ -490,8 +490,10 @@ static int s3c24xx_eint_init(struct sams
 		return -ENODEV;
 
 	eint_data = devm_kzalloc(dev, sizeof(*eint_data), GFP_KERNEL);
-	if (!eint_data)
+	if (!eint_data) {
+		of_node_put(eint_np);
 		return -ENOMEM;
+	}
 
 	eint_data->drvdata = d;
 
@@ -503,12 +505,14 @@ static int s3c24xx_eint_init(struct sams
 		irq = irq_of_parse_and_map(eint_np, i);
 		if (!irq) {
 			dev_err(dev, "failed to get wakeup EINT IRQ %d\n", i);
+			of_node_put(eint_np);
 			return -ENXIO;
 		}
 
 		eint_data->parents[i] = irq;
 		irq_set_chained_handler_and_data(irq, handlers[i], eint_data);
 	}
+	of_node_put(eint_np);
 
 	bank = d->pin_banks;
 	for (i = 0; i < d->nr_banks; ++i, ++bank) {


