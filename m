Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB63F6D4A41
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233897AbjDCOpe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:45:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233902AbjDCOpd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:45:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68ACB16975
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:45:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE5A7B80B98
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:45:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 381E0C433EF;
        Mon,  3 Apr 2023 14:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680533100;
        bh=xMcTrCAq/Ug9yr5HZbxkJYlVpKku54OpmikTertNWHU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pcUb/mmfupQ+6H911zwpbi61fPtMYN8Y5xjoDjiSNHiBC6LGbVfYiCU2VKeuGi5u6
         WtA6JPWBh+T1LNyF9iAHU/YvrdXaxTlTs7Dv20T4kCg/CltIiZ1WGRRJ+SIUkWAPU3
         d0JYYaUzWeg6mIQF5cjJTaaTz2bA7AD8yVK9Yifs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Chia-Lin Kao (AceLan)" <acelan.kao@canonical.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 024/187] ACPI: video: Add backlight=native DMI quirk for Dell Vostro 15 3535
Date:   Mon,  3 Apr 2023 16:07:49 +0200
Message-Id: <20230403140416.817139790@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>

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
index 710ac640267dd..14d6d81e536fe 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -716,6 +716,13 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
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



