Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85F0D63540C
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:02:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236866AbiKWJAh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:00:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236858AbiKWJAh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:00:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C04AEC0A5
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:00:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C4D93B81EEE
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:00:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED970C433B5;
        Wed, 23 Nov 2022 09:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669194033;
        bh=Q1WaxMiMcbZQY7LKlC7BedkIiz5EGadxxOn5pqxwv7k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TQFEAreqg1Whe+N9f1lDFd4dmdafw6bzsxITMILRo4u1z4xgRvEYhedVjzP8N88qd
         cSzqkfLgrZogqbhPozrhnE50dFV27OVkn0/Dj+xo71ng8C8UCop3M3XGyJrFqVvMod
         lUlkesTO2g1dEl/pHf8V5GT2OnFYfeL63oSqUIcU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jorge Lopez <jorge.lopez2@hp.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 4.14 22/88] platform/x86: hp_wmi: Fix rfkill causing soft blocked wifi
Date:   Wed, 23 Nov 2022 09:50:19 +0100
Message-Id: <20221123084549.265656044@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084548.535439312@linuxfoundation.org>
References: <20221123084548.535439312@linuxfoundation.org>
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

From: Jorge Lopez <jorge.lopez2@hp.com>

commit 1598bfa8e1faa932de42e1ee7628a1c4c4263f0a upstream.

After upgrading BIOS to U82 01.02.01 Rev.A, the console is flooded
strange char "^@" which printed out every second and makes login
nearly impossible. Also the below messages were shown both in console
and journal/dmesg every second:

usb 1-3: Device not responding to setup address.
usb 1-3: device not accepting address 4, error -71
usb 1-3: device descriptor read/all, error -71
usb usb1-port3: unable to enumerate USB device

Wifi is soft blocked by checking rfkill. When unblocked manually,
after few seconds it would be soft blocked again. So I was suspecting
something triggered rfkill to soft block wifi.  At the end it was
fixed by removing hp_wmi module.

The root cause is the way hp-wmi driver handles command 1B on
post-2009 BIOS.  In pre-2009 BIOS, command 1Bh return 0x4 to indicate
that BIOS no longer controls the power for the wireless devices.

Signed-off-by: Jorge Lopez <jorge.lopez2@hp.com>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216468
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20221028155527.7724-1-jorge.lopez2@hp.com
Cc: stable@vger.kernel.org
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/hp-wmi.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/platform/x86/hp-wmi.c
+++ b/drivers/platform/x86/hp-wmi.c
@@ -894,8 +894,16 @@ static int __init hp_wmi_bios_setup(stru
 	wwan_rfkill = NULL;
 	rfkill2_count = 0;
 
-	if (hp_wmi_rfkill_setup(device))
-		hp_wmi_rfkill2_setup(device);
+	/*
+	 * In pre-2009 BIOS, command 1Bh return 0x4 to indicate that
+	 * BIOS no longer controls the power for the wireless
+	 * devices. All features supported by this command will no
+	 * longer be supported.
+	 */
+	if (!hp_wmi_bios_2009_later()) {
+		if (hp_wmi_rfkill_setup(device))
+			hp_wmi_rfkill2_setup(device);
+	}
 
 	err = device_create_file(&device->dev, &dev_attr_display);
 	if (err)


