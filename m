Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3A6558DE98
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 20:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345946AbiHISTg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 14:19:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347002AbiHISSN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 14:18:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54EF32F02E;
        Tue,  9 Aug 2022 11:07:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A0C9DB818C2;
        Tue,  9 Aug 2022 18:06:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA8F9C433C1;
        Tue,  9 Aug 2022 18:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660068398;
        bh=aGyKQPkfCYyDbbGaZ0fkMiRh36HetKAwNQbREqd4pEQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XAeiId7xSLOZWRBadoyutw8twlV35K4+cBEddEm3wxDUyJQu1O3eDS8pJZtpuBG5Q
         J/FR7jAk2dM543SeBV/iY548nzWP5Yhhs3WgB1IaMZ8wGebUzjjec10Q5jEkhRiNmO
         2EksnTNxVBYsIzHOBoHA5YEVhM5K5nbbcPfeKDaE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Werner Sembach <wse@tuxedocomputers.com>,
        Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.18 05/35] ACPI: video: Shortening quirk list by identifying Clevo by board_name only
Date:   Tue,  9 Aug 2022 20:00:34 +0200
Message-Id: <20220809175515.270042778@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220809175515.046484486@linuxfoundation.org>
References: <20220809175515.046484486@linuxfoundation.org>
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


