Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD5FF5F95A5
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 02:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232682AbiJJAWA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 20:22:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232276AbiJJAU7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 20:20:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A55A25C4F;
        Sun,  9 Oct 2022 16:55:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E954D60D3D;
        Sun,  9 Oct 2022 23:55:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95689C433C1;
        Sun,  9 Oct 2022 23:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665359706;
        bh=nlsFU6+qAFHENonUxtCRXgN1MbdHlXKsPAZ0zCns0UI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T3ALnhfv1lM4/8+TbFqlEptlbsEItDZjasxpb46BFkWvoKAhQmHH+TAHipqlaCV+Y
         WxSvs/U3tvO8CcNxxEusnYIqggpnEZ1fq5UtwyPsbQQwYH+l3bYGQ5cot1AzmGGAZD
         ocUAYdzMFsvbZPPDZ//hAyT8dReTlQbHEs6UP4vZkMuvp/E00iQgbEGy4KTGqhaxnl
         zqARV0ITi/w1hO3eBREvuoyZvY2PQ8ynW5Xtmjv9VS3yMMcTSlYql6PRcFVreQp4nB
         XFXeXERuFjpLMVMz4O8tW2ObIX1chSEOF5gccutLa991IHJGAb4Ef7ZeKW2jT7Supk
         uCB/eyqcugkQw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, jlee@suse.com,
        markgross@kernel.org, platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 16/25] platform/x86: msi-laptop: Change DMI match / alias strings to fix module autoloading
Date:   Sun,  9 Oct 2022 19:54:16 -0400
Message-Id: <20221009235426.1231313-16-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009235426.1231313-1-sashal@kernel.org>
References: <20221009235426.1231313-1-sashal@kernel.org>
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

[ Upstream commit 2a2565272a3628e45d61625e36ef17af7af4e3de ]

On a MSI S270 with Fedora 37 x86_64 / systemd-251.4 the module does not
properly autoload.

This is likely caused by issues with how systemd-udevd handles the single
quote char (') which is part of the sys_vendor / chassis_vendor strings
on this laptop. As a workaround remove the single quote char + everything
behind it from the sys_vendor + chassis_vendor matches. This fixes
the module not autoloading.

Link: https://github.com/systemd/systemd/issues/24715
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20220917210407.647432-1-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/msi-laptop.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/platform/x86/msi-laptop.c b/drivers/platform/x86/msi-laptop.c
index 24ffc8e2d2d1..d8a94968aedc 100644
--- a/drivers/platform/x86/msi-laptop.c
+++ b/drivers/platform/x86/msi-laptop.c
@@ -596,11 +596,10 @@ static const struct dmi_system_id msi_dmi_table[] __initconst = {
 	{
 		.ident = "MSI S270",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "MICRO-STAR INT'L CO.,LTD"),
+			DMI_MATCH(DMI_SYS_VENDOR, "MICRO-STAR INT"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "MS-1013"),
 			DMI_MATCH(DMI_PRODUCT_VERSION, "0131"),
-			DMI_MATCH(DMI_CHASSIS_VENDOR,
-				  "MICRO-STAR INT'L CO.,LTD")
+			DMI_MATCH(DMI_CHASSIS_VENDOR, "MICRO-STAR INT")
 		},
 		.driver_data = &quirk_old_ec_model,
 		.callback = dmi_check_cb
@@ -633,8 +632,7 @@ static const struct dmi_system_id msi_dmi_table[] __initconst = {
 			DMI_MATCH(DMI_SYS_VENDOR, "NOTEBOOK"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "SAM2000"),
 			DMI_MATCH(DMI_PRODUCT_VERSION, "0131"),
-			DMI_MATCH(DMI_CHASSIS_VENDOR,
-				  "MICRO-STAR INT'L CO.,LTD")
+			DMI_MATCH(DMI_CHASSIS_VENDOR, "MICRO-STAR INT")
 		},
 		.driver_data = &quirk_old_ec_model,
 		.callback = dmi_check_cb
-- 
2.35.1

