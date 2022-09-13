Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71AC35B7264
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232953AbiIMOzT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:55:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234567AbiIMOwi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:52:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0E9461D55;
        Tue, 13 Sep 2022 07:26:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE7ACB80FAC;
        Tue, 13 Sep 2022 14:24:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47409C433D7;
        Tue, 13 Sep 2022 14:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079079;
        bh=GmD8OyhS5q9OcZubOKiww01zvgwVnQC/NOAKXwhA8qU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zQWMM+qi3eroPQSsDhm9jDvTgRy6pb4IofK8ZY4bML1IvZuY+bTPQRwhZdvsX0Eb7
         tymNEt7PDFbheD1wvX5LFK+8cVNJ5a/D9/wygLL5qaVoeNWaxr8MrUvm7DdwmEgjID
         9AQZttz8OU+BRo7Cp7BRLBfQqXRyGvW7T1KNMczU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eliav Farber <farbere@amazon.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 74/79] hwmon: (mr75203) fix VM sensor allocation when "intel,vm-map" not defined
Date:   Tue, 13 Sep 2022 16:05:19 +0200
Message-Id: <20220913140353.728371935@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140350.291927556@linuxfoundation.org>
References: <20220913140350.291927556@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eliav Farber <farbere@amazon.com>

[ Upstream commit 81114fc3d27bf5b06b2137d2fd2b63da656a8b90 ]

Bug - in case "intel,vm-map" is missing in device-tree ,'num' is set
to 0, and no voltage channel infos are allocated.

The reason num is set to 0 when "intel,vm-map" is missing is to set the
entire pvt->vm_idx[] with incremental channel numbers, but it didn't
take into consideration that same num is used later in devm_kcalloc().

If "intel,vm-map" does exist there is no need to set the unspecified
channels with incremental numbers, because the unspecified channels
can't be accessed in pvt_read_in() which is the only other place besides
the probe functions that uses pvt->vm_idx[].

This change fixes the bug by moving the incremental channel numbers
setting to be done only if "intel,vm-map" property is defined (starting
loop from 0), and removing 'num = 0'.

Fixes: 9d823351a337 ("hwmon: Add hardware monitoring driver for Moortec MR75203 PVT controller")
Signed-off-by: Eliav Farber <farbere@amazon.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20220908152449.35457-3-farbere@amazon.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/mr75203.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/hwmon/mr75203.c b/drivers/hwmon/mr75203.c
index 046523d47c29b..81ccb4c6fa5c0 100644
--- a/drivers/hwmon/mr75203.c
+++ b/drivers/hwmon/mr75203.c
@@ -594,7 +594,12 @@ static int mr75203_probe(struct platform_device *pdev)
 		ret = device_property_read_u8_array(dev, "intel,vm-map",
 						    pvt->vm_idx, vm_num);
 		if (ret) {
-			num = 0;
+			/*
+			 * Incase intel,vm-map property is not defined, we
+			 * assume incremental channel numbers.
+			 */
+			for (i = 0; i < vm_num; i++)
+				pvt->vm_idx[i] = i;
 		} else {
 			for (i = 0; i < vm_num; i++)
 				if (pvt->vm_idx[i] >= vm_num ||
@@ -604,13 +609,6 @@ static int mr75203_probe(struct platform_device *pdev)
 				}
 		}
 
-		/*
-		 * Incase intel,vm-map property is not defined, we assume
-		 * incremental channel numbers.
-		 */
-		for (i = num; i < vm_num; i++)
-			pvt->vm_idx[i] = i;
-
 		in_config = devm_kcalloc(dev, num + 1,
 					 sizeof(*in_config), GFP_KERNEL);
 		if (!in_config)
-- 
2.35.1



