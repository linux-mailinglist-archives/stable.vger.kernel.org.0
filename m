Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6CE85AAFDD
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:45:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237417AbiIBMoo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:44:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237497AbiIBMnr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:43:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05971EE4B8;
        Fri,  2 Sep 2022 05:32:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4892AB829D6;
        Fri,  2 Sep 2022 12:32:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 720A8C433D7;
        Fri,  2 Sep 2022 12:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121946;
        bh=nAFQXR6FKb7GWONOHbeFzz6f5h+d++8SCDKGn73rIdA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AAnyc0lyHGVvVuvxucVr1IkWe1bCXBED2ldyum74ELiHvv3ogZUrk5B41ofapCDmB
         Hmai8oShJBQ4kkcCTc/212H0b+VWyyr60fR962Uq5M3iIND5j94/MrqFKyAPducPt/
         vBwxYdt78bIlYyJADGrpXmoZ/joGOyhMeBB5mGGQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Akihiko Odaki <akihiko.odaki@gmail.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 5.15 38/73] HID: AMD_SFH: Add a DMI quirk entry for Chromebooks
Date:   Fri,  2 Sep 2022 14:19:02 +0200
Message-Id: <20220902121405.690814722@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121404.435662285@linuxfoundation.org>
References: <20220902121404.435662285@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Akihiko Odaki <akihiko.odaki@gmail.com>

commit adada3f4930ac084740ea340bd8e94028eba4f22 upstream.

Google Chromebooks use Chrome OS Embedded Controller Sensor Hub instead
of Sensor Hub Fusion and leaves MP2 uninitialized, which disables all
functionalities, even including the registers necessary for feature
detections.

The behavior was observed with Lenovo ThinkPad C13 Yoga.

Signed-off-by: Akihiko Odaki <akihiko.odaki@gmail.com>
Suggested-by: Mario Limonciello <mario.limonciello@amd.com>
Acked-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/amd-sfh-hid/amd_sfh_pcie.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
+++ b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
@@ -281,11 +281,29 @@ static int amd_sfh_irq_init(struct amd_m
 	return 0;
 }
 
+static const struct dmi_system_id dmi_nodevs[] = {
+	{
+		/*
+		 * Google Chromebooks use Chrome OS Embedded Controller Sensor
+		 * Hub instead of Sensor Hub Fusion and leaves MP2
+		 * uninitialized, which disables all functionalities, even
+		 * including the registers necessary for feature detections.
+		 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Google"),
+		},
+	},
+	{ }
+};
+
 static int amd_mp2_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct amd_mp2_dev *privdata;
 	int rc;
 
+	if (dmi_first_match(dmi_nodevs))
+		return -ENODEV;
+
 	privdata = devm_kzalloc(&pdev->dev, sizeof(*privdata), GFP_KERNEL);
 	if (!privdata)
 		return -ENOMEM;


