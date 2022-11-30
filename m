Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A315B63DF1C
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:44:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231314AbiK3SoA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:44:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231279AbiK3Snq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:43:46 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 437F81C11F
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:43:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B314ECE1ADC
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:43:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F3FAC433C1;
        Wed, 30 Nov 2022 18:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833822;
        bh=7bxahGR5cIK6Bw34SpYKQcIlMTHfdqeFt+yN+vvop0w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KZFR9uzjpxZYDwUKayQE4CuoK+PDZVVVc1XffAq+cj3suByV1gwwjU9qNUGSouwAB
         1nLOySefPI3qtTAKQAH0t0Ud4PJS9/faiRVBCNskDRgotsjTItX0c6pp4ab3QgHaxx
         5sjZQmyB6uD6C40mIi4qdgtXPWyBKxjUzSQ8gato=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Iris <pawel.js@protonmail.com>,
        Daniel Dadap <ddadap@nvidia.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 019/289] ACPI: video: Add backlight=native DMI quirk for Dell G15 5515
Date:   Wed, 30 Nov 2022 19:20:04 +0100
Message-Id: <20221130180544.568582889@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
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

[ Upstream commit f46acc1efd4b5846de9fa05f966e504f328f34a6 ]

The Dell G15 5515 has the WMI interface (and WMI call returns) expected
by the nvidia-wmi-ec-backlight interface. But the backlight class device
registered by the nvidia-wmi-ec-backlight driver does not actually work.

The amdgpu_bl0 native GPU backlight class device does actually work,
add a backlight=native DMI quirk for this.

Reported-by: Iris <pawel.js@protonmail.com>
Reviewed-by: Daniel Dadap <ddadap@nvidia.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/video_detect.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index 68a566f69684..aae9261c424a 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -578,6 +578,20 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
 		DMI_MATCH(DMI_BOARD_NAME, "GMxRGxx"),
 		},
 	},
+	/*
+	 * Models which have nvidia-ec-wmi support, but should not use it.
+	 * Note this indicates a likely firmware bug on these models and should
+	 * be revisited if/when Linux gets support for dynamic mux mode.
+	 */
+	{
+	 .callback = video_detect_force_native,
+	 /* Dell G15 5515 */
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "Dell G15 5515"),
+		},
+	},
+
 	/*
 	 * Desktops which falsely report a backlight and which our heuristics
 	 * for this do not catch.
-- 
2.35.1



