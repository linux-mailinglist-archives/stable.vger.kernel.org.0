Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E955681068
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:03:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236954AbjA3ODS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:03:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236956AbjA3ODA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:03:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12A6472A3
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:02:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1EC96103E
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:02:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0F71C433EF;
        Mon, 30 Jan 2023 14:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087374;
        bh=ydFMu5ZyxgpUiV8oCBnVJ4roBXD2zXe+BP/cCH793Js=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kIbfXFOE388ZKt+5AOLbmsrYLfGWZa07LWv9P/OqHUkqdIrQERj8iFUqN/p3ZhQIE
         JDgQ7vhF+PixHIUpslIivDz+86huD29CIAfZ9RCY2ntbiwrlBb2SJwjsTp1UsYI3ux
         ykVNqC4xtjXKDlKREkAsd59hL6hC5EfVAQAyxsWs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 186/313] platform/x86: asus-wmi: Ignore fan on E410MA
Date:   Mon, 30 Jan 2023 14:50:21 +0100
Message-Id: <20230130134345.371695079@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit 82cc5c6c624c63f7b57214e325e2ea685d924e89 ]

The ASUS VivoBook has a fan device described in its ACPI tables but does
not actually contain any physical fan.
Use the quirk to inhibit fan handling.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Link: https://lore.kernel.org/r/20221221-asus-fan-v1-2-e07f3949725b@weissschuh.net
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-nb-wmi.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/platform/x86/asus-nb-wmi.c b/drivers/platform/x86/asus-nb-wmi.c
index b34bddda0a9b..cb15acdf14a3 100644
--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -121,6 +121,10 @@ static struct quirk_entry quirk_asus_tablet_mode = {
 	.tablet_switch_mode = asus_wmi_lid_flip_rog_devid,
 };
 
+static struct quirk_entry quirk_asus_ignore_fan = {
+	.wmi_ignore_fan = true,
+};
+
 static int dmi_matched(const struct dmi_system_id *dmi)
 {
 	pr_info("Identified laptop model '%s'\n", dmi->ident);
@@ -473,6 +477,15 @@ static const struct dmi_system_id asus_quirks[] = {
 		},
 		.driver_data = &quirk_asus_tablet_mode,
 	},
+	{
+		.callback = dmi_matched,
+		.ident = "ASUS VivoBook E410MA",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "E410MA"),
+		},
+		.driver_data = &quirk_asus_ignore_fan,
+	},
 	{},
 };
 
-- 
2.39.0



