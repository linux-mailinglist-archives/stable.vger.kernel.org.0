Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8A17558738
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 20:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237954AbiFWSXw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 14:23:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237081AbiFWSVF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 14:21:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8ACB68C42;
        Thu, 23 Jun 2022 10:25:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C67DD61BFA;
        Thu, 23 Jun 2022 17:25:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B936AC3411B;
        Thu, 23 Jun 2022 17:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656005111;
        bh=c5AcL957SsFi4ZAuL0Y2ToBTmHljoGZLqLESIUV+rfM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hKYs+yNiSDnHjxn17/VJcieBx/hsxbbGd0zYmGrDfGlM7N8TBrIwG/qNqoLXBSWdH
         lLAPV1Mm+xjVOz2W3rN4BEF6ZrQ9cen8pzALvu0nQZbKQFFwp6+HVeXP1+GK39KOnp
         H85u8Y6X/vEH39Hj5UQo8c8hUMlTLHKq4zeaWr1s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Haller <julian.haller@philips.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 11/11] Revert "hwmon: Make chip parameter for with_info API mandatory"
Date:   Thu, 23 Jun 2022 18:45:15 +0200
Message-Id: <20220623164321.527852885@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164321.195163701@linuxfoundation.org>
References: <20220623164321.195163701@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 1ec0bc72f5dab3ab367ae5230cf6f212d805a225 which is
commit ddaefa209c4ac791c1262e97c9b2d0440c8ef1d5 upstream.  It should not
have been applied to the stable trees.

Link: https://lore.kernel.org/r/20220622154454.GA1864037@roeck-us.net
Reported-by: Julian Haller <julian.haller@philips.com>
Reported-by: Guenter Roeck <linux@roeck-us.net>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/hwmon/hwmon-kernel-api.rst |    2 +-
 drivers/hwmon/hwmon.c                    |   16 +++++++++-------
 2 files changed, 10 insertions(+), 8 deletions(-)

--- a/Documentation/hwmon/hwmon-kernel-api.rst
+++ b/Documentation/hwmon/hwmon-kernel-api.rst
@@ -72,7 +72,7 @@ hwmon_device_register_with_info is the m
 to register a hardware monitoring device. It creates the standard sysfs
 attributes in the hardware monitoring core, letting the driver focus on reading
 from and writing to the chip instead of having to bother with sysfs attributes.
-The parent device parameter as well as the chip parameter must not be NULL. Its
+The parent device parameter cannot be NULL with non-NULL chip info. Its
 parameters are described in more detail below.
 
 devm_hwmon_device_register_with_info is similar to
--- a/drivers/hwmon/hwmon.c
+++ b/drivers/hwmon/hwmon.c
@@ -715,12 +715,11 @@ EXPORT_SYMBOL_GPL(hwmon_device_register_
 
 /**
  * hwmon_device_register_with_info - register w/ hwmon
- * @dev: the parent device (mandatory)
- * @name: hwmon name attribute (mandatory)
- * @drvdata: driver data to attach to created device (optional)
- * @chip: pointer to hwmon chip information (mandatory)
+ * @dev: the parent device
+ * @name: hwmon name attribute
+ * @drvdata: driver data to attach to created device
+ * @chip: pointer to hwmon chip information
  * @extra_groups: pointer to list of additional non-standard attribute groups
- *	(optional)
  *
  * hwmon_device_unregister() must be called when the device is no
  * longer needed.
@@ -733,10 +732,13 @@ hwmon_device_register_with_info(struct d
 				const struct hwmon_chip_info *chip,
 				const struct attribute_group **extra_groups)
 {
-	if (!dev || !name || !chip)
+	if (!name)
 		return ERR_PTR(-EINVAL);
 
-	if (!chip->ops || !chip->ops->is_visible || !chip->info)
+	if (chip && (!chip->ops || !chip->ops->is_visible || !chip->info))
+		return ERR_PTR(-EINVAL);
+
+	if (chip && !dev)
 		return ERR_PTR(-EINVAL);
 
 	return __hwmon_device_register(dev, name, drvdata, chip, extra_groups);


