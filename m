Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA9C1639B47
	for <lists+stable@lfdr.de>; Sun, 27 Nov 2022 15:13:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbiK0ONM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Nov 2022 09:13:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiK0ONL (ORCPT
        <rfc822;Stable@vger.kernel.org>); Sun, 27 Nov 2022 09:13:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B77E114F
        for <Stable@vger.kernel.org>; Sun, 27 Nov 2022 06:13:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED75BB80AF9
        for <Stable@vger.kernel.org>; Sun, 27 Nov 2022 14:13:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 430E8C433C1;
        Sun, 27 Nov 2022 14:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669558387;
        bh=DIxao4YNDGPAhCm/rwfZB/8T6aX5/tPzBseyI9jUC2I=;
        h=Subject:To:From:Date:From;
        b=n9+pNXG2syGgzd2G1zU3VgkOJpCrK/QoQUFLdsL9zKnmCzHbnZrVrrwffd0PHanz9
         WtSjH3VK1e2s1ZGIwKHG7HCw7n9BxPMapci8BaLZAF+O9YAlmlmCGA6ANYYmrbobF0
         Sr7vDYffRI4mdNrSZIzJVJVekToa1M2uC2XXkdVs=
Subject: patch "iio: light: apds9960: fix wrong register for gesture gain" added to char-misc-next
To:     asconcepcion@acoro.eu, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, matt.ranostay@konsulko.com
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 27 Nov 2022 15:06:06 +0100
Message-ID: <16695579661441@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: light: apds9960: fix wrong register for gesture gain

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 0aa60ff5d996d4ecdd4a62699c01f6d00f798d59 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Alejandro=20Concepci=C3=B3n=20Rodr=C3=ADguez?=
 <asconcepcion@acoro.eu>
Date: Sun, 6 Nov 2022 01:56:51 +0000
Subject: iio: light: apds9960: fix wrong register for gesture gain

Gesture Gain Control is in REG_GCONF_2 (0xa3), not in REG_CONFIG_2 (0x90).

Fixes: aff268cd532e ("iio: light: add APDS9960 ALS + promixity driver")
Signed-off-by: Alejandro Concepcion-Rodriguez <asconcepcion@acoro.eu>
Acked-by: Matt Ranostay <matt.ranostay@konsulko.com>
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/EaT-NKC-H4DNX5z4Lg9B6IWPD5TrTrYBr5DYB784wfDKQkTmzPXkoYqyUOrOgJH-xvTsEkFLcVkeAPZRUODEFI5dGziaWXwjpfBNLeNGfNc=@acoro.eu
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/light/apds9960.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/iio/light/apds9960.c b/drivers/iio/light/apds9960.c
index b62c139baf41..38d4c7644bef 100644
--- a/drivers/iio/light/apds9960.c
+++ b/drivers/iio/light/apds9960.c
@@ -54,9 +54,6 @@
 #define APDS9960_REG_CONTROL_PGAIN_MASK_SHIFT	2
 
 #define APDS9960_REG_CONFIG_2	0x90
-#define APDS9960_REG_CONFIG_2_GGAIN_MASK	0x60
-#define APDS9960_REG_CONFIG_2_GGAIN_MASK_SHIFT	5
-
 #define APDS9960_REG_ID		0x92
 
 #define APDS9960_REG_STATUS	0x93
@@ -77,6 +74,9 @@
 #define APDS9960_REG_GCONF_1_GFIFO_THRES_MASK_SHIFT	6
 
 #define APDS9960_REG_GCONF_2	0xa3
+#define APDS9960_REG_GCONF_2_GGAIN_MASK			0x60
+#define APDS9960_REG_GCONF_2_GGAIN_MASK_SHIFT		5
+
 #define APDS9960_REG_GOFFSET_U	0xa4
 #define APDS9960_REG_GOFFSET_D	0xa5
 #define APDS9960_REG_GPULSE	0xa6
@@ -396,9 +396,9 @@ static int apds9960_set_pxs_gain(struct apds9960_data *data, int val)
 			}
 
 			ret = regmap_update_bits(data->regmap,
-				APDS9960_REG_CONFIG_2,
-				APDS9960_REG_CONFIG_2_GGAIN_MASK,
-				idx << APDS9960_REG_CONFIG_2_GGAIN_MASK_SHIFT);
+				APDS9960_REG_GCONF_2,
+				APDS9960_REG_GCONF_2_GGAIN_MASK,
+				idx << APDS9960_REG_GCONF_2_GGAIN_MASK_SHIFT);
 			if (!ret)
 				data->pxs_gain = idx;
 			mutex_unlock(&data->lock);
-- 
2.38.1


