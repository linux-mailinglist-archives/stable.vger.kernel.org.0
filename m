Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CCAD6A323E
	for <lists+stable@lfdr.de>; Sun, 26 Feb 2023 16:29:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbjBZP3N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 10:29:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbjBZP2r (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 10:28:47 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82A135FD6;
        Sun, 26 Feb 2023 07:24:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CCCFACE0EA6;
        Sun, 26 Feb 2023 14:53:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E99AC4339E;
        Sun, 26 Feb 2023 14:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677423202;
        bh=wtU50NCWIEHFeyCBP+URdE0hqr5zF0Ky8/xvtJ3Vrok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mIQWC2x577JpMMBwitEjhoOutjgBUEimwRenFPBfIpyb65m67lSSYhLDMltU1pMle
         rv6/upLVz21gtCI9cPz6gbt0ZFdnDm5BbwaCtgzpJAQNEZcfn8SBdCVmWGNf7nyqZ0
         jdg6gesCXk/G/h3+dc6RkGcHhS2rpBN1y3RexleHgsbwInyXbQ6s2IY4D8qZgDA7fR
         e/Wg29p9Q2qM0FI8s/GINe63Sv7/IITHlKvxqVcV5C+WLcsIDQcAIcfXCWYIZlvvsV
         EI7LhiocXVuJPnU3xyr8u7QUw5n8HRyZOJaJlLaliyzDllD1TJcEtqvVFSFRRNnMe6
         h7uqSHlviU/qg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 11/11] ACPI: video: Fix Lenovo Ideapad Z570 DMI match
Date:   Sun, 26 Feb 2023 09:52:53 -0500
Message-Id: <20230226145255.829660-11-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230226145255.829660-1-sashal@kernel.org>
References: <20230226145255.829660-1-sashal@kernel.org>
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

[ Upstream commit 2d11eae42d52a131f06061015e49dc0f085c5bfc ]

Multiple Ideapad Z570 variants need acpi_backlight=native to force native
use on these pre Windows 8 machines since acpi_video backlight control
does not work here.

The original DMI quirk matches on a product_name of "102434U" but other
variants may have different product_name-s such as e.g. "1024D9U".

Move to checking product_version instead as is more or less standard for
Lenovo DMI quirks for similar reasons.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/video_detect.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index 0ec74ab2a3995..b4f16073ef432 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -300,7 +300,7 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
 	 .ident = "Lenovo Ideapad Z570",
 	 .matches = {
 		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-		DMI_MATCH(DMI_PRODUCT_NAME, "102434U"),
+		DMI_MATCH(DMI_PRODUCT_VERSION, "Ideapad Z570"),
 		},
 	},
 	{
-- 
2.39.0

