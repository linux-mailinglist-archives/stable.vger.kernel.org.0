Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A77CE5496C1
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355842AbiFMLrR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:47:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357095AbiFMLpj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:45:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5C3649B5F;
        Mon, 13 Jun 2022 03:51:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F532611B3;
        Mon, 13 Jun 2022 10:51:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BE1AC3411C;
        Mon, 13 Jun 2022 10:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655117499;
        bh=+UxC2I6cB/bAVSQFDihDHHxSOIrE2QoFweh2yYezpEY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DlFZiEDVd+Z2YOIb9rczYVXtAKt70h6sDbw04234OoGWeR+NZ8X9t9B6uL2s1fJoH
         f3R63LSPy2O7GT50uOlt66KDMPAHwoB1lmT4VLhGhWF/RAACudhTePZeI1zxbWWupQ
         sosWc8E6uamk4QOroh5Va6e/8cm28zLj3pT1pEmA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 041/287] hwmon: Make chip parameter for with_info API mandatory
Date:   Mon, 13 Jun 2022 12:07:45 +0200
Message-Id: <20220613094925.111840882@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094923.832156175@linuxfoundation.org>
References: <20220613094923.832156175@linuxfoundation.org>
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

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit ddaefa209c4ac791c1262e97c9b2d0440c8ef1d5 ]

Various attempts were made recently to "convert" the old
hwmon_device_register() API to devm_hwmon_device_register_with_info()
by just changing the function name without actually converting the
driver. Prevent this from happening by making the 'chip' parameter of
devm_hwmon_device_register_with_info() mandatory.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/hwmon/hwmon-kernel-api.txt |  2 +-
 drivers/hwmon/hwmon.c                    | 16 +++++++---------
 2 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/Documentation/hwmon/hwmon-kernel-api.txt b/Documentation/hwmon/hwmon-kernel-api.txt
index eb7a78aebb38..4981df157b04 100644
--- a/Documentation/hwmon/hwmon-kernel-api.txt
+++ b/Documentation/hwmon/hwmon-kernel-api.txt
@@ -71,7 +71,7 @@ hwmon_device_register_with_info is the most comprehensive and preferred means
 to register a hardware monitoring device. It creates the standard sysfs
 attributes in the hardware monitoring core, letting the driver focus on reading
 from and writing to the chip instead of having to bother with sysfs attributes.
-The parent device parameter cannot be NULL with non-NULL chip info. Its
+The parent device parameter as well as the chip parameter must not be NULL. Its
 parameters are described in more detail below.
 
 devm_hwmon_device_register_with_info is similar to
diff --git a/drivers/hwmon/hwmon.c b/drivers/hwmon/hwmon.c
index c4051a3e63c2..fb82d8ee0dd6 100644
--- a/drivers/hwmon/hwmon.c
+++ b/drivers/hwmon/hwmon.c
@@ -695,11 +695,12 @@ EXPORT_SYMBOL_GPL(hwmon_device_register_with_groups);
 
 /**
  * hwmon_device_register_with_info - register w/ hwmon
- * @dev: the parent device
- * @name: hwmon name attribute
- * @drvdata: driver data to attach to created device
- * @chip: pointer to hwmon chip information
+ * @dev: the parent device (mandatory)
+ * @name: hwmon name attribute (mandatory)
+ * @drvdata: driver data to attach to created device (optional)
+ * @chip: pointer to hwmon chip information (mandatory)
  * @extra_groups: pointer to list of additional non-standard attribute groups
+ *	(optional)
  *
  * hwmon_device_unregister() must be called when the device is no
  * longer needed.
@@ -712,13 +713,10 @@ hwmon_device_register_with_info(struct device *dev, const char *name,
 				const struct hwmon_chip_info *chip,
 				const struct attribute_group **extra_groups)
 {
-	if (!name)
-		return ERR_PTR(-EINVAL);
-
-	if (chip && (!chip->ops || !chip->ops->is_visible || !chip->info))
+	if (!dev || !name || !chip)
 		return ERR_PTR(-EINVAL);
 
-	if (chip && !dev)
+	if (!chip->ops || !chip->ops->is_visible || !chip->info)
 		return ERR_PTR(-EINVAL);
 
 	return __hwmon_device_register(dev, name, drvdata, chip, extra_groups);
-- 
2.35.1



