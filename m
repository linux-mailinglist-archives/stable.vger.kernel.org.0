Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7CE6679A04
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 14:44:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234441AbjAXNoG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 08:44:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234353AbjAXNnW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 08:43:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9432416ADA;
        Tue, 24 Jan 2023 05:42:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29E4C611FB;
        Tue, 24 Jan 2023 13:42:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB334C4339E;
        Tue, 24 Jan 2023 13:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674567743;
        bh=nJiWgpzWd6hhFQU6GhD6OaPA7BegalhHIgD4b+07wS0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oBEP/WzyMeZMCRCKQPhj4IA/Y3E4w7F9VU3PLltuWjmATkMBs3VumTabEM/42GAyp
         GnnDRfC0LVZNfBDB9OrBNCQLNTPeaXWN1YzpEEWYIoCdM191kG363zbmDGFAYkoPEJ
         WzXuE7YJa9QKc3vatBtPt3oHDLQlajpxWpNTQQ2C8aa3DCx8U4fhH76uZMtu0gAtTI
         dn2LzkOEPBRJkW1/2VxeE2fm+7uu2Y/PVUuC7VerfbYnLyKLsamKm7q+GgLyFVHndX
         UKexa/xfCDGmoCdyD5WSJLm0zhudjX/xq7mIiE70Lp2oFSxJYitPFnOkHK2qZccOp/
         k2PQg+nS3TdlA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 18/35] ACPI: video: Add backlight=native DMI quirk for Acer Aspire 4810T
Date:   Tue, 24 Jan 2023 08:41:14 -0500
Message-Id: <20230124134131.637036-18-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230124134131.637036-1-sashal@kernel.org>
References: <20230124134131.637036-1-sashal@kernel.org>
MIME-Version: 1.0
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

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 8ba5fc4c154aeb3b4620f05543cce426c62ed2de ]

The Acer Aspire 4810T predates Windows 8, so it defaults to using
acpi_video# for backlight control, but this is non functional on
this model.

Add a DMI quirk to use the native backlight interface which does
work properly.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/video_detect.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index 1db8e68cd8bc..79fe66c5f14a 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -513,6 +513,14 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
 		DMI_MATCH(DMI_PRODUCT_NAME, "Precision 7510"),
 		},
 	},
+	{
+	 .callback = video_detect_force_native,
+	 /* Acer Aspire 4810T */
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 4810T"),
+		},
+	},
 	{
 	 .callback = video_detect_force_native,
 	 /* Acer Aspire 5738z */
-- 
2.39.0

