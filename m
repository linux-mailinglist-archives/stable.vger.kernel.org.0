Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EE5D6810CB
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:06:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237098AbjA3OGr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:06:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237091AbjA3OGq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:06:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 052413B3FD
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:06:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 96BA961026
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:06:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88D38C433D2;
        Mon, 30 Jan 2023 14:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087605;
        bh=Kf+89QtSLgs0rsAG+wzmH+kIIR+4efLXXuL6DtOHln8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1J1wZrcZFzfcFUMnzUoxsBryU2pt/+6+d/6lEjmpUIJSPl9vb3ey5ZCn/bNOkNITs
         bZud8vUgv78A08hK/oD51T+grZ0MpykzkLFpQaGBRYhxyAUNLMqnn49dMgxCAG55qt
         yarWwi80VqHk1Nd6UEVIqgpmcVLBkT4leADPSoFU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 262/313] ACPI: video: Add backlight=native DMI quirk for HP EliteBook 8460p
Date:   Mon, 30 Jan 2023 14:51:37 +0100
Message-Id: <20230130134348.946352271@linuxfoundation.org>
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

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 9dcb34234b8235144c96103266317da33321077e ]

The HP EliteBook 8460p predates Windows 8, so it defaults to using
acpi_video# for backlight control.

Starting with the 6.1.y kernels the native radeon_bl0 backlight is hidden
in this case instead of relying on userspace preferring acpi_video# over
native backlight devices.

It turns out that for the acpi_video# interface to work on
the HP EliteBook 8460p, the brightness needs to be set at least once
through the native interface, which now no longer is done breaking
backlight control.

The native interface however always works without problems, so add
a quirk to use native backlight on the EliteBook 8460p to fix this.

Fixes: fb1836c91317 ("ACPI: video: Prefer native over vendor")
Link: https://bugzilla.redhat.com/show_bug.cgi?id=2161428
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/video_detect.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index c20fc7ddca2f..4719978b8aa3 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -608,6 +608,14 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
 		DMI_MATCH(DMI_PRODUCT_NAME, "UX303UB"),
 		},
 	},
+	{
+	 .callback = video_detect_force_native,
+	 /* HP EliteBook 8460p */
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "HP EliteBook 8460p"),
+		},
+	},
 	{
 	 .callback = video_detect_force_native,
 	 /* HP Pavilion g6-1d80nr / B4U19UA */
-- 
2.39.0



