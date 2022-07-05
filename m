Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16428566E1E
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:32:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237980AbiGEMbV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:31:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237970AbiGEM0l (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:26:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 788DE18B0F;
        Tue,  5 Jul 2022 05:18:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0F6C9619A6;
        Tue,  5 Jul 2022 12:18:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20889C341C8;
        Tue,  5 Jul 2022 12:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023521;
        bh=7eSYT7N3ayyrH9XNJ1R/bpLYGxNrzCHEYGnIXXeS2Mc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y/VLBsDjFKyx5oeIl7oHLGHY2rOMmnzffyQvM8/R7iajjC7J3qNLtdK67Ilx8i7Ii
         Xq2vkIqKpxYYobC7pV4VZ/N3MC3cWt/85xYvD/i9r4T05KIPIvBqcUhkh1ldiYXA4O
         msEanKL7HN7JH4WmOr88gBaKiFGTJm/Fwn83djM8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>,
        Stefan Seyfried <seife+kernel@b1-systems.com>,
        Kenneth Chan <kenneth.t.chan@gmail.com>
Subject: [PATCH 5.18 091/102] platform/x86: panasonic-laptop: dont report duplicate brightness key-presses
Date:   Tue,  5 Jul 2022 13:58:57 +0200
Message-Id: <20220705115621.005354496@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115618.410217782@linuxfoundation.org>
References: <20220705115618.410217782@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 1f2c9de83a50447a2d7166f6273ab0c0e97cd68e ]

The brightness key-presses might also get reported by the ACPI video bus,
check for this and in this case don't report the presses to avoid reporting
2 presses for a single key-press.

Fixes: ed83c9171829 ("platform/x86: panasonic-laptop: Resolve hotkey double trigger bug")
Reported-and-tested-by: Stefan Seyfried <seife+kernel@b1-systems.com>
Reported-and-tested-by: Kenneth Chan <kenneth.t.chan@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20220624112340.10130-6-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/Kconfig            | 1 +
 drivers/platform/x86/panasonic-laptop.c | 8 ++++++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 5d9dd70e4e0f..634a6c1eb2d3 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -945,6 +945,7 @@ config PANASONIC_LAPTOP
 	tristate "Panasonic Laptop Extras"
 	depends on INPUT && ACPI
 	depends on BACKLIGHT_CLASS_DEVICE
+	depends on ACPI_VIDEO=n || ACPI_VIDEO
 	select INPUT_SPARSEKMAP
 	help
 	  This driver adds support for access to backlight control and hotkeys
diff --git a/drivers/platform/x86/panasonic-laptop.c b/drivers/platform/x86/panasonic-laptop.c
index 2e6531dd15f9..d65e6c2372ca 100644
--- a/drivers/platform/x86/panasonic-laptop.c
+++ b/drivers/platform/x86/panasonic-laptop.c
@@ -132,6 +132,7 @@
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/uaccess.h>
+#include <acpi/video.h>
 
 MODULE_AUTHOR("Hiroshi Miura <miura@da-cha.org>");
 MODULE_AUTHOR("David Bronaugh <dbronaugh@linuxboxen.org>");
@@ -783,6 +784,13 @@ static void acpi_pcc_generate_keyinput(struct pcc_acpi *pcc)
 					key, 0x80, false);
 	}
 
+	/*
+	 * Don't report brightness key-presses if they are also reported
+	 * by the ACPI video bus.
+	 */
+	if ((key == 1 || key == 2) && acpi_video_handles_brightness_key_presses())
+		return;
+
 	if (!sparse_keymap_report_event(hotk_input_dev, key, updown, false))
 		pr_err("Unknown hotkey event: 0x%04llx\n", result);
 }
-- 
2.35.1



