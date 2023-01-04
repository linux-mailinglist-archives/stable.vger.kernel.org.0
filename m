Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F49065D823
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:11:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239606AbjADQLQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:11:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239875AbjADQKo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:10:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02E3A1573E
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:10:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A6469B8171C
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:10:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBF69C433F0;
        Wed,  4 Jan 2023 16:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672848641;
        bh=nxxioL4F4P3/WE2zNQBSlmVwJ7MeSriH6LWygpzA3hQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s7HBK9QhLVuGvRAuAjlq2xQVGCBuoNB4AKpd27Q1BjYcwCdt6qVlZzbHmxwQgw50m
         QW4NDEeqMXcQWK2WmMaXm/9ZYxEx6+IJHT//TM6oXOMs4fRhiqRDo51sIYhiti64aR
         sWtTH8Lfo3lEQWufTWJKr7zB1VUK2/E9Fe5IY/Og=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hans de Goede <hdegoede@redhat.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Maxim Mikityanskiy <maxtram95@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 048/207] platform/x86: ideapad-laptop: Refactor ideapad_sync_touchpad_state()
Date:   Wed,  4 Jan 2023 17:05:06 +0100
Message-Id: <20230104160513.440679674@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
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

[ Upstream commit 289a59895e7a380cdc7fe2780d3073f4b9237020 ]

Add an error exit for read_ec_data() failing instead of putting the main
body in an if (success) block.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Tested-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Tested-by: Maxim Mikityanskiy <maxtram95@gmail.com>
Link: https://lore.kernel.org/r/20221117110244.67811-2-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/ideapad-laptop.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
index 13e3ae731fd8..dcb3a82024da 100644
--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -1490,23 +1490,26 @@ static void ideapad_kbd_bl_exit(struct ideapad_private *priv)
 static void ideapad_sync_touchpad_state(struct ideapad_private *priv)
 {
 	unsigned long value;
+	unsigned char param;
+	int ret;
 
 	if (!priv->features.touchpad_ctrl_via_ec)
 		return;
 
 	/* Without reading from EC touchpad LED doesn't switch state */
-	if (!read_ec_data(priv->adev->handle, VPCCMD_R_TOUCHPAD, &value)) {
-		unsigned char param;
-		/*
-		 * Some IdeaPads don't really turn off touchpad - they only
-		 * switch the LED state. We (de)activate KBC AUX port to turn
-		 * touchpad off and on. We send KEY_TOUCHPAD_OFF and
-		 * KEY_TOUCHPAD_ON to not to get out of sync with LED
-		 */
-		i8042_command(&param, value ? I8042_CMD_AUX_ENABLE : I8042_CMD_AUX_DISABLE);
-		ideapad_input_report(priv, value ? 67 : 66);
-		sysfs_notify(&priv->platform_device->dev.kobj, NULL, "touchpad");
-	}
+	ret = read_ec_data(priv->adev->handle, VPCCMD_R_TOUCHPAD, &value);
+	if (ret)
+		return;
+
+	/*
+	 * Some IdeaPads don't really turn off touchpad - they only
+	 * switch the LED state. We (de)activate KBC AUX port to turn
+	 * touchpad off and on. We send KEY_TOUCHPAD_OFF and
+	 * KEY_TOUCHPAD_ON to not to get out of sync with LED
+	 */
+	i8042_command(&param, value ? I8042_CMD_AUX_ENABLE : I8042_CMD_AUX_DISABLE);
+	ideapad_input_report(priv, value ? 67 : 66);
+	sysfs_notify(&priv->platform_device->dev.kobj, NULL, "touchpad");
 }
 
 static void ideapad_acpi_notify(acpi_handle handle, u32 event, void *data)
-- 
2.35.1



