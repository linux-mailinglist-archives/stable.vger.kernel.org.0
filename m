Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7580F5F98F8
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 09:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231129AbiJJHEd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 03:04:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231211AbiJJHE3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 03:04:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4053457BCE;
        Mon, 10 Oct 2022 00:04:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4DF0460E33;
        Mon, 10 Oct 2022 07:04:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F70FC433C1;
        Mon, 10 Oct 2022 07:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665385450;
        bh=oZYqT3xUb1hjb2465mZZ2n6xZl4MUWJlOEtk+FXrmj0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RWzFVsAdUmHNrIOtpxL73B2ehl/Shszqze8k4SIfWJdrlk4a/lbhNPv38GhAcaLAW
         /JPDIa2mqNrBDSGU0CwRw36EhuS/X3mlbDds8f9Zi7brf3nxDGVULt4FloKk8tYWvz
         srtRGXwpvX2iK4OR4ccKbie6pmlyEw20zu1lts2M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Krc <reg.krn@pkrc.net>,
        Hans de Goede <hdegoede@redhat.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 6.0 12/17] gpiolib: acpi: Add a quirk for Asus UM325UAZ
Date:   Mon, 10 Oct 2022 09:04:35 +0200
Message-Id: <20221010070330.571554368@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221010070330.159911806@linuxfoundation.org>
References: <20221010070330.159911806@linuxfoundation.org>
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
@@ -1576,6 +1576,20 @@ static const struct dmi_system_id gpioli
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
 


