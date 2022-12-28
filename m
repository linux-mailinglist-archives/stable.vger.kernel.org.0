Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35816658246
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:34:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234816AbiL1Qe0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:34:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234909AbiL1QeC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:34:02 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4430C1C933
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:31:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5558FCE134F
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:31:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44A58C433D2;
        Wed, 28 Dec 2022 16:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245082;
        bh=EburepUz3/VPm54H9JLafbIA0MJZRjiFiR4eFeT2XS0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ht3zW+qEQ+BXv57zjnq3AhNhAf162vxfMRJgUQMeFLgcM8CBtQ1MCqkZQ8xJSFm87
         CQw2aEGCzzLQwjxTvaYXZ+sRgtVf2pECobE4goUqet0UE5OomICq4XwWy7m7JBaYkn
         ZgPSiu7H05PTwQgazTrFl1JhsJeS5zwTdEXhZK7Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Luca Weiss <luca@z3ntu.xyz>,
        Vincent Knecht <vincent.knecht@mailoo.org>,
        Pavel Machek <pavel@ucw.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0785/1146] leds: is31fl319x: Fix setting current limit for is31fl319{0,1,3}
Date:   Wed, 28 Dec 2022 15:38:44 +0100
Message-Id: <20221228144351.469436187@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Luca Weiss <luca@z3ntu.xyz>

[ Upstream commit 135780f1048b3f956f5b10bb23dec9c2d2c4ef6d ]

The current setting lives in bits 4:2 (as also defined by the mask) but
the current limit defines in the driver use bits 2:0 which should be
shifted over so they don't get masked out completely (except for 17.5mA
which became 10mA).

Now checking /sys/kernel/debug/regmap/1-0068/registers shows that the
current limit is applied correctly and doesn't take the default b000 =
42mA.

Fixes: fa877cf1abb9 ("leds: is31fl319x: Add support for is31fl319{0,1,3} chips")
Signed-off-by: Luca Weiss <luca@z3ntu.xyz>
Reviewed-by: Vincent Knecht <vincent.knecht@mailoo.org>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-is31fl319x.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/leds/leds-is31fl319x.c b/drivers/leds/leds-is31fl319x.c
index 52b59b62f437..b2f4c4ec7c56 100644
--- a/drivers/leds/leds-is31fl319x.c
+++ b/drivers/leds/leds-is31fl319x.c
@@ -38,6 +38,7 @@
 #define IS31FL3190_CURRENT_uA_MIN	5000
 #define IS31FL3190_CURRENT_uA_DEFAULT	42000
 #define IS31FL3190_CURRENT_uA_MAX	42000
+#define IS31FL3190_CURRENT_SHIFT	2
 #define IS31FL3190_CURRENT_MASK		GENMASK(4, 2)
 #define IS31FL3190_CURRENT_5_mA		0x02
 #define IS31FL3190_CURRENT_10_mA	0x01
@@ -553,7 +554,7 @@ static int is31fl319x_probe(struct i2c_client *client)
 			     is31fl3196_db_to_gain(is31->audio_gain_db));
 	else
 		regmap_update_bits(is31->regmap, IS31FL3190_CURRENT, IS31FL3190_CURRENT_MASK,
-				   is31fl3190_microamp_to_cs(dev, aggregated_led_microamp));
+				   is31fl3190_microamp_to_cs(dev, aggregated_led_microamp) << IS31FL3190_CURRENT_SHIFT);
 
 	for (i = 0; i < is31->cdef->num_leds; i++) {
 		struct is31fl319x_led *led = &is31->leds[i];
-- 
2.35.1



