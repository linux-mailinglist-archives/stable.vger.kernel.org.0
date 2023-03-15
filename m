Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 799DC6BB346
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:43:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232947AbjCOMnI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:43:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232955AbjCOMmr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:42:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6E4EA2C3F
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:41:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E202561D74
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:41:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04C21C433D2;
        Wed, 15 Mar 2023 12:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678884073;
        bh=1BmJ+h7AKBzQz0Hws51bHogpZpwzUQwVKxNSlLSMEUc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L/NBHPdUYeMxnPl6fHanIOMtRzXRcmqw+hxryCKzbWV4y388qNCWNud2D7SwzWOiv
         p8uKk+oX/obHxwj2ClVTg5bnt8tefFUUYKhGjEK7gDl/XYLBhtlbLHsUdazMiM1h6G
         S+LHP1HM9Kolo2JySeGmXZV9CfozxNzPpVzVsK4k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Armin Wolf <W_Armin@gmx.de>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 095/141] platform/x86: dell-ddv: Fix temperature scaling
Date:   Wed, 15 Mar 2023 13:13:18 +0100
Message-Id: <20230315115742.892893819@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115739.932786806@linuxfoundation.org>
References: <20230315115739.932786806@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit 0331b1b0ba65376ecf1c69414aa7696fef0930cb ]

After using the built-in UEFI hardware diagnostics to compare
the measured battery temperature, i noticed that the temperature
is actually expressed in tenth degree kelvin, similar to the
SBS-Data standard. For example, a value of 2992 is displayed as
26 degrees celsius.
Fix the scaling so that the correct values are being displayed.

Tested on a Dell Inspiron 3505.

Fixes: a77272c16041 ("platform/x86: dell: Add new dell-wmi-ddv driver")
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Link: https://lore.kernel.org/r/20230218115318.20662-2-W_Armin@gmx.de
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/dell/dell-wmi-ddv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/dell/dell-wmi-ddv.c b/drivers/platform/x86/dell/dell-wmi-ddv.c
index f99c4cb686fdc..96fede24877f3 100644
--- a/drivers/platform/x86/dell/dell-wmi-ddv.c
+++ b/drivers/platform/x86/dell/dell-wmi-ddv.c
@@ -14,7 +14,6 @@
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/kstrtox.h>
-#include <linux/math.h>
 #include <linux/module.h>
 #include <linux/limits.h>
 #include <linux/power_supply.h>
@@ -192,7 +191,8 @@ static ssize_t temp_show(struct device *dev, struct device_attribute *attr, char
 	if (ret < 0)
 		return ret;
 
-	return sysfs_emit(buf, "%d\n", DIV_ROUND_CLOSEST(value, 10));
+	/* Use 2731 instead of 2731.5 to avoid unnecessary rounding */
+	return sysfs_emit(buf, "%d\n", value - 2731);
 }
 
 static ssize_t eppid_show(struct device *dev, struct device_attribute *attr, char *buf)
-- 
2.39.2



