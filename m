Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 445236DEDF3
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbjDLIim (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:38:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230320AbjDLIi2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:38:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 895DB8A74
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:37:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AADD462FE7
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:35:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE3B6C433D2;
        Wed, 12 Apr 2023 08:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681288535;
        bh=yTNLAF/N82RWqW09CItoj+J4UBdtT8qT2Cp4fGF6yP4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NuPtg8VI3peHG2AIqKU7XU4yBkTNYypbq/26Vp40+a2wnZl7dTslvCcIHosal+Kmp
         T8UXBNAgX7/t+dmoOlDuS8S6Vj3+Yp0nfoTgNGE2nBD72kGGsgGQskWH/W3oQgIZQY
         UFX0KvPsi9+Ey6Sm1z4KIRUCl+1x+7WY8/ZyYWek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andy@kernel.org>,
        Daniel Scally <djrscally@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 15/93] platform/x86: int3472/discrete: Ensure the clk/power enable pins are in output mode
Date:   Wed, 12 Apr 2023 10:33:16 +0200
Message-Id: <20230412082823.688521197@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082823.045155996@linuxfoundation.org>
References: <20230412082823.045155996@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit cf5ac2d45f6e4d11ad78e7b10ae9a4121ba5e995 ]

acpi_get_and_request_gpiod() does not take a gpio_lookup_flags argument
specifying that the pins direction should be initialized to a specific
value.

This means that in some cases the pins might be left in input mode, causing
the gpiod_set() calls made to enable the clk / regulator to not work.

One example of this problem is the clk-enable GPIO for the ov01a1s sensor
on a Dell Latitude 9420 being left in input mode causing the clk to
never get enabled.

Explicitly set the direction of the pins to output to fix this.

Fixes: 5de691bffe57 ("platform/x86: Add intel_skl_int3472 driver")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Reviewed-by: Daniel Scally <djrscally@gmail.com>
Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Link: https://lore.kernel.org/r/20230111201426.947853-1-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/int3472/clk_and_regulator.c | 3 +++
 drivers/platform/x86/intel/int3472/discrete.c          | 4 ++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/platform/x86/intel/int3472/clk_and_regulator.c b/drivers/platform/x86/intel/int3472/clk_and_regulator.c
index 1cf958983e868..28353addffa7f 100644
--- a/drivers/platform/x86/intel/int3472/clk_and_regulator.c
+++ b/drivers/platform/x86/intel/int3472/clk_and_regulator.c
@@ -181,6 +181,9 @@ int skl_int3472_register_regulator(struct int3472_discrete_device *int3472,
 		return PTR_ERR(int3472->regulator.gpio);
 	}
 
+	/* Ensure the pin is in output mode and non-active state */
+	gpiod_direction_output(int3472->regulator.gpio, 0);
+
 	cfg.dev = &int3472->adev->dev;
 	cfg.init_data = &init_data;
 	cfg.ena_gpiod = int3472->regulator.gpio;
diff --git a/drivers/platform/x86/intel/int3472/discrete.c b/drivers/platform/x86/intel/int3472/discrete.c
index d2e8a87a077e7..401fa8f223d62 100644
--- a/drivers/platform/x86/intel/int3472/discrete.c
+++ b/drivers/platform/x86/intel/int3472/discrete.c
@@ -169,6 +169,8 @@ static int skl_int3472_map_gpio_to_clk(struct int3472_discrete_device *int3472,
 			return (PTR_ERR(gpio));
 
 		int3472->clock.ena_gpio = gpio;
+		/* Ensure the pin is in output mode and non-active state */
+		gpiod_direction_output(int3472->clock.ena_gpio, 0);
 		break;
 	case INT3472_GPIO_TYPE_PRIVACY_LED:
 		gpio = acpi_get_and_request_gpiod(path, pin, "int3472,privacy-led");
@@ -176,6 +178,8 @@ static int skl_int3472_map_gpio_to_clk(struct int3472_discrete_device *int3472,
 			return (PTR_ERR(gpio));
 
 		int3472->clock.led_gpio = gpio;
+		/* Ensure the pin is in output mode and non-active state */
+		gpiod_direction_output(int3472->clock.led_gpio, 0);
 		break;
 	default:
 		dev_err(int3472->dev, "Invalid GPIO type 0x%02x for clock\n", type);
-- 
2.39.2



