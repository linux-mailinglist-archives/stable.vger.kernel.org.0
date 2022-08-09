Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A605258DEF0
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 20:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343537AbiHIS2i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 14:28:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347513AbiHIS1Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 14:27:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 858BC33A15;
        Tue,  9 Aug 2022 11:10:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 133FEB81A1F;
        Tue,  9 Aug 2022 18:08:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C9FBC433C1;
        Tue,  9 Aug 2022 18:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660068484;
        bh=aGyKQPkfCYyDbbGaZ0fkMiRh36HetKAwNQbREqd4pEQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=alEZAvKOFRzCSmI+hkmqYkOvAqf8zs8oTfjNv8IeEKOKjb0EpPEoTXSbQjJd4NqOi
         /+z3Y8LLAMBIlYxDv92PNFZy37cg94kLfJnqfRY9+Mk+ijF/Xq5NjaJF2jFXH3Hc4e
         weyaZr3+H4BT7X9M9dRG8XnRbTrhqyzHHuv7nM6o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Werner Sembach <wse@tuxedocomputers.com>,
        Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.19 04/21] ACPI: video: Shortening quirk list by identifying Clevo by board_name only
Date:   Tue,  9 Aug 2022 20:00:56 +0200
Message-Id: <20220809175513.483299368@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220809175513.345597655@linuxfoundation.org>
References: <20220809175513.345597655@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
@@ -430,23 +430,6 @@ static const struct dmi_system_id video_
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
@@ -470,23 +453,6 @@ static const struct dmi_system_id video_
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


