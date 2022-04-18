Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27E4B505523
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241408AbiDRNZC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:25:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241494AbiDRNX5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:23:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B21513D4B5;
        Mon, 18 Apr 2022 05:52:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4396DB80EC0;
        Mon, 18 Apr 2022 12:52:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A98E6C385A1;
        Mon, 18 Apr 2022 12:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650286369;
        bh=T97bYP5P7iu39kdTLx5OIaN6WD5k29ziQ0v41fmvI0k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g2JtTE5ipwOR/RSxBZPwpRmyhJ1zWLN4VGN7EFTWxSgcLH66UCzJxypQ1RkIiKKOk
         nCNn540iyXOiFLI47xIRES4rd2tWwuBmd0A05r6c7sTyVDX3QnFAvs+Ya+dHFIYLQ8
         P9LuJzpedZup7VXu7pT66mrkimJkekL8feqWMAGE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bastien Nocera <hadess@hadess.net>,
        Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 112/284] power: supply: bq24190_charger: Fix bq24190_vbus_is_enabled() wrong false return
Date:   Mon, 18 Apr 2022 14:11:33 +0200
Message-Id: <20220418121214.154504397@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121210.689577360@linuxfoundation.org>
References: <20220418121210.689577360@linuxfoundation.org>
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
index 0906f6b562bc..32bd28f68983 100644
--- a/drivers/power/supply/bq24190_charger.c
+++ b/drivers/power/supply/bq24190_charger.c
@@ -44,6 +44,7 @@
 #define BQ24190_REG_POC_CHG_CONFIG_DISABLE		0x0
 #define BQ24190_REG_POC_CHG_CONFIG_CHARGE		0x1
 #define BQ24190_REG_POC_CHG_CONFIG_OTG			0x2
+#define BQ24190_REG_POC_CHG_CONFIG_OTG_ALT		0x3
 #define BQ24190_REG_POC_SYS_MIN_MASK		(BIT(3) | BIT(2) | BIT(1))
 #define BQ24190_REG_POC_SYS_MIN_SHIFT		1
 #define BQ24190_REG_POC_SYS_MIN_MIN			3000
@@ -572,7 +573,11 @@ static int bq24190_vbus_is_enabled(struct regulator_dev *dev)
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



