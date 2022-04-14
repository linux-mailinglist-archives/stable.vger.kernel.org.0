Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D37250122A
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244707AbiDNNhq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:37:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244626AbiDNN1v (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:27:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7E83A2061;
        Thu, 14 Apr 2022 06:20:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65D76B82985;
        Thu, 14 Apr 2022 13:20:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACB79C385A9;
        Thu, 14 Apr 2022 13:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649942438;
        bh=McLg5ljU88naHu06xQFkcxJXg/8T/W6NCQIW5jatmUM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j0OILCglb4M0/+4zTQGxc6UGqgGoKH1R0v+HvPhjXkLeq6WWJxDvyG8TuicWkcsMh
         N1Db7y7FQzsj4u2ECmprXMnmeYm47Jlx/hs7rqwhauaPdLrBdXvWcn+Vz+2vgQOc1Y
         H9stESKere8P5aKZpe4/wgPVhodZu3mijBd5oP0Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bastien Nocera <hadess@hadess.net>,
        Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 136/338] power: supply: bq24190_charger: Fix bq24190_vbus_is_enabled() wrong false return
Date:   Thu, 14 Apr 2022 15:10:39 +0200
Message-Id: <20220414110842.778897912@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110838.883074566@linuxfoundation.org>
References: <20220414110838.883074566@linuxfoundation.org>
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
index 863208928cf0..c830343be61e 100644
--- a/drivers/power/supply/bq24190_charger.c
+++ b/drivers/power/supply/bq24190_charger.c
@@ -43,6 +43,7 @@
 #define BQ24190_REG_POC_CHG_CONFIG_DISABLE		0x0
 #define BQ24190_REG_POC_CHG_CONFIG_CHARGE		0x1
 #define BQ24190_REG_POC_CHG_CONFIG_OTG			0x2
+#define BQ24190_REG_POC_CHG_CONFIG_OTG_ALT		0x3
 #define BQ24190_REG_POC_SYS_MIN_MASK		(BIT(3) | BIT(2) | BIT(1))
 #define BQ24190_REG_POC_SYS_MIN_SHIFT		1
 #define BQ24190_REG_POC_SYS_MIN_MIN			3000
@@ -568,7 +569,11 @@ static int bq24190_vbus_is_enabled(struct regulator_dev *dev)
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



