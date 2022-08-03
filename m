Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75670588BE1
	for <lists+stable@lfdr.de>; Wed,  3 Aug 2022 14:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237844AbiHCMSZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Aug 2022 08:18:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237843AbiHCMSY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Aug 2022 08:18:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56ABF32DB4
        for <stable@vger.kernel.org>; Wed,  3 Aug 2022 05:18:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0D77CB8218B
        for <stable@vger.kernel.org>; Wed,  3 Aug 2022 12:18:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7436DC433C1;
        Wed,  3 Aug 2022 12:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659529100;
        bh=bMSOkvyQL4V7A+xpPgAL3CqkCZgJ6SLJ2lt/sZyg5z4=;
        h=Subject:To:Cc:From:Date:From;
        b=Ps/yMTeT5S94ByyD5tDrUftiMaw3Ix7Fh1XnofT4JzFDupGW8llkU8bk0KBDkg7p5
         d+u2mVJgdQ0XITv12bCMNjZPXNP/N91QR6rsufA/G8NRNJLkftNQWvVxJ52yv/Mzq9
         GTraj0aqCChe2XPo/8ZDyOcmqmcfwkQjSoY8iSl8=
Subject: FAILED: patch "[PATCH] ACPI: video: Shortening quirk list by identifying Clevo by" failed to apply to 4.9-stable tree
To:     wse@tuxedocomputers.com, hdegoede@redhat.com,
        rafael.j.wysocki@intel.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 03 Aug 2022 14:18:15 +0200
Message-ID: <1659529095141225@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f0341e67b3782603737f7788e71bd3530012a4f4 Mon Sep 17 00:00:00 2001
From: Werner Sembach <wse@tuxedocomputers.com>
Date: Thu, 7 Jul 2022 20:09:53 +0200
Subject: [PATCH] ACPI: video: Shortening quirk list by identifying Clevo by
 board_name only

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

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index cdde2e069d63..6615f59ab7fd 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -430,23 +430,6 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
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
@@ -470,23 +453,6 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
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

