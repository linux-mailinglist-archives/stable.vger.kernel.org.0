Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7668163DDF6
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:32:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbiK3ScT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:32:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230154AbiK3ScS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:32:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3BC28D660
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:32:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82C2AB81C9C
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:32:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5A9CC433C1;
        Wed, 30 Nov 2022 18:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833135;
        bh=yo4vx89wcKuh+ZbIVTuXWYGqPrrUOxpS8eEJxC3Dpec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NkW9S7xbr6QWewjrTaqEcss43j/OfMzvCvvRYT8W46yEBBgTfexYelyykkRp76lDl
         DOmr4Nbd1uiSBik7qpXgWTYCnxGQOUgcN5+vzMciIMLGbRL8hvZjQdZ5oJIKGri/vA
         YVR1OwtQl/ZnKIew7h7W+pimlsFtY5S+3tVNhH8Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 135/162] Input: soc_button_array - add use_low_level_irq module parameter
Date:   Wed, 30 Nov 2022 19:23:36 +0100
Message-Id: <20221130180532.145884988@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180528.466039523@linuxfoundation.org>
References: <20221130180528.466039523@linuxfoundation.org>
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

[ Upstream commit 8e9ada1d0e72b4737df400fe1bba48dc42a68df7 ]

It seems that the Windows drivers for the ACPI0011 soc_button_array
device use low level triggered IRQs rather then using edge triggering.

Some ACPI tables depend on this, directly poking the GPIO controller's
registers to clear the trigger type when closing a laptop's/2-in-1's lid
and re-instating the trigger when opening the lid again.

Linux sets the edge/level on which to trigger to both low+high since
it is using edge type IRQs, the ACPI tables then ends up also setting
the bit for level IRQs and since both low and high level have been
selected by Linux we get an IRQ storm leading to soft lockups.

As a workaround for this the soc_button_array already contains
a DMI quirk table with device models known to have this issue.

Add a module parameter for this so that users can easily test if their
device is affected too and so that they can use the module parameter
as a workaround.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20221106215320.67109-1-hdegoede@redhat.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/misc/soc_button_array.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/input/misc/soc_button_array.c b/drivers/input/misc/soc_button_array.c
index efffcf0ebd3b..46ba8218de99 100644
--- a/drivers/input/misc/soc_button_array.c
+++ b/drivers/input/misc/soc_button_array.c
@@ -18,6 +18,10 @@
 #include <linux/gpio.h>
 #include <linux/platform_device.h>
 
+static bool use_low_level_irq;
+module_param(use_low_level_irq, bool, 0444);
+MODULE_PARM_DESC(use_low_level_irq, "Use low-level triggered IRQ instead of edge triggered");
+
 struct soc_button_info {
 	const char *name;
 	int acpi_index;
@@ -164,7 +168,8 @@ soc_button_device_create(struct platform_device *pdev,
 		}
 
 		/* See dmi_use_low_level_irq[] comment */
-		if (!autorepeat && dmi_check_system(dmi_use_low_level_irq)) {
+		if (!autorepeat && (use_low_level_irq ||
+				    dmi_check_system(dmi_use_low_level_irq))) {
 			irq_set_irq_type(irq, IRQ_TYPE_LEVEL_LOW);
 			gpio_keys[n_buttons].irq = irq;
 			gpio_keys[n_buttons].gpio = -ENOENT;
-- 
2.35.1



