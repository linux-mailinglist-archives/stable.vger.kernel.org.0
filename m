Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B27B46581A0
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:30:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234410AbiL1QaK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:30:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234439AbiL1Q3s (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:29:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 180F51A07D
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:26:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C602FB8171E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:26:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 370AFC433EF;
        Wed, 28 Dec 2022 16:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244764;
        bh=xJmIZES7AHgJ86zvjlr3EmsXBGWYcZ8YuKr18CqoSxU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mk5VjORCHtwGvMBNvXXjPSOoq4hmYJkumhCqgZwbcL+QCalJbd97U/scpLhYMy7Ft
         1l0oKSA5hT4MdG2F6iwathHsm+G39JLkM96HR+b8fnr1X6uniHP3d2Bro3PY1vCsXe
         JRgvjycNmly3tGcJfNjUIXbXCWMjvsexbObC5Pvw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0752/1073] power: supply: bq25890: Convert to i2cs .probe_new()
Date:   Wed, 28 Dec 2022 15:39:00 +0100
Message-Id: <20221228144348.445653495@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit c5cddca2351b291c8787b45cd046b1dfeb86979f ]

The probe function doesn't make use of the i2c_device_id * parameter so it
can be trivially converted.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Stable-dep-of: a7aaa80098d5 ("power: supply: bq25890: Ensure pump_express_work is cancelled on remove")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/bq25890_charger.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/power/supply/bq25890_charger.c b/drivers/power/supply/bq25890_charger.c
index 86228753e804..b4c8481ea17b 100644
--- a/drivers/power/supply/bq25890_charger.c
+++ b/drivers/power/supply/bq25890_charger.c
@@ -1189,8 +1189,7 @@ static int bq25890_fw_probe(struct bq25890_device *bq)
 	return 0;
 }
 
-static int bq25890_probe(struct i2c_client *client,
-			 const struct i2c_device_id *id)
+static int bq25890_probe(struct i2c_client *client)
 {
 	struct device *dev = &client->dev;
 	struct bq25890_device *bq;
@@ -1391,7 +1390,7 @@ static struct i2c_driver bq25890_driver = {
 		.acpi_match_table = ACPI_PTR(bq25890_acpi_match),
 		.pm = &bq25890_pm,
 	},
-	.probe = bq25890_probe,
+	.probe_new = bq25890_probe,
 	.remove = bq25890_remove,
 	.shutdown = bq25890_shutdown,
 	.id_table = bq25890_i2c_ids,
-- 
2.35.1



