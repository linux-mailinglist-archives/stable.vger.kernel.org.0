Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C562F59D373
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 10:22:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242163AbiHWIMl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:12:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242542AbiHWILb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:11:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B71AA4C603;
        Tue, 23 Aug 2022 01:08:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95726B81BF8;
        Tue, 23 Aug 2022 08:08:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E61F8C433D7;
        Tue, 23 Aug 2022 08:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242125;
        bh=vLgp0CHZ1YqZI9BsiEypEmU+NLd3HoKiXZv/xrBOgBU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NCxEMAmQUjXaMoc3he7Gl9Xu6850DC9vcjiRH/UhCSQzolKjvVZgbmMU9CRHx2Mcf
         f00fgWH86GBuyprPChv5MbQuqQgcnTRDtEvwYYo6tDe+dxe5KmFxkdjceXPetobGjP
         dJt0RVdh3E9R/gxFMyBnBDwxYvjJ8LB7JSnWD5kU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Werner Sembach <wse@tuxedocomputers.com>,
        Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 4.9 022/101] ACPI: video: Shortening quirk list by identifying Clevo by board_name only
Date:   Tue, 23 Aug 2022 10:02:55 +0200
Message-Id: <20220823080035.413929654@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080034.579196046@linuxfoundation.org>
References: <20220823080034.579196046@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Werner Sembach <wse@tuxedocomputers.com>

commit f0341e67b3782603737f7788e71bd3530012a4f4 upstream.

Taking a recent change in the i8042 quirklist to this one: Clevo
board_names are somewhat unique, and if not: The generic Board_-/Sys_Vendor
string "Notebook" doesn't help much anyway. So identifying the devices just
by the board_name helps keeping the list significantly shorter and might
even hit more devices requiring the fix.

Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Fixes: c844d22fe0c0 ("ACPI: video: Force backlight native for Clevo NL5xRU and NL5xNU")
Cc: All applicable <stable@vger.kernel.org>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/video_detect.c |   34 ----------------------------------
 1 file changed, 34 deletions(-)

--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -150,23 +150,6 @@ static const struct dmi_system_id video_
 	.callback = video_detect_force_native,
 	.ident = "Clevo NL5xRU",
 	.matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "TUXEDO"),
-		DMI_MATCH(DMI_BOARD_NAME, "NL5xRU"),
-		},
-	},
-	{
-	.callback = video_detect_force_native,
-	.ident = "Clevo NL5xRU",
-	.matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "SchenkerTechnologiesGmbH"),
-		DMI_MATCH(DMI_BOARD_NAME, "NL5xRU"),
-		},
-	},
-	{
-	.callback = video_detect_force_native,
-	.ident = "Clevo NL5xRU",
-	.matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "Notebook"),
 		DMI_MATCH(DMI_BOARD_NAME, "NL5xRU"),
 		},
 	},
@@ -190,23 +173,6 @@ static const struct dmi_system_id video_
 	.callback = video_detect_force_native,
 	.ident = "Clevo NL5xNU",
 	.matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "TUXEDO"),
-		DMI_MATCH(DMI_BOARD_NAME, "NL5xNU"),
-		},
-	},
-	{
-	.callback = video_detect_force_native,
-	.ident = "Clevo NL5xNU",
-	.matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "SchenkerTechnologiesGmbH"),
-		DMI_MATCH(DMI_BOARD_NAME, "NL5xNU"),
-		},
-	},
-	{
-	.callback = video_detect_force_native,
-	.ident = "Clevo NL5xNU",
-	.matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "Notebook"),
 		DMI_MATCH(DMI_BOARD_NAME, "NL5xNU"),
 		},
 	},


