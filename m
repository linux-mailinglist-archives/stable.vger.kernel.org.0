Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDFF660A61D
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbiJXMbq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:31:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234280AbiJXM3z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:29:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 514062FFEC;
        Mon, 24 Oct 2022 05:03:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 23681612E3;
        Mon, 24 Oct 2022 12:03:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 331D2C433D6;
        Mon, 24 Oct 2022 12:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612993;
        bh=GNPGlTVN0Wx/jDcaPTBSQwgG0mCsQRKC7an2BZBzTCA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZM7+Ti4TJ0WBnsZcmsS/Iie777ik+XyBJmqxHKfbI8vaxf0xm/Q/P0mmi1SIwKTZa
         mqJr0buioa+042oJsGTwMXdbiRSGXBV0zO97pr5ReIwOW2sAoMizi3CQ7/i+Q3rhZN
         9zi/DD9XzuSPiNlJZSkSd94QZs9j5KjMJ5UCT834=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 198/229] platform/x86: msi-laptop: Change DMI match / alias strings to fix module autoloading
Date:   Mon, 24 Oct 2022 13:31:57 +0200
Message-Id: <20221024113005.545254819@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112959.085534368@linuxfoundation.org>
References: <20221024112959.085534368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 1ba5f4689df4..42b31c549db0 100644
--- a/drivers/platform/x86/msi-laptop.c
+++ b/drivers/platform/x86/msi-laptop.c
@@ -609,11 +609,10 @@ static const struct dmi_system_id msi_dmi_table[] __initconst = {
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
@@ -646,8 +645,7 @@ static const struct dmi_system_id msi_dmi_table[] __initconst = {
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



