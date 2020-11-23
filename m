Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECE3A2C0A50
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:20:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730929AbgKWNSu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:18:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:52680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732351AbgKWMjv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:39:51 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E1A92076E;
        Mon, 23 Nov 2020 12:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135191;
        bh=BaWce4/0prl9IupTPFlcWUfavzpUFQii/xmSufO7c4U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kHKpTmo+jpQa4cj/ZtzXFqc0MBXBETW5J3SpY+dAa/5kmc7JxPYBuTknwV0s+JbKL
         lmoPJzBGJ/WYPwR3P0dEfbD20b09JgFAd1H+9rslQf9CfoZLHvVQHqASEKU3FCmCWz
         0rVirnPzGaOTB/IWakvU6p9NLaKUu6ji01Mj0eqU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Mark Brown <broonie@kernel.org>,
        Ahmad Fatoum <a.fatoum@pengutronix.de>
Subject: [PATCH 5.4 138/158] regulator: fix memory leak with repeated set_machine_constraints()
Date:   Mon, 23 Nov 2020 13:22:46 +0100
Message-Id: <20201123121826.588530462@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121819.943135899@linuxfoundation.org>
References: <20201123121819.943135899@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michał Mirosław <mirq-linux@rere.qmqm.pl>

commit 57a6ad482af256b2a13de14194fb8f67c1a65f10 upstream.

Fixed commit introduced a possible second call to
set_machine_constraints() and that allocates memory for
rdev->constraints. Move the allocation to the caller so
it's easier to manage and done once.

Fixes: aea6cb99703e ("regulator: resolve supply after creating regulator")
Cc: stable@vger.kernel.org
Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Tested-by: Ahmad Fatoum <a.fatoum@pengutronix.de> # stpmic1
Link: https://lore.kernel.org/r/78c3d4016cebc08d441aad18cb924b4e4d9cf9df.1605226675.git.mirq-linux@rere.qmqm.pl
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/regulator/core.c |   29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1275,7 +1275,6 @@ static int _regulator_do_enable(struct r
 /**
  * set_machine_constraints - sets regulator constraints
  * @rdev: regulator source
- * @constraints: constraints to apply
  *
  * Allows platform initialisation code to define and constrain
  * regulator circuits e.g. valid voltage/current ranges, etc.  NOTE:
@@ -1283,21 +1282,11 @@ static int _regulator_do_enable(struct r
  * regulator operations to proceed i.e. set_voltage, set_current_limit,
  * set_mode.
  */
-static int set_machine_constraints(struct regulator_dev *rdev,
-	const struct regulation_constraints *constraints)
+static int set_machine_constraints(struct regulator_dev *rdev)
 {
 	int ret = 0;
 	const struct regulator_ops *ops = rdev->desc->ops;
 
-	if (constraints)
-		rdev->constraints = kmemdup(constraints, sizeof(*constraints),
-					    GFP_KERNEL);
-	else
-		rdev->constraints = kzalloc(sizeof(*constraints),
-					    GFP_KERNEL);
-	if (!rdev->constraints)
-		return -ENOMEM;
-
 	ret = machine_constraints_voltage(rdev, rdev->constraints);
 	if (ret != 0)
 		return ret;
@@ -5014,7 +5003,6 @@ struct regulator_dev *
 regulator_register(const struct regulator_desc *regulator_desc,
 		   const struct regulator_config *cfg)
 {
-	const struct regulation_constraints *constraints = NULL;
 	const struct regulator_init_data *init_data;
 	struct regulator_config *config = NULL;
 	static atomic_t regulator_no = ATOMIC_INIT(-1);
@@ -5153,14 +5141,23 @@ regulator_register(const struct regulato
 
 	/* set regulator constraints */
 	if (init_data)
-		constraints = &init_data->constraints;
+		rdev->constraints = kmemdup(&init_data->constraints,
+					    sizeof(*rdev->constraints),
+					    GFP_KERNEL);
+	else
+		rdev->constraints = kzalloc(sizeof(*rdev->constraints),
+					    GFP_KERNEL);
+	if (!rdev->constraints) {
+		ret = -ENOMEM;
+		goto wash;
+	}
 
 	if (init_data && init_data->supply_regulator)
 		rdev->supply_name = init_data->supply_regulator;
 	else if (regulator_desc->supply_name)
 		rdev->supply_name = regulator_desc->supply_name;
 
-	ret = set_machine_constraints(rdev, constraints);
+	ret = set_machine_constraints(rdev);
 	if (ret == -EPROBE_DEFER) {
 		/* Regulator might be in bypass mode and so needs its supply
 		 * to set the constraints */
@@ -5169,7 +5166,7 @@ regulator_register(const struct regulato
 		 * that is just being created */
 		ret = regulator_resolve_supply(rdev);
 		if (!ret)
-			ret = set_machine_constraints(rdev, constraints);
+			ret = set_machine_constraints(rdev);
 		else
 			rdev_dbg(rdev, "unable to resolve supply early: %pe\n",
 				 ERR_PTR(ret));


