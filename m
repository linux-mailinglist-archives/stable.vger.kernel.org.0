Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45D754F3C3E
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 17:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244915AbiDEMGw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:06:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358109AbiDEK17 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:27:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA46378FFE;
        Tue,  5 Apr 2022 03:15:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 47B1561777;
        Tue,  5 Apr 2022 10:15:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 536CFC385A1;
        Tue,  5 Apr 2022 10:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153742;
        bh=YIIjYNuNqtC8QLnqR4WnTEIhcQ4W4IebWPcPoV7WjgI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UpFDfZw7zv375JSL6swZ3umdO3kFfK0KMfjjjG3U5Sq6TRPk0QYRmG1jhoqFCgUUC
         G36AF5C0QbCB1ZCx/52tC6C6ppd3RRnbVGUAvh8Uo1cVpHIF2ILBrX7WMaCogknjNU
         epbHd6+9ROkDGZ3PUK5ye7wrIxWEIVJjLZxnzG7g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bastien Nocera <hadess@hadess.net>,
        Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 324/599] power: supply: bq24190_charger: Fix bq24190_vbus_is_enabled() wrong false return
Date:   Tue,  5 Apr 2022 09:30:18 +0200
Message-Id: <20220405070308.474830617@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit f7731754fdce33dad19be746f647d6ac47c5d695 ]

The datasheet says that the BQ24190_REG_POC_CHG_CONFIG bits can
have a value of either 10(0x2) or 11(0x3) for OTG (5V boost regulator)
mode.

Sofar bq24190_vbus_is_enabled() was only checking for 10 but some BIOS-es
uses 11 when enabling the regulator at boot.

Make bq24190_vbus_is_enabled() also check for 11 so that it does not
wrongly returns false when the bits are set to 11.

Fixes: 66b6bef2c4e0 ("power: supply: bq24190_charger: Export 5V boost converter as regulator")
Cc: Bastien Nocera <hadess@hadess.net>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/bq24190_charger.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/power/supply/bq24190_charger.c b/drivers/power/supply/bq24190_charger.c
index 845af0f44c02..8c3c378dce0d 100644
--- a/drivers/power/supply/bq24190_charger.c
+++ b/drivers/power/supply/bq24190_charger.c
@@ -41,6 +41,7 @@
 #define BQ24190_REG_POC_CHG_CONFIG_DISABLE		0x0
 #define BQ24190_REG_POC_CHG_CONFIG_CHARGE		0x1
 #define BQ24190_REG_POC_CHG_CONFIG_OTG			0x2
+#define BQ24190_REG_POC_CHG_CONFIG_OTG_ALT		0x3
 #define BQ24190_REG_POC_SYS_MIN_MASK		(BIT(3) | BIT(2) | BIT(1))
 #define BQ24190_REG_POC_SYS_MIN_SHIFT		1
 #define BQ24190_REG_POC_SYS_MIN_MIN			3000
@@ -552,7 +553,11 @@ static int bq24190_vbus_is_enabled(struct regulator_dev *dev)
 	pm_runtime_mark_last_busy(bdi->dev);
 	pm_runtime_put_autosuspend(bdi->dev);
 
-	return ret ? ret : val == BQ24190_REG_POC_CHG_CONFIG_OTG;
+	if (ret)
+		return ret;
+
+	return (val == BQ24190_REG_POC_CHG_CONFIG_OTG ||
+		val == BQ24190_REG_POC_CHG_CONFIG_OTG_ALT);
 }
 
 static const struct regulator_ops bq24190_vbus_ops = {
-- 
2.34.1



