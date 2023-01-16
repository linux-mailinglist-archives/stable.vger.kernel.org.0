Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B067166C48B
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 16:56:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231325AbjAPP4F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 10:56:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231435AbjAPPzw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 10:55:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A0EA22DD9
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 07:55:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 09C00B8105C
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 15:55:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60BEFC433D2;
        Mon, 16 Jan 2023 15:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884547;
        bh=Og5l1J0HC6clakpJKy4jhVtz1hPiL5RIlcG0oBCbxqM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ocI3qJXnKDwALZQoVoaeePWbSMZcOU9jF2st+Dpz2k+KmsGj10l2SNM/3wCtdZDak
         ETYNc0kboI1hJ1Gk0z6WNscBFtKP3qGSuboJg2vIaMEO958ooAswTtYAyg38qN9RQs
         Wc7Of94l2nmkXqZT0JPhxO1QUa63ShRYYDU+Pm4U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andy@kernel.org>,
        Daniel Scally <djrscally@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 6.1 048/183] platform/x86: int3472/discrete: Ensure the clk/power enable pins are in output mode
Date:   Mon, 16 Jan 2023 16:49:31 +0100
Message-Id: <20230116154805.383872985@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
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

From: Hans de Goede <hdegoede@redhat.com>

commit cf5ac2d45f6e4d11ad78e7b10ae9a4121ba5e995 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/intel/int3472/clk_and_regulator.c |    3 +++
 drivers/platform/x86/intel/int3472/discrete.c          |    4 ++++
 2 files changed, 7 insertions(+)

--- a/drivers/platform/x86/intel/int3472/clk_and_regulator.c
+++ b/drivers/platform/x86/intel/int3472/clk_and_regulator.c
@@ -181,6 +181,9 @@ int skl_int3472_register_regulator(struc
 		return PTR_ERR(int3472->regulator.gpio);
 	}
 
+	/* Ensure the pin is in output mode and non-active state */
+	gpiod_direction_output(int3472->regulator.gpio, 0);
+
 	cfg.dev = &int3472->adev->dev;
 	cfg.init_data = &init_data;
 	cfg.ena_gpiod = int3472->regulator.gpio;
--- a/drivers/platform/x86/intel/int3472/discrete.c
+++ b/drivers/platform/x86/intel/int3472/discrete.c
@@ -168,6 +168,8 @@ static int skl_int3472_map_gpio_to_clk(s
 			return (PTR_ERR(gpio));
 
 		int3472->clock.ena_gpio = gpio;
+		/* Ensure the pin is in output mode and non-active state */
+		gpiod_direction_output(int3472->clock.ena_gpio, 0);
 		break;
 	case INT3472_GPIO_TYPE_PRIVACY_LED:
 		gpio = acpi_get_and_request_gpiod(path, pin, "int3472,privacy-led");
@@ -175,6 +177,8 @@ static int skl_int3472_map_gpio_to_clk(s
 			return (PTR_ERR(gpio));
 
 		int3472->clock.led_gpio = gpio;
+		/* Ensure the pin is in output mode and non-active state */
+		gpiod_direction_output(int3472->clock.led_gpio, 0);
 		break;
 	default:
 		dev_err(int3472->dev, "Invalid GPIO type 0x%02x for clock\n", type);


