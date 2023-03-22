Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0E3F6C567C
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 21:06:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231317AbjCVUGs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 16:06:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231706AbjCVUGO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 16:06:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAAC174A54;
        Wed, 22 Mar 2023 13:01:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EEDB4B81DF0;
        Wed, 22 Mar 2023 20:00:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EE61C433A0;
        Wed, 22 Mar 2023 20:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679515222;
        bh=J8GKrg4aO8fIPLrHH3wbFzd1mUfN+opVwytvi9zLVUo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Omikanzftp9K1GZKaGZyEj7qOedPDWuwPfhNxYGYeOvkTpNCylC8wEXdGLx1skSq8
         4ND2NkNlnpWkOAM05eD2U9Zu/DRuqgScVXtvj4EGqVPBwZYdMCZu2j1klgPu2EPGdc
         suHW7mFlhTdllUv9ixE52a8cvtK2to3L1nqf54a4xfiyKdUfUCb0+ujTn5OGUu93eH
         5RirDW5v19sT2/kDsrnm0Kuf5Sp/9X64CG39rE49gZfR7LzcDHkzm4b9u4iSV00L5n
         Nq/MCo5HqDL4VnuO7GsgVVQrhxcBMf8JjWc8klkb3Uy4gWqIANRZyilmkDQKjtCmKA
         bwZRNbOl8muOA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Chia-Lin Kao (AceLan)" <acelan.kao@canonical.com>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 08/34] ACPI: video: Add backlight=native DMI quirk for Dell Vostro 15 3535
Date:   Wed, 22 Mar 2023 15:59:00 -0400
Message-Id: <20230322195926.1996699-8-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230322195926.1996699-1-sashal@kernel.org>
References: <20230322195926.1996699-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Chia-Lin Kao (AceLan)" <acelan.kao@canonical.com>

[ Upstream commit 89b0411481967a2e8c91190a211a359966cfcf4b ]

Sometimes the system boots up with a acpi_video0 backlight interface
which doesn't work. So add Dell Vostro 15 3535 into the
video_detect_dmi_table to set it to native explicitly.

Signed-off-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
Signed-off-by: Rafael J. Wysocki <rjw@rjwysocki.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/video_detect.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index 7f0ed845cd6ad..f06b3d3556710 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -714,6 +714,13 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
 		DMI_MATCH(DMI_PRODUCT_NAME, "Dell G15 5515"),
 		},
 	},
+	{
+	 .callback = video_detect_force_native,
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "Vostro 15 3535"),
+		},
+	},
 
 	/*
 	 * Desktops which falsely report a backlight and which our heuristics
-- 
2.39.2

