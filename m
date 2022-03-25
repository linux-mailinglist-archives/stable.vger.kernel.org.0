Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2F834E7744
	for <lists+stable@lfdr.de>; Fri, 25 Mar 2022 16:26:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354956AbiCYP1m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 11:27:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377879AbiCYPYk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 11:24:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1298EA75C;
        Fri, 25 Mar 2022 08:19:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64781B828FA;
        Fri, 25 Mar 2022 15:19:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A74C2C340F7;
        Fri, 25 Mar 2022 15:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648221549;
        bh=Pg6em72K018Eqof3c8I+K4jp9DCN9Fb0iTpcS+ryPf0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g36v0mwW/ROErRAkrKpCF88WwIzFOHAtDK5DOgpkMy5gqlqex1xqV3MbTPlZCbVDs
         hB/qVusesjlL6+dTwoAakwbWKZzTAmLG++YRz044Z0oCxNVN1/SejOKe7HYC0JtrYd
         vdu91dM8uVRPeF4nrosI9H1ZfWeiQCYzGKh5F3rI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Werner Sembach <wse@tuxedocomputers.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.17 24/39] ACPI: video: Force backlight native for Clevo NL5xRU and NL5xNU
Date:   Fri, 25 Mar 2022 16:14:39 +0100
Message-Id: <20220325150420.934066864@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220325150420.245733653@linuxfoundation.org>
References: <20220325150420.245733653@linuxfoundation.org>
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
@@ -415,6 +415,81 @@ static const struct dmi_system_id video_
 		DMI_MATCH(DMI_PRODUCT_NAME, "GA503"),
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


