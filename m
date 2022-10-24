Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35FBB60A73A
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234402AbiJXMsb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:48:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234741AbiJXMpg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:45:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E89318B31;
        Mon, 24 Oct 2022 05:10:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 455496129E;
        Mon, 24 Oct 2022 12:09:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 515B7C433C1;
        Mon, 24 Oct 2022 12:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666613387;
        bh=/46bcVhFzcjZWnoY6JgoprBlN42KkvWIVoF7PtLK2+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k6Wreb9Ix+w620h6b9/mN7qw6XsblKYvE4bYRy4JYpo1uHJ/SmjAXilvy+zehpPfb
         crQFY43NYIIl1m6elasbMjsiYb76hoVFYu5B6SZeLqZiEtkMmF4D8m375+GpEN5jAB
         KqC4KxqOrgbKAPNSEuo8FiUdHuIuV3Kv4QzgBMn8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rustam Subkhankulov <subkhankulov@ispras.ru>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Tzung-Bi Shih <tzungbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 090/255] platform/chrome: fix double-free in chromeos_laptop_prepare()
Date:   Mon, 24 Oct 2022 13:30:00 +0200
Message-Id: <20221024113005.498169773@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113002.471093005@linuxfoundation.org>
References: <20221024113002.471093005@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rustam Subkhankulov <subkhankulov@ispras.ru>

[ Upstream commit 6ad4194d6a1e1d11b285989cd648ef695b4a93c0 ]

If chromeos_laptop_prepare_i2c_peripherals() fails after allocating memory
for 'cros_laptop->i2c_peripherals', this memory is freed at 'err_out' label
and nonzero value is returned. Then chromeos_laptop_destroy() is called,
resulting in double-free error.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Rustam Subkhankulov <subkhankulov@ispras.ru>
Fixes: 5020cd29d8bf ("platform/chrome: chromeos_laptop - supply properties for ACPI devices")
Reviewed-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Link: https://lore.kernel.org/r/20220813220843.2373004-1-subkhankulov@ispras.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/chrome/chromeos_laptop.c | 24 ++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/platform/chrome/chromeos_laptop.c b/drivers/platform/chrome/chromeos_laptop.c
index 8723bcf10c93..954953133d56 100644
--- a/drivers/platform/chrome/chromeos_laptop.c
+++ b/drivers/platform/chrome/chromeos_laptop.c
@@ -716,6 +716,7 @@ static int __init
 chromeos_laptop_prepare_i2c_peripherals(struct chromeos_laptop *cros_laptop,
 					const struct chromeos_laptop *src)
 {
+	struct i2c_peripheral *i2c_peripherals;
 	struct i2c_peripheral *i2c_dev;
 	struct i2c_board_info *info;
 	int i;
@@ -724,17 +725,15 @@ chromeos_laptop_prepare_i2c_peripherals(struct chromeos_laptop *cros_laptop,
 	if (!src->num_i2c_peripherals)
 		return 0;
 
-	cros_laptop->i2c_peripherals = kmemdup(src->i2c_peripherals,
-					       src->num_i2c_peripherals *
-						sizeof(*src->i2c_peripherals),
-					       GFP_KERNEL);
-	if (!cros_laptop->i2c_peripherals)
+	i2c_peripherals = kmemdup(src->i2c_peripherals,
+					      src->num_i2c_peripherals *
+					  sizeof(*src->i2c_peripherals),
+					  GFP_KERNEL);
+	if (!i2c_peripherals)
 		return -ENOMEM;
 
-	cros_laptop->num_i2c_peripherals = src->num_i2c_peripherals;
-
-	for (i = 0; i < cros_laptop->num_i2c_peripherals; i++) {
-		i2c_dev = &cros_laptop->i2c_peripherals[i];
+	for (i = 0; i < src->num_i2c_peripherals; i++) {
+		i2c_dev = &i2c_peripherals[i];
 		info = &i2c_dev->board_info;
 
 		error = chromeos_laptop_setup_irq(i2c_dev);
@@ -752,16 +751,19 @@ chromeos_laptop_prepare_i2c_peripherals(struct chromeos_laptop *cros_laptop,
 		}
 	}
 
+	cros_laptop->i2c_peripherals = i2c_peripherals;
+	cros_laptop->num_i2c_peripherals = src->num_i2c_peripherals;
+
 	return 0;
 
 err_out:
 	while (--i >= 0) {
-		i2c_dev = &cros_laptop->i2c_peripherals[i];
+		i2c_dev = &i2c_peripherals[i];
 		info = &i2c_dev->board_info;
 		if (info->properties)
 			property_entries_free(info->properties);
 	}
-	kfree(cros_laptop->i2c_peripherals);
+	kfree(i2c_peripherals);
 	return error;
 }
 
-- 
2.35.1



