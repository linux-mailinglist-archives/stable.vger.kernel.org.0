Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45B2164323A
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:25:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230246AbiLETZv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:25:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233925AbiLETZQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:25:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 242BA25EB6
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:20:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB82AB81151
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:20:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33948C433C1;
        Mon,  5 Dec 2022 19:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268040;
        bh=Nstu9m7AgV9PUAhOtNwLwniEQ2Gp17D3D4HrTFCEAaA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KULx42ZDgW+BsTLi9TE0yMWRwRcGDpaAIe9hDbQ+HAdGYZgJnjpb3e8euQ93S3AV5
         BTYxH24xa0pt4qD/J8x8UCHxIRKsS2NYv0mrL2ac2xPJVE8LKz6XRRyC2anghNIotW
         lLzmsU8lx7owetgqNsCBFLSPDPhah0eCWrU2cyDo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Alejandro Concepcion-Rodriguez <asconcepcion@acoro.eu>,
        Matt Ranostay <matt.ranostay@konsulko.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.19 036/105] iio: light: apds9960: fix wrong register for gesture gain
Date:   Mon,  5 Dec 2022 20:09:08 +0100
Message-Id: <20221205190804.359730670@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190803.124472741@linuxfoundation.org>
References: <20221205190803.124472741@linuxfoundation.org>
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

From: Alejandro Concepción Rodríguez <asconcepcion@acoro.eu>

commit 0aa60ff5d996d4ecdd4a62699c01f6d00f798d59 upstream.

Gesture Gain Control is in REG_GCONF_2 (0xa3), not in REG_CONFIG_2 (0x90).

Fixes: aff268cd532e ("iio: light: add APDS9960 ALS + promixity driver")
Signed-off-by: Alejandro Concepcion-Rodriguez <asconcepcion@acoro.eu>
Acked-by: Matt Ranostay <matt.ranostay@konsulko.com>
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/EaT-NKC-H4DNX5z4Lg9B6IWPD5TrTrYBr5DYB784wfDKQkTmzPXkoYqyUOrOgJH-xvTsEkFLcVkeAPZRUODEFI5dGziaWXwjpfBNLeNGfNc=@acoro.eu
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/apds9960.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/iio/light/apds9960.c
+++ b/drivers/iio/light/apds9960.c
@@ -55,9 +55,6 @@
 #define APDS9960_REG_CONTROL_PGAIN_MASK_SHIFT	2
 
 #define APDS9960_REG_CONFIG_2	0x90
-#define APDS9960_REG_CONFIG_2_GGAIN_MASK	0x60
-#define APDS9960_REG_CONFIG_2_GGAIN_MASK_SHIFT	5
-
 #define APDS9960_REG_ID		0x92
 
 #define APDS9960_REG_STATUS	0x93
@@ -78,6 +75,9 @@
 #define APDS9960_REG_GCONF_1_GFIFO_THRES_MASK_SHIFT	6
 
 #define APDS9960_REG_GCONF_2	0xa3
+#define APDS9960_REG_GCONF_2_GGAIN_MASK			0x60
+#define APDS9960_REG_GCONF_2_GGAIN_MASK_SHIFT		5
+
 #define APDS9960_REG_GOFFSET_U	0xa4
 #define APDS9960_REG_GOFFSET_D	0xa5
 #define APDS9960_REG_GPULSE	0xa6
@@ -396,9 +396,9 @@ static int apds9960_set_pxs_gain(struct
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


