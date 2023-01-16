Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A32EE66C4AF
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 16:57:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231727AbjAPP5k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 10:57:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231751AbjAPP5T (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 10:57:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1C3B234DB
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 07:57:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F88961031
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 15:57:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 839F2C433F1;
        Mon, 16 Jan 2023 15:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884620;
        bh=REm43g9/hhxTTixIY3YK/AGtqEdZNUCXFeFsyxNv7iQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cif2kwv5uI0Y21NSG424WqNofHaUmMpB1pu1weALE82klhMAWwTjNBpzdoWKr3j60
         bVUnspIG16KgM21XCO3zqkyndjwrBPhLfsUbCg4mY6iX9WXk+5xBzRFbx6fZIqYmqs
         3OFgM/VYH86CzAuT+5Hi71+BKvyRJjrzzG0DPreQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.1 045/183] ACPI: video: Allow selecting NVidia-WMI-EC or Apple GMUX backlight from the cmdline
Date:   Mon, 16 Jan 2023 16:49:28 +0100
Message-Id: <20230116154805.278150158@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

commit 420a1116aef0e8e12c305508f45ce73e5ae30a09 upstream.

The patches adding NVidia-WMI-EC and Apple GMUX backlight detection
support to acpi_video_get_backlight_type(), forgot to update
acpi_video_parse_cmdline() to allow manually selecting these from
the commandline.

Add support for these to acpi_video_parse_cmdline().

Fixes: fe7aebb40d42 ("ACPI: video: Add Nvidia WMI EC brightness control detection (v3)")
Fixes: 21245df307cb ("ACPI: video: Add Apple GMUX brightness control detection")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/video_detect.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index 1b78c7434492..8a541efc5675 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -50,6 +50,10 @@ static void acpi_video_parse_cmdline(void)
 		acpi_backlight_cmdline = acpi_backlight_video;
 	if (!strcmp("native", acpi_video_backlight_string))
 		acpi_backlight_cmdline = acpi_backlight_native;
+	if (!strcmp("nvidia_wmi_ec", acpi_video_backlight_string))
+		acpi_backlight_cmdline = acpi_backlight_nvidia_wmi_ec;
+	if (!strcmp("apple_gmux", acpi_video_backlight_string))
+		acpi_backlight_cmdline = acpi_backlight_apple_gmux;
 	if (!strcmp("none", acpi_video_backlight_string))
 		acpi_backlight_cmdline = acpi_backlight_none;
 }
-- 
2.39.0



