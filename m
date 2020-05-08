Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A279D1CABCE
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729508AbgEHMrN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:47:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:49370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729518AbgEHMrL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:47:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DEA2C2145D;
        Fri,  8 May 2020 12:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942031;
        bh=Xy4yHPdUlO1KmUpRIYwDSXjdAQg1LSIBa3HsDu8owrg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2D34b7Xmviho9F1K+uwquJJDSTwY6IUuY2ddWduk1/NFSEVrjB1gAVZ5SVp4W4GzE
         7qrEAsZyZM3CkjEwrRNjlvW9a4e8CvZQPfiDPIYjwD3L8ZudWrccKPWdVnbWN/VC+K
         CgY4Ty7wWyAUZbinMQv74O+cXPWnIKWx36kM11t4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marcin Niestroj <m.niestroj@grinn-global.com>,
        Sebastian Reichel <sre@kernel.org>
Subject: [PATCH 4.4 232/312] power_supply: tps65217-charger: Fix NULL deref during property export
Date:   Fri,  8 May 2020 14:33:43 +0200
Message-Id: <20200508123140.750024620@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marcin Niestroj <m.niestroj@grinn-global.com>

commit 362761299eea7dfc3a4870551de36e08758b9254 upstream.

This bug leads to:

[    1.906411] Unable to handle kernel NULL pointer dereference at virtual address 0000000c
[    1.914878] pgd = c0004000
[    1.917786] [0000000c] *pgd=00000000
[    1.921536] Internal error: Oops: 5 [#1] SMP ARM
[    1.926357] Modules linked in:
[    1.929556] CPU: 0 PID: 14 Comm: kworker/0:1 Not tainted 4.4.5 #18
[    1.936006] Hardware name: Generic AM33XX (Flattened Device Tree)
[    1.942383] Workqueue: events power_supply_changed_work
[    1.947842] task: de2c41c0 ti: de2c8000 task.ti: de2c8000
[    1.953483] PC is at tps65217_ac_get_property+0x14/0x28
[    1.958937] LR is at tps65217_ac_get_property+0x10/0x28

Driver was trying to use drv_data in property get handler. However drv_data
was not set, so it caused NULL pointer dereference. This patch properly
sets drv_data during probe by power_supply_config parameter, so the
property get handler works as desired.

Signed-off-by: Marcin Niestroj <m.niestroj@grinn-global.com>
Fixes: 3636859b280c ("power_supply: Add support for tps65217-charger")
Signed-off-by: Sebastian Reichel <sre@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/power/tps65217_charger.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/power/tps65217_charger.c
+++ b/drivers/power/tps65217_charger.c
@@ -197,6 +197,7 @@ static int tps65217_charger_probe(struct
 {
 	struct tps65217 *tps = dev_get_drvdata(pdev->dev.parent);
 	struct tps65217_charger *charger;
+	struct power_supply_config cfg = {};
 	int ret;
 
 	dev_dbg(&pdev->dev, "%s\n", __func__);
@@ -209,9 +210,12 @@ static int tps65217_charger_probe(struct
 	charger->tps = tps;
 	charger->dev = &pdev->dev;
 
+	cfg.of_node = pdev->dev.of_node;
+	cfg.drv_data = charger;
+
 	charger->ac = devm_power_supply_register(&pdev->dev,
 						 &tps65217_charger_desc,
-						 NULL);
+						 &cfg);
 	if (IS_ERR(charger->ac)) {
 		dev_err(&pdev->dev, "failed: power supply register\n");
 		return PTR_ERR(charger->ac);


