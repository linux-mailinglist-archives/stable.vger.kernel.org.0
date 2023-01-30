Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F221C6810D9
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:07:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237112AbjA3OH1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:07:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237111AbjA3OHZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:07:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 884963B66A
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:07:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2421361085
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:07:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32D09C433EF;
        Mon, 30 Jan 2023 14:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087643;
        bh=dIXDa59htSfkcuU+xByZTuB5nzenjJ7P72KLGGYtPGc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aweGwZhaFP0C+40O4351SZRG7mJlOwEgFphKaEHBBPOyZ+KwYPOoPD8SxiF+pao0F
         VnfZsOJxY0L8ktlrPOCz0ZmL55yGICd0p+aa6DurHn30N66qtaFVec5YPMmXomw6tc
         NUW9Jij2+zLNYPNTxsdYa39EFQPtE2TQW5+PKk5I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Emmanouil Kouroupakis <kartebi@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 277/313] platform/x86: apple-gmux: Move port defines to apple-gmux.h
Date:   Mon, 30 Jan 2023 14:51:52 +0100
Message-Id: <20230130134349.633040492@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
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

[ Upstream commit 39f5a81f7ad80eb3fbcbfd817c6552db9de5504d ]

This is a preparation patch for adding a new static inline
apple_gmux_detect() helper which actually checks a supported
gmux is present, rather then only checking an ACPI device with
the HID is there as apple_gmux_present() does.

Fixes: 21245df307cb ("ACPI: video: Add Apple GMUX brightness control detection")
Link: https://lore.kernel.org/platform-driver-x86/20230123113750.462144-1-hdegoede@redhat.com/
Reported-by: Emmanouil Kouroupakis <kartebi@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20230124105754.62167-2-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/apple-gmux.c | 23 -----------------------
 include/linux/apple-gmux.h        | 23 +++++++++++++++++++++++
 2 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/platform/x86/apple-gmux.c b/drivers/platform/x86/apple-gmux.c
index ca33df7ea550..a0af01f6a0fd 100644
--- a/drivers/platform/x86/apple-gmux.c
+++ b/drivers/platform/x86/apple-gmux.c
@@ -64,29 +64,6 @@ struct apple_gmux_data {
 
 static struct apple_gmux_data *apple_gmux_data;
 
-/*
- * gmux port offsets. Many of these are not yet used, but may be in the
- * future, and it's useful to have them documented here anyhow.
- */
-#define GMUX_PORT_VERSION_MAJOR		0x04
-#define GMUX_PORT_VERSION_MINOR		0x05
-#define GMUX_PORT_VERSION_RELEASE	0x06
-#define GMUX_PORT_SWITCH_DISPLAY	0x10
-#define GMUX_PORT_SWITCH_GET_DISPLAY	0x11
-#define GMUX_PORT_INTERRUPT_ENABLE	0x14
-#define GMUX_PORT_INTERRUPT_STATUS	0x16
-#define GMUX_PORT_SWITCH_DDC		0x28
-#define GMUX_PORT_SWITCH_EXTERNAL	0x40
-#define GMUX_PORT_SWITCH_GET_EXTERNAL	0x41
-#define GMUX_PORT_DISCRETE_POWER	0x50
-#define GMUX_PORT_MAX_BRIGHTNESS	0x70
-#define GMUX_PORT_BRIGHTNESS		0x74
-#define GMUX_PORT_VALUE			0xc2
-#define GMUX_PORT_READ			0xd0
-#define GMUX_PORT_WRITE			0xd4
-
-#define GMUX_MIN_IO_LEN			(GMUX_PORT_BRIGHTNESS + 4)
-
 #define GMUX_INTERRUPT_ENABLE		0xff
 #define GMUX_INTERRUPT_DISABLE		0x00
 
diff --git a/include/linux/apple-gmux.h b/include/linux/apple-gmux.h
index ddb10aa67b14..80efaaf89e07 100644
--- a/include/linux/apple-gmux.h
+++ b/include/linux/apple-gmux.h
@@ -11,6 +11,29 @@
 
 #define GMUX_ACPI_HID "APP000B"
 
+/*
+ * gmux port offsets. Many of these are not yet used, but may be in the
+ * future, and it's useful to have them documented here anyhow.
+ */
+#define GMUX_PORT_VERSION_MAJOR		0x04
+#define GMUX_PORT_VERSION_MINOR		0x05
+#define GMUX_PORT_VERSION_RELEASE	0x06
+#define GMUX_PORT_SWITCH_DISPLAY	0x10
+#define GMUX_PORT_SWITCH_GET_DISPLAY	0x11
+#define GMUX_PORT_INTERRUPT_ENABLE	0x14
+#define GMUX_PORT_INTERRUPT_STATUS	0x16
+#define GMUX_PORT_SWITCH_DDC		0x28
+#define GMUX_PORT_SWITCH_EXTERNAL	0x40
+#define GMUX_PORT_SWITCH_GET_EXTERNAL	0x41
+#define GMUX_PORT_DISCRETE_POWER	0x50
+#define GMUX_PORT_MAX_BRIGHTNESS	0x70
+#define GMUX_PORT_BRIGHTNESS		0x74
+#define GMUX_PORT_VALUE			0xc2
+#define GMUX_PORT_READ			0xd0
+#define GMUX_PORT_WRITE			0xd4
+
+#define GMUX_MIN_IO_LEN			(GMUX_PORT_BRIGHTNESS + 4)
+
 #if IS_ENABLED(CONFIG_APPLE_GMUX)
 
 /**
-- 
2.39.0



