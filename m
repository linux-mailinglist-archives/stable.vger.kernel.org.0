Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A3E44E75F5
	for <lists+stable@lfdr.de>; Fri, 25 Mar 2022 16:08:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354652AbiCYPJs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 11:09:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359635AbiCYPHm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 11:07:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFD58DA0AC;
        Fri, 25 Mar 2022 08:05:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 54830B828FA;
        Fri, 25 Mar 2022 15:05:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A307BC340E9;
        Fri, 25 Mar 2022 15:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648220749;
        bh=N6vwkSNiAupxcI7UazzCb8LR9f1mJCzrDjlRy+SPIZw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k3XNn44D+tXgA9Z1ZvyMeGoMPJGome2IcCfMz1p5aEsfSUK6Wc+/tt81wGfC2sJSS
         MbRlVLBe61MCel27CMNbUN/ZkQtUtLcuwzXjw7BXx7twWXGseY/bLJkGfC3gbVCbG/
         4lNcbnSqfdspDwLjBaZuU7CMGkshN5stxglK6EQg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maximilian Luz <luzmaximilian@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 4.14 14/17] ACPI: battery: Add device HID and quirk for Microsoft Surface Go 3
Date:   Fri, 25 Mar 2022 16:04:48 +0100
Message-Id: <20220325150417.177656495@linuxfoundation.org>
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

From: Maximilian Luz <luzmaximilian@gmail.com>

commit 7dacee0b9efc8bd061f097b1a8d4daa6591af0c6 upstream.

For some reason, the Microsoft Surface Go 3 uses the standard ACPI
interface for battery information, but does not use the standard PNP0C0A
HID. Instead it uses MSHW0146 as identifier. Add that ID to the driver
as this seems to work well.

Additionally, the power state is not updated immediately after the AC
has been (un-)plugged, so add the respective quirk for that.

Signed-off-by: Maximilian Luz <luzmaximilian@gmail.com>
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/battery.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -89,6 +89,10 @@ enum acpi_battery_files {
 
 static const struct acpi_device_id battery_device_ids[] = {
 	{"PNP0C0A", 0},
+
+	/* Microsoft Surface Go 3 */
+	{"MSHW0146", 0},
+
 	{"", 0},
 };
 
@@ -1183,6 +1187,14 @@ static const struct dmi_system_id bat_dm
 			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire V5-573G"),
 		},
 	},
+	{
+		/* Microsoft Surface Go 3 */
+		.callback = battery_notification_delay_quirk,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Surface Go 3"),
+		},
+	},
 	{},
 };
 


