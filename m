Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 394B768303B
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 16:00:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232324AbjAaPAj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 10:00:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232021AbjAaPAN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Jan 2023 10:00:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EBDB22A24;
        Tue, 31 Jan 2023 07:00:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 37BA661568;
        Tue, 31 Jan 2023 15:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E84B6C4331D;
        Tue, 31 Jan 2023 15:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675177211;
        bh=tKzTqm1ofy9oTIxvlCRIuiR2MO3UmYpH27WzXDlqd8k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bepgBs1ulPjlhCsulwA4GGxpEGV7OaFBi/VNOT6KCqDcDNf5bhylhatFJR+zWfYSw
         QJXUdu/czbzBQYOJrb9wG23rl7UJCdYDxuWz7WZzrEoU9zymWlXTQreScMaCl8crEC
         kqZEnZ75IlxMx8mV3vDLSnH4NL7LMjgAJSj8eHcxNFR+vHB7z4rUCW1noxn1aBgFwj
         FgQiHMgB93ANzEUPLdAIBYGDsk5sjR0OeAdaIUNayuw8J7au5e40VJK2+9U+guEVFg
         s/N19KpBKRASKbQc8MdBr1mlzNl4Aky8dNfTRKIphrMl/I6t187Em9hJdTK+7D5YOc
         o9zdvYJHr9tMg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 12/20] ACPI: video: Add backlight=native DMI quirk for HP Pavilion g6-1d80nr
Date:   Tue, 31 Jan 2023 09:59:38 -0500
Message-Id: <20230131145946.1249850-12-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230131145946.1249850-1-sashal@kernel.org>
References: <20230131145946.1249850-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit d77596d432cc4142520af32b5388d512e52e0edb ]

The HP Pavilion g6-1d80nr predates Windows 8, so it defaults to using
acpi_video# for backlight control, but this is non functional on
this model.

Add a DMI quirk to use the native backlight interface which does
work properly.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/video_detect.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index 1db8e68cd8bc..c20fc7ddca2f 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -608,6 +608,15 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
 		DMI_MATCH(DMI_PRODUCT_NAME, "UX303UB"),
 		},
 	},
+	{
+	 .callback = video_detect_force_native,
+	 /* HP Pavilion g6-1d80nr / B4U19UA */
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion g6 Notebook PC"),
+		DMI_MATCH(DMI_PRODUCT_SKU, "B4U19UA"),
+		},
+	},
 	{
 	 .callback = video_detect_force_native,
 	 /* Samsung N150P */
-- 
2.39.0

