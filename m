Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB1654167C
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358481AbiFGUxK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:53:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378620AbiFGUwT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:52:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FDCE11AFD0;
        Tue,  7 Jun 2022 11:42:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9BAA9B82018;
        Tue,  7 Jun 2022 18:42:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2C02C385A2;
        Tue,  7 Jun 2022 18:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627356;
        bh=s88LYf1pFdDDcHZeXM4fiQIU0i0g0org+rLeRSkBlFg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xCpHSEjhM1kTbsGLhCb190zxdXYhP7zBk3JMTccZ+sGcwIluFT5csXr3JuA6hBb8P
         dW5V/f930dgTmeqx9rlfK8PH7WC63ur2bD7uO454pNbcTXi4ero76vPCM1QndHVU2w
         jyiaslqEKc2d6Xs6OtOOfbWQzkIjsyvqhdXBjPAQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kant Fan <kant@allwinnertech.com>,
        Lukasz Luba <lukasz.luba@arm.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.17 710/772] thermal: devfreq_cooling: use local ops instead of global ops
Date:   Tue,  7 Jun 2022 19:05:02 +0200
Message-Id: <20220607165009.968371419@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kant Fan <kant@allwinnertech.com>

commit b947769b8f778db130aad834257fcaca25df2edc upstream.

Fix access illegal address problem in following condition:

There are multiple devfreq cooling devices in system, some of them has
EM model but others do not. Energy model ops such as state2power will
append to global devfreq_cooling_ops when the cooling device with
EM model is registered. It makes the cooling device without EM model
also use devfreq_cooling_ops after appending when registered later by
of_devfreq_cooling_register_power() or of_devfreq_cooling_register().

The IPA governor regards the cooling devices without EM model as a power
actor, because they also have energy model ops, and will access illegal
address at dfc->em_pd when execute cdev->ops->get_requested_power,
cdev->ops->state2power or cdev->ops->power2state.

Fixes: 615510fe13bd2 ("thermal: devfreq_cooling: remove old power model and use EM")
Cc: 5.13+ <stable@vger.kernel.org> # 5.13+
Signed-off-by: Kant Fan <kant@allwinnertech.com>
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/devfreq_cooling.c |   25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

--- a/drivers/thermal/devfreq_cooling.c
+++ b/drivers/thermal/devfreq_cooling.c
@@ -358,21 +358,28 @@ of_devfreq_cooling_register_power(struct
 	struct thermal_cooling_device *cdev;
 	struct device *dev = df->dev.parent;
 	struct devfreq_cooling_device *dfc;
+	struct thermal_cooling_device_ops *ops;
 	char *name;
 	int err, num_opps;
 
-	dfc = kzalloc(sizeof(*dfc), GFP_KERNEL);
-	if (!dfc)
+	ops = kmemdup(&devfreq_cooling_ops, sizeof(*ops), GFP_KERNEL);
+	if (!ops)
 		return ERR_PTR(-ENOMEM);
 
+	dfc = kzalloc(sizeof(*dfc), GFP_KERNEL);
+	if (!dfc) {
+		err = -ENOMEM;
+		goto free_ops;
+	}
+
 	dfc->devfreq = df;
 
 	dfc->em_pd = em_pd_get(dev);
 	if (dfc->em_pd) {
-		devfreq_cooling_ops.get_requested_power =
+		ops->get_requested_power =
 			devfreq_cooling_get_requested_power;
-		devfreq_cooling_ops.state2power = devfreq_cooling_state2power;
-		devfreq_cooling_ops.power2state = devfreq_cooling_power2state;
+		ops->state2power = devfreq_cooling_state2power;
+		ops->power2state = devfreq_cooling_power2state;
 
 		dfc->power_ops = dfc_power;
 
@@ -407,8 +414,7 @@ of_devfreq_cooling_register_power(struct
 	if (!name)
 		goto remove_qos_req;
 
-	cdev = thermal_of_cooling_device_register(np, name, dfc,
-						  &devfreq_cooling_ops);
+	cdev = thermal_of_cooling_device_register(np, name, dfc, ops);
 	kfree(name);
 
 	if (IS_ERR(cdev)) {
@@ -429,6 +435,8 @@ free_table:
 	kfree(dfc->freq_table);
 free_dfc:
 	kfree(dfc);
+free_ops:
+	kfree(ops);
 
 	return ERR_PTR(err);
 }
@@ -510,11 +518,13 @@ EXPORT_SYMBOL_GPL(devfreq_cooling_em_reg
 void devfreq_cooling_unregister(struct thermal_cooling_device *cdev)
 {
 	struct devfreq_cooling_device *dfc;
+	const struct thermal_cooling_device_ops *ops;
 	struct device *dev;
 
 	if (IS_ERR_OR_NULL(cdev))
 		return;
 
+	ops = cdev->ops;
 	dfc = cdev->devdata;
 	dev = dfc->devfreq->dev.parent;
 
@@ -525,5 +535,6 @@ void devfreq_cooling_unregister(struct t
 
 	kfree(dfc->freq_table);
 	kfree(dfc);
+	kfree(ops);
 }
 EXPORT_SYMBOL_GPL(devfreq_cooling_unregister);


