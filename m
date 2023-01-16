Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4060C66C202
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 15:17:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232688AbjAPOR0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 09:17:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232431AbjAPOPw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 09:15:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C468B23D89;
        Mon, 16 Jan 2023 06:05:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 73D0CB80F3B;
        Mon, 16 Jan 2023 14:05:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56D09C433F1;
        Mon, 16 Jan 2023 14:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673877945;
        bh=pAmE34wYXIWTym+4baLdsEqTcL4DbbPNSxbNRFmc3Z0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SNay35k7dbPIQAhwF5H1KI7BUZcQ2TXuMc7wIUrS83DM75wm1bRouGr1PoCrc0CN3
         FbNwZOEMPmg+0ggZlq7UB5PDOFjUeTZACX9JPDSdfmrskb29+EciYK1Fk/kSZphdJS
         pz1fS7zjRrtl6EQ6nz6Ld1/xWNw00kPHr99i64/XR978HTvOyUiRCh8nHH6IaYJuJ6
         t75HcKL9NCs1+BcoghMZtT4awAnx0k4uT478DeBOuipMKKLDKveziNy5bEkzjvXKE7
         yNseFJInSsR1XBBBY24GmTMGR71Mku/uby3dqS9Nfijmsc1NYLeOHpYA0COF9VtHAj
         gj84SzWTQyv9w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, corentin.chary@gmail.com,
        markgross@kernel.org, acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 15/16] platform/x86: asus-wmi: Ignore fan on E410MA
Date:   Mon, 16 Jan 2023 09:05:18 -0500
Message-Id: <20230116140520.116257-15-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230116140520.116257-1-sashal@kernel.org>
References: <20230116140520.116257-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
index 6424bdb33d2f..15328c03c41b 100644
--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -120,6 +120,10 @@ static struct quirk_entry quirk_asus_ga502i = {
 	.wmi_backlight_set_devstate = true,
 };
 
+static struct quirk_entry quirk_asus_ignore_fan = {
+	.wmi_ignore_fan = true,
+};
+
 static int dmi_matched(const struct dmi_system_id *dmi)
 {
 	pr_info("Identified laptop model '%s'\n", dmi->ident);
@@ -493,6 +497,15 @@ static const struct dmi_system_id asus_quirks[] = {
 		},
 		.driver_data = &quirk_asus_ga502i,
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
2.35.1

