Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C803664978
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:22:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239281AbjAJSV7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:21:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239274AbjAJSVc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:21:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77F5597495
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:19:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2CC07B81901
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:19:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CB28C433D2;
        Tue, 10 Jan 2023 18:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374748;
        bh=imEYwgAC/dH8lSJZo74E+eAnfm3WoSPBrWYHOX4C0rg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ticTbfQ0CfCYGHeAYNwB1dxwmrtXvsNaghZz1D4fuLdOvsic43I/jRCA4HrCpxLUI
         j6cTgQdJL3TE/xA+HfK1CVSNDOYkQHHSnnI8hXZWVUaf/ILTwOocPEf1JK4FF/sglN
         m426sck5UnC5Hc47yGJUgIcbfCPtJsgD7P9gZ/2Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hans de Goede <hdegoede@redhat.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 120/159] ACPI: video: Dont enable fallback path for creating ACPI backlight by default
Date:   Tue, 10 Jan 2023 19:04:28 +0100
Message-Id: <20230110180022.134187184@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
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

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 5aa9d943e9b6bf6e6023645cbe7ce7d5ed84baf4 ]

The ACPI video detection code has a module parameter
`register_backlight_delay` which is currently configured to 8 seconds.
This means that if after 8 seconds of booting no native driver has created
a backlight device then the code will attempt to make an ACPI video
backlight device.

This was intended as a safety mechanism with the backlight overhaul that
occurred in kernel 6.1, but as it doesn't appear necesssary set it to be
disabled by default.

Suggested-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_video.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/acpi/acpi_video.c b/drivers/acpi/acpi_video.c
index f64fdb029090..0c79f463fbfd 100644
--- a/drivers/acpi/acpi_video.c
+++ b/drivers/acpi/acpi_video.c
@@ -70,11 +70,7 @@ module_param(device_id_scheme, bool, 0444);
 static int only_lcd = -1;
 module_param(only_lcd, int, 0444);
 
-/*
- * Display probing is known to take up to 5 seconds, so delay the fallback
- * backlight registration by 5 seconds + 3 seconds for some extra margin.
- */
-static int register_backlight_delay = 8;
+static int register_backlight_delay;
 module_param(register_backlight_delay, int, 0444);
 MODULE_PARM_DESC(register_backlight_delay,
 	"Delay in seconds before doing fallback (non GPU driver triggered) "
-- 
2.35.1



