Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 319472C05F6
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:41:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730064AbgKWM0E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:26:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:35876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730093AbgKWM0C (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:26:02 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BB082076E;
        Mon, 23 Nov 2020 12:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134362;
        bh=hmvQGJEWgLNpb6GPmpt469sJIfq15Tw1rgxN5BXvMUM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tr5nocSzecG86pUJpaB7pz1xzfbqgONrAL/R0qJORNbg9d8/KQLsAoY/rxQcuWsvl
         Th7i2sVMnwgl/bdzDkoOTr2Lm3qGZEizWznOGWFgNR6ZJD/6+uyBaqZNHR63A+wh8f
         adhnJHZo+6bwEc7aPrelGTlPTXL3G7r263iAGSdw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Mark Brown <broonie@kernel.org>,
        Ahmad Fatoum <a.fatoum@pengutronix.de>
Subject: [PATCH 4.9 41/47] regulator: fix memory leak with repeated set_machine_constraints()
Date:   Mon, 23 Nov 2020 13:22:27 +0100
Message-Id: <20201123121807.545655380@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121805.530891002@linuxfoundation.org>
References: <20201123121805.530891002@linuxfoundation.org>
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
@@ -1025,7 +1025,6 @@ static int _regulator_do_enable(struct r
 /**
  * set_machine_constraints - sets regulator constraints
  * @rdev: regulator source
- * @constraints: constraints to apply
  *
  * Allows platform initialisation code to define and constrain
  * regulator circuits e.g. valid voltage/current ranges, etc.  NOTE:
@@ -1033,21 +1032,11 @@ static int _regulator_do_enable(struct r
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
@@ -3924,7 +3913,6 @@ struct regulator_dev *
 regulator_register(const struct regulator_desc *regulator_desc,
 		   const struct regulator_config *cfg)
 {
-	const struct regulation_constraints *constraints = NULL;
 	const struct regulator_init_data *init_data;
 	struct regulator_config *config = NULL;
 	static atomic_t regulator_no = ATOMIC_INIT(-1);
@@ -4024,14 +4012,23 @@ regulator_register(const struct regulato
 
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
@@ -4040,7 +4037,7 @@ regulator_register(const struct regulato
 		 * that is just being created */
 		ret = regulator_resolve_supply(rdev);
 		if (!ret)
-			ret = set_machine_constraints(rdev, constraints);
+			ret = set_machine_constraints(rdev);
 		else
 			rdev_dbg(rdev, "unable to resolve supply early: %pe\n",
 				 ERR_PTR(ret));


