Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 708804E75CB
	for <lists+stable@lfdr.de>; Fri, 25 Mar 2022 16:07:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359334AbiCYPI1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 11:08:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359638AbiCYPHo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 11:07:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9012DA0BA;
        Fri, 25 Mar 2022 08:05:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7237D61BAD;
        Fri, 25 Mar 2022 15:05:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DD6BC340EE;
        Fri, 25 Mar 2022 15:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648220751;
        bh=66AdW8GcQDhDYieYXbj02QTCFM70zra0bL3GJGGU1Ls=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e9lvTjf0YXfogpCAfL2mCHKCM8q1nQKfpchTpeAPLEnLN7agEaEwlG9n7x7UwgdS1
         K8L/A1fBvTILZ+dzb0K/1FNyHymioHMCw4l2mYDMDdg/Nv/sINoB5CvtOWAIGMZrcK
         AsKZWQ3scq5sCrvPLHJd03lX8Ip2hhbvIwbotVGo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Werner Sembach <wse@tuxedocomputers.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 4.14 15/17] ACPI: video: Force backlight native for Clevo NL5xRU and NL5xNU
Date:   Fri, 25 Mar 2022 16:04:49 +0100
Message-Id: <20220325150417.205330098@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220325150416.756136126@linuxfoundation.org>
References: <20220325150416.756136126@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Werner Sembach <wse@tuxedocomputers.com>

commit c844d22fe0c0b37dc809adbdde6ceb6462c43acf upstream.

Clevo NL5xRU and NL5xNU/TUXEDO Aura 15 Gen1 and Gen2 have both a working
native and video interface. However the default detection mechanism first
registers the video interface before unregistering it again and switching
to the native interface during boot. This results in a dangling SBIOS
request for backlight change for some reason, causing the backlight to
switch to ~2% once per boot on the first power cord connect or disconnect
event. Setting the native interface explicitly circumvents this buggy
behaviour by avoiding the unregistering process.

Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/video_detect.c |   75 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 75 insertions(+)

--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -356,6 +356,81 @@ static const struct dmi_system_id video_
 		DMI_MATCH(DMI_BOARD_NAME, "BA51_MV"),
 		},
 	},
+	/*
+	 * Clevo NL5xRU and NL5xNU/TUXEDO Aura 15 Gen1 and Gen2 have both a
+	 * working native and video interface. However the default detection
+	 * mechanism first registers the video interface before unregistering
+	 * it again and switching to the native interface during boot. This
+	 * results in a dangling SBIOS request for backlight change for some
+	 * reason, causing the backlight to switch to ~2% once per boot on the
+	 * first power cord connect or disconnect event. Setting the native
+	 * interface explicitly circumvents this buggy behaviour, by avoiding
+	 * the unregistering process.
+	 */
+	{
+	.callback = video_detect_force_native,
+	.ident = "Clevo NL5xRU",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "TUXEDO"),
+		DMI_MATCH(DMI_BOARD_NAME, "NL5xRU"),
+		},
+	},
+	{
+	.callback = video_detect_force_native,
+	.ident = "Clevo NL5xRU",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "SchenkerTechnologiesGmbH"),
+		DMI_MATCH(DMI_BOARD_NAME, "NL5xRU"),
+		},
+	},
+	{
+	.callback = video_detect_force_native,
+	.ident = "Clevo NL5xRU",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Notebook"),
+		DMI_MATCH(DMI_BOARD_NAME, "NL5xRU"),
+		},
+	},
+	{
+	.callback = video_detect_force_native,
+	.ident = "Clevo NL5xRU",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "TUXEDO"),
+		DMI_MATCH(DMI_BOARD_NAME, "AURA1501"),
+		},
+	},
+	{
+	.callback = video_detect_force_native,
+	.ident = "Clevo NL5xRU",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "TUXEDO"),
+		DMI_MATCH(DMI_BOARD_NAME, "EDUBOOK1502"),
+		},
+	},
+	{
+	.callback = video_detect_force_native,
+	.ident = "Clevo NL5xNU",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "TUXEDO"),
+		DMI_MATCH(DMI_BOARD_NAME, "NL5xNU"),
+		},
+	},
+	{
+	.callback = video_detect_force_native,
+	.ident = "Clevo NL5xNU",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "SchenkerTechnologiesGmbH"),
+		DMI_MATCH(DMI_BOARD_NAME, "NL5xNU"),
+		},
+	},
+	{
+	.callback = video_detect_force_native,
+	.ident = "Clevo NL5xNU",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Notebook"),
+		DMI_MATCH(DMI_BOARD_NAME, "NL5xNU"),
+		},
+	},
 
 	/*
 	 * Desktops which falsely report a backlight and which our heuristics


