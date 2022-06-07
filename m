Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05062541E9B
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381662AbiFGWc1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:32:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385577AbiFGWbi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 18:31:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EBE4279E58;
        Tue,  7 Jun 2022 12:24:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 37EBAB8220B;
        Tue,  7 Jun 2022 19:24:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F499C385A2;
        Tue,  7 Jun 2022 19:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629887;
        bh=s88LYf1pFdDDcHZeXM4fiQIU0i0g0org+rLeRSkBlFg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zt74k6AboFeAMpOpEROpUZzoKPdiIzeI8ll2Wizf/BSw1WUDN/Rqx8L7qP5EbFhTn
         DGy58JiXa/bw91Tlw0zwLWJipoV/jaHYxnLZOUz1QZ5XcgwgcsBm2cJeok7gWiK0cH
         T3HsNi1bTDiLllhGMNjw7u2HoyHU+hCD8sa1Cu4w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kant Fan <kant@allwinnertech.com>,
        Lukasz Luba <lukasz.luba@arm.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.18 812/879] thermal: devfreq_cooling: use local ops instead of global ops
Date:   Tue,  7 Jun 2022 19:05:30 +0200
Message-Id: <20220607165026.426095182@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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


