Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6673558C0E0
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243625AbiHHBzf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:55:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243449AbiHHBx6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:53:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E51F1AF28;
        Sun,  7 Aug 2022 18:39:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2140C60EBD;
        Mon,  8 Aug 2022 01:39:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5F07C433D7;
        Mon,  8 Aug 2022 01:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922739;
        bh=kCut2OdKbgOGp5VoixaQirlOjNEkb9rjzVzvP+yhMXs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ns8PNVg+IHQDIKvDI0hrQLaMhCqi8mEYhpnxUvap5gLdqZNYUvcOCk/Wf2TFJ57Gy
         VSmsQ7yTgld6PEP4PPMg94EqQgqWroj6ADYryXk3AZaWn0CVg1w7ABG389uJI+Q21e
         HwhiU+9FzVn/oPGdmKUsGuWDuujwIWJZzx8Q79ByAv41qo9jlxCP1jkc2mt9ilqyIj
         9CN+9uXOYxuf2mKtodFvCc5K0+AOCuLHE2LGqpqa1VTO/GV2i1TOofVtH0RuJZMDT3
         D9VSrqiQofbGMoM3ps9cRV2RPlQ6Ohi6z4tKyiW/5cNepVjzgMd1NKpOylVV2MxCmq
         vm7xio2ZkwaAg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 15/23] ACPI: EC: Remove duplicate ThinkPad X1 Carbon 6th entry from DMI quirks
Date:   Sun,  7 Aug 2022 21:38:22 -0400
Message-Id: <20220808013832.316381-15-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808013832.316381-1-sashal@kernel.org>
References: <20220808013832.316381-1-sashal@kernel.org>
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

[ Upstream commit 0dd6db359e5f206cbf1dd1fd40dd211588cd2725 ]

Somehow the "ThinkPad X1 Carbon 6th" entry ended up twice in the
struct dmi_system_id acpi_ec_no_wakeup[] array. Remove one of
the entries.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/ec.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index e5b92958c299..defc5796b508 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -2118,13 +2118,6 @@ static const struct dmi_system_id acpi_ec_no_wakeup[] = {
 			DMI_MATCH(DMI_PRODUCT_FAMILY, "Thinkpad X1 Carbon 6th"),
 		},
 	},
-	{
-		.ident = "ThinkPad X1 Carbon 6th",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-			DMI_MATCH(DMI_PRODUCT_FAMILY, "ThinkPad X1 Carbon 6th"),
-		},
-	},
 	{
 		.ident = "ThinkPad X1 Yoga 3rd",
 		.matches = {
-- 
2.35.1

