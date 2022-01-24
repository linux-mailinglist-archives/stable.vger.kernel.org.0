Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DDDE49A51C
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:11:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2370646AbiAYAFt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:05:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1850701AbiAXXah (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:30:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13DDAC07595C;
        Mon, 24 Jan 2022 13:35:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CAFD2B80CCF;
        Mon, 24 Jan 2022 21:35:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BC8AC340E4;
        Mon, 24 Jan 2022 21:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060106;
        bh=2XYLbk5nhzUYg8pfk+MC07Cy/191v7DzF5yYA5/9A2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2crNjcGraS2Qb0DqyzfY9o22BuSUa545pUfqggfpIhAijd6Lan9nnXq0mbwOmWyVN
         Ubts6YHatFNcvhZWstCpw1MGJPikvjQFdQNReaEgEe0MzuvLJnrfKlHL4/fpFLWa/R
         FR7dibf5rT6e4mal/qpTmgXkVoQyLk68QWWuO8sw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Osipenko <digetx@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Svyatoslav Ryhel <clamor95@gmail.com>
Subject: [PATCH 5.16 0842/1039] mfd: tps65910: Set PWR_OFF bit during driver probe
Date:   Mon, 24 Jan 2022 19:43:51 +0100
Message-Id: <20220124184153.596841349@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

commit 7620ad0bdfac1efff4a1228cd36ae62a9d8206b0 upstream.

The PWR_OFF bit needs to be set in order to power off properly, without
hanging PMIC. This bit needs to be set early in order to allow thermal
protection of NVIDIA Terga SoCs to power off hardware properly, otherwise
a battery re-plug may be needed on some devices to recover after the hang.

Cc: <stable@vger.kernel.org>
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Tested-by: Svyatoslav Ryhel <clamor95@gmail.com> # ASUS TF201
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Link: https://lore.kernel.org/r/20211124190104.23554-1-digetx@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mfd/tps65910.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

--- a/drivers/mfd/tps65910.c
+++ b/drivers/mfd/tps65910.c
@@ -436,15 +436,6 @@ static void tps65910_power_off(void)
 
 	tps65910 = dev_get_drvdata(&tps65910_i2c_client->dev);
 
-	/*
-	 * The PWR_OFF bit needs to be set separately, before transitioning
-	 * to the OFF state. It enables the "sequential" power-off mode on
-	 * TPS65911, it's a NO-OP on TPS65910.
-	 */
-	if (regmap_set_bits(tps65910->regmap, TPS65910_DEVCTRL,
-			    DEVCTRL_PWR_OFF_MASK) < 0)
-		return;
-
 	regmap_update_bits(tps65910->regmap, TPS65910_DEVCTRL,
 			   DEVCTRL_DEV_OFF_MASK | DEVCTRL_DEV_ON_MASK,
 			   DEVCTRL_DEV_OFF_MASK);
@@ -504,6 +495,19 @@ static int tps65910_i2c_probe(struct i2c
 	tps65910_sleepinit(tps65910, pmic_plat_data);
 
 	if (pmic_plat_data->pm_off && !pm_power_off) {
+		/*
+		 * The PWR_OFF bit needs to be set separately, before
+		 * transitioning to the OFF state. It enables the "sequential"
+		 * power-off mode on TPS65911, it's a NO-OP on TPS65910.
+		 */
+		ret = regmap_set_bits(tps65910->regmap, TPS65910_DEVCTRL,
+				      DEVCTRL_PWR_OFF_MASK);
+		if (ret) {
+			dev_err(&i2c->dev, "failed to set power-off mode: %d\n",
+				ret);
+			return ret;
+		}
+
 		tps65910_i2c_client = i2c;
 		pm_power_off = tps65910_power_off;
 	}


