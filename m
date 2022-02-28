Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5DB64C739A
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:36:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238276AbiB1Rgw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:36:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238280AbiB1Rg0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:36:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FFA29681E;
        Mon, 28 Feb 2022 09:31:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1AAACB815AB;
        Mon, 28 Feb 2022 17:31:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EA00C340F3;
        Mon, 28 Feb 2022 17:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069500;
        bh=0uozSdYEpm4wPeKQjXI6P7p2CNOcuYuCBw5SCjpmGnI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rg072FYeCZojlFw5guDixWR1d7DexwJ53guKPe24FNLXUQLq3LzQNlrtD/bnt2pAE
         asZk374rCqfi6xwxnDiqrxi+aMW3qKBqyb0f+yEhSC7UReJ6TLQj5cpxkRwIP+6t2Z
         iMRH2M7PJ3ELvFfOhiHvCnkNP8t48qaGlmddnE0Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 5.4 43/53] usb: dwc3: pci: Fix Bay Trail phy GPIO mappings
Date:   Mon, 28 Feb 2022 18:24:41 +0100
Message-Id: <20220228172251.430271739@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172248.232273337@linuxfoundation.org>
References: <20220228172248.232273337@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit 62e3f0afe246720f7646eb1b034a6897dac34405 upstream.

When the Bay Trail phy GPIO mappings where added cs and reset were swapped,
this did not cause any issues sofar, because sofar they were always driven
high/low at the same time.

Note the new mapping has been verified both in /sys/kernel/debug/gpio
output on Android factory images on multiple devices, as well as in
the schematics for some devices.

Fixes: 5741022cbdf3 ("usb: dwc3: pci: Add GPIO lookup table on platforms without ACPI GPIO resources")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20220213130524.18748-3-hdegoede@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-pci.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -81,8 +81,8 @@ static const struct acpi_gpio_mapping ac
 static struct gpiod_lookup_table platform_bytcr_gpios = {
 	.dev_id		= "0000:00:16.0",
 	.table		= {
-		GPIO_LOOKUP("INT33FC:00", 54, "reset", GPIO_ACTIVE_HIGH),
-		GPIO_LOOKUP("INT33FC:02", 14, "cs", GPIO_ACTIVE_HIGH),
+		GPIO_LOOKUP("INT33FC:00", 54, "cs", GPIO_ACTIVE_HIGH),
+		GPIO_LOOKUP("INT33FC:02", 14, "reset", GPIO_ACTIVE_HIGH),
 		{}
 	},
 };


