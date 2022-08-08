Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1805158BFDA
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:44:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242643AbiHHBoR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:44:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242662AbiHHBmN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:42:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDA5513EAA;
        Sun,  7 Aug 2022 18:35:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78463B80E06;
        Mon,  8 Aug 2022 01:35:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7596BC433D6;
        Mon,  8 Aug 2022 01:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922536;
        bh=iHZDPs2qdzAjoXp+XZNtkRFmBzqwWwQK3l4MS4ZX2Ho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fgU9SRHquT2o5bVSVMoBDK6nNswugN1n5Usbmd3iDsvyYwE2FzQOlsDJqNYWklUJk
         XQqZeDTmGNEMm5be9ZxgLrv45Y1oJhCCDnjJbIypoLJRYxv6aKQShM+8wAyOKYRjEL
         JbUN1EdpYJc3Yr33VW47kdOpMn24GCCzAO7ruK2dIWicrFOEu1iF9eA+Gk0ke/Z9mp
         U60WhclHtNsr8G9wSxMI+j2BscfCdme/itORV2eztCtV9wxSjguIdkKpoib+NUdw4/
         Aogsp/iLomncpycQdr5ZaOzqFUPhiGVL40i40ycAHUQks03aBrvIlIbUNlRMfAvXdp
         DdnqNgdfwY9cA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Ben Greening <bgreening@gmail.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 47/53] ACPI: video: Use native backlight on Dell Inspiron N4010
Date:   Sun,  7 Aug 2022 21:33:42 -0400
Message-Id: <20220808013350.314757-47-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808013350.314757-1-sashal@kernel.org>
References: <20220808013350.314757-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 03c440a26cba6cfa540d65924e9db86fcea362b2 ]

The Dell Inspiron N4010 does not have ACPI backlight control,
so acpi_video_get_backlight_type()'s heuristics return vendor as
the type to use.

But the vendor interface is broken, where as the native (intel_backlight)
works well, add a quirk to use native.

Link: https://lore.kernel.org/regressions/CALF=6jEe5G8+r1Wo0vvz4GjNQQhdkLT5p8uCHn6ZXhg4nsOWow@mail.gmail.com/
Reported-and-tested-by: Ben Greening <bgreening@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/video_detect.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index becc198e4c22..4099140bbd5f 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -347,6 +347,14 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
 		DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro12,1"),
 		},
 	},
+	{
+	 .callback = video_detect_force_native,
+	 /* Dell Inspiron N4010 */
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "Inspiron N4010"),
+		},
+	},
 	{
 	 .callback = video_detect_force_native,
 	 /* Dell Vostro V131 */
-- 
2.35.1

