Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB1E14CF4CC
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:21:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236543AbiCGJWR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:22:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236600AbiCGJVp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:21:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3358F6578F;
        Mon,  7 Mar 2022 01:20:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9149761015;
        Mon,  7 Mar 2022 09:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EAA2C340F3;
        Mon,  7 Mar 2022 09:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646644816;
        bh=aEuGtaH+pzgMEYr/ie4R5dIEbmvkR7gT5wVusq4ep4s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NXArMbF1Z9RiA1jhiyoGaPavHsmxsZN7eEl4Yk48ymODQ/yAZxPJQ8fOvKovynVeW
         eIw3zMh5bOCW0oLipjFblfNl75PiHn5Fh6ooggk8QVidOSlS84AgLi/KVknjCKJdTH
         a6sDISuebQE3M/PAcuWkDHNGY4kEN1lqaoX4PRW0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 4.9 29/32] Input: elan_i2c - fix regulator enable count imbalance after suspend/resume
Date:   Mon,  7 Mar 2022 10:18:55 +0100
Message-Id: <20220307091635.265451948@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091634.434478485@linuxfoundation.org>
References: <20220307091634.434478485@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit 04b7762e37c95d9b965d16bb0e18dbd1fa2e2861 upstream.

Before these changes elan_suspend() would only disable the regulator
when device_may_wakeup() returns false; whereas elan_resume() would
unconditionally enable it, leading to an enable count imbalance when
device_may_wakeup() returns true.

This triggers the "WARN_ON(regulator->enable_count)" in regulator_put()
when the elan_i2c driver gets unbound, this happens e.g. with the
hot-plugable dock with Elan I2C touchpad for the Asus TF103C 2-in-1.

Fix this by making the regulator_enable() call also be conditional
on device_may_wakeup() returning false.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20220131135436.29638-2-hdegoede@redhat.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/mouse/elan_i2c_core.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/input/mouse/elan_i2c_core.c
+++ b/drivers/input/mouse/elan_i2c_core.c
@@ -1184,17 +1184,17 @@ static int __maybe_unused elan_resume(st
 	struct elan_tp_data *data = i2c_get_clientdata(client);
 	int error;
 
-	if (device_may_wakeup(dev) && data->irq_wake) {
+	if (!device_may_wakeup(dev)) {
+		error = regulator_enable(data->vcc);
+		if (error) {
+			dev_err(dev, "error %d enabling regulator\n", error);
+			goto err;
+		}
+	} else if (data->irq_wake) {
 		disable_irq_wake(client->irq);
 		data->irq_wake = false;
 	}
 
-	error = regulator_enable(data->vcc);
-	if (error) {
-		dev_err(dev, "error %d enabling regulator\n", error);
-		goto err;
-	}
-
 	error = elan_set_power(data, true);
 	if (error) {
 		dev_err(dev, "power up when resuming failed: %d\n", error);


