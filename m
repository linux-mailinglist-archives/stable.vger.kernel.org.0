Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70F934B3C2A
	for <lists+stable@lfdr.de>; Sun, 13 Feb 2022 16:49:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbiBMPtp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Feb 2022 10:49:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236892AbiBMPtp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Feb 2022 10:49:45 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 240AB5F8D5;
        Sun, 13 Feb 2022 07:49:37 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id v12so23189763wrv.2;
        Sun, 13 Feb 2022 07:49:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WNt7w3V3r3XNyd6E3pkmZ4MDV9Ukbbrto5tyyCRol2g=;
        b=crwz8kC/spj9IHbvPYlFelG45aPhfgV+0sxfTw18LVzsY/xwnBTeLNHl+OSRoOPsp3
         l7P0IQxLGCVxCTQ4WpK6vurs5AJ7g1BqHuHbeGNMqRv70+1h5iRMdP5dYeyd6tVr5Jjg
         qwjcXmZ1lQQMakid7qD23W4lJpPE1eG1+k9mHebtRDYYXSMtUq1XzIXGBuaJxd3Kp8gw
         WQVTe1DWPciGLQj8ZH80x7rshP9/n7nIwhy+XfP6dLhVDKsc2lkH3X7jna04UnVY3D68
         wMXJy13El47aAvj/4NZswj9k2fjD3l3Unc6FVV6H/kD6/PYnq017hlK4NV2GECMeACEI
         hsNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WNt7w3V3r3XNyd6E3pkmZ4MDV9Ukbbrto5tyyCRol2g=;
        b=F9fds62LvcJ91D3ehTUhdQvImRPewa98OuO5KjjpisT2+c3pa2Jqn5ZR+gQGUsXwUW
         2SWhguNcjTonvcs1e+o2LLWmuDXQOjxxPsygkdaMb64t0UYKqVEEPKJ2v+LIb9vGyTus
         oHQAyui41bi1yjOHgHOnbZYt4GlhpuoGd0OX/GxLADKlIOfO2I0ZMGbQnxg3K7Cc0HeF
         z8qktHsew26AyMCSzG+ujD21ssRBsVSKb1kQEr/sTKvlkLjynCMpEHlDsSArrjFd9CQ8
         b0X/TTM50+TQSnfk/j+QWEuyVxlNTff5AF7FEAJ6wkN2SUzYo9/Ot7pDO1eiuXVgseNM
         7xaA==
X-Gm-Message-State: AOAM530I5g4ebKIhyyzc7/MXyPv25jIgifIXhJH/tS3GyvTSofEK81Mb
        WI6tzdf6GvBm6220YILkNuI=
X-Google-Smtp-Source: ABdhPJwzmtERX589Uo5Yoxk8x/XkmWvT2p2an/Pog3khehp2WayMkkGs1C3n62B4VHw3CYvgYctjRQ==
X-Received: by 2002:a5d:5709:: with SMTP id a9mr8051833wrv.74.1644767375572;
        Sun, 13 Feb 2022 07:49:35 -0800 (PST)
Received: from xws.localdomain ([194.126.177.12])
        by smtp.gmail.com with ESMTPSA id j5sm25346805wrq.31.2022.02.13.07.49.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Feb 2022 07:49:35 -0800 (PST)
From:   Maximilian Luz <luzmaximilian@gmail.com>
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     Maximilian Luz <luzmaximilian@gmail.com>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] ACPI: battery: Add device HID and quirk for Microsoft Surface Go 3
Date:   Sun, 13 Feb 2022 16:49:20 +0100
Message-Id: <20220213154920.142816-1-luzmaximilian@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

For some reason, the Microsoft Surface Go 3 uses the standard ACPI
interface for battery information, but does not use the standard PNP0C0A
HID. Instead it uses MSHW0146 as identifier. Add that ID to the driver
as this seems to work well.

Additionally, the power state is not updated immediately after the AC
has been (un-)plugged, so add the respective quirk for that.

Cc: <stable@vger.kernel.org>
Signed-off-by: Maximilian Luz <luzmaximilian@gmail.com>
---
 drivers/acpi/battery.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index ea31ae01458b..dc208f5f5a1f 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -59,6 +59,10 @@ MODULE_PARM_DESC(cache_time, "cache time in milliseconds");
 
 static const struct acpi_device_id battery_device_ids[] = {
 	{"PNP0C0A", 0},
+
+	/* Microsoft Surface Go 3 */
+	{"MSHW0146", 0},
+
 	{"", 0},
 };
 
@@ -1148,6 +1152,14 @@ static const struct dmi_system_id bat_dmi_table[] __initconst = {
 			DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad"),
 		},
 	},
+	{
+		/* Microsoft Surface Go 3 */
+		.callback = battery_notification_delay_quirk,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Surface Go 3"),
+		},
+	},
 	{},
 };
 
-- 
2.35.1

