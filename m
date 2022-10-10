Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 791605F995E
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 09:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231720AbiJJHLd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 03:11:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231719AbiJJHLH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 03:11:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB6935D0C3;
        Mon, 10 Oct 2022 00:07:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B27C660E74;
        Mon, 10 Oct 2022 07:06:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6C7FC433D6;
        Mon, 10 Oct 2022 07:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665385605;
        bh=TVmifSLd598vBmFBbOOzT6/vPAVc43mXl5Lyo9GcfsA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R6EccrxsrIfWexeNBak+tUlhlOvw31noaVivhkRPNRapYeka35cmLJ+N/tVbtj+xJ
         3Kh518AKqzz0fCK/oT70aHV+UZQdu/DJKUkPhin/3BvW3pbTsxCuq6bzYHtw31Wqfj
         xstd0H89p9HWS3dXSR3fCiSqnmPiI3PK1eayUxQo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Krc <reg.krn@pkrc.net>,
        Hans de Goede <hdegoede@redhat.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5.19 41/48] gpiolib: acpi: Add a quirk for Asus UM325UAZ
Date:   Mon, 10 Oct 2022 09:05:39 +0200
Message-Id: <20221010070334.761150427@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221010070333.676316214@linuxfoundation.org>
References: <20221010070333.676316214@linuxfoundation.org>
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

commit 0ea76c401f9245ac209f1b1ce03a7e1fb9de36e5 upstream.

Asus UM325UAZ has GPIO 18 programmed as both an interrupt and a wake
source, but confirmed with internal team on this design this pin is
floating and shouldn't have been programmed. This causes lots of
spurious IRQs on the system and horrendous battery life.

Add a quirk to ignore attempts to program this pin on this system.

Reported-by: Pavel Krc <reg.krn@pkrc.net>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216208
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpiolib-acpi.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/gpio/gpiolib-acpi.c
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -1573,6 +1573,20 @@ static const struct dmi_system_id gpioli
 			.ignore_wake = "INT33FF:01@0",
 		},
 	},
+	{
+		/*
+		 * Interrupt storm caused from edge triggered floating pin
+		 * Found in BIOS UX325UAZ.300
+		 * https://bugzilla.kernel.org/show_bug.cgi?id=216208
+		 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ZenBook UX325UAZ_UM325UAZ"),
+		},
+		.driver_data = &(struct acpi_gpiolib_dmi_quirk) {
+			.ignore_interrupt = "AMDI0030:00@18",
+		},
+	},
 	{} /* Terminating entry */
 };
 


