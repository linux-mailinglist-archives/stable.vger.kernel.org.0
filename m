Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19F935B4922
	for <lists+stable@lfdr.de>; Sat, 10 Sep 2022 23:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbiIJVRd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Sep 2022 17:17:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbiIJVRK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Sep 2022 17:17:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18CD04D14F;
        Sat, 10 Sep 2022 14:16:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D42AA60DF0;
        Sat, 10 Sep 2022 21:16:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 285E1C4347C;
        Sat, 10 Sep 2022 21:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662844607;
        bh=a7TFOgTGplUjVrxVCUYkBfqXu+cTKnaF+lMxMUV0be4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S6maoNf0zAk3hvEHtp6YBTliaEs6frkGoaMuL4EV2FKl1o6N3BoTx9L3Fsjn8LtsZ
         TFurWK0ACjyI8/g54oW0Ob8FQQYUYYBhUElnejVeHj3QHhg8iUUSIAJag99eIcE+Zn
         9Tneq1MSlgcN0G6ccY411g1F/EHX1HT4KMHtNJG6E0iCX17cw2idYb9h1Y5XEQ5Kf2
         QgjCEd/WuMpzYgHr/2UfBugzojpp5F+QdN3H8BRW7ShmCRZ39yScxzEAJHU4pHrPHS
         KZGSxa9xQQjbu7R4p6cl/OhjLU1zHiKmFccqWXa8sfDQFiI5OOlan/FG81snIttUVw
         s83Qxnnj3yQfg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Akihiko Odaki <akihiko.odaki@gmail.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        basavaraj.natikar@amd.com, jikos@kernel.org,
        benjamin.tissoires@redhat.com, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 13/38] HID: AMD_SFH: Add a DMI quirk entry for Chromebooks
Date:   Sat, 10 Sep 2022 17:15:58 -0400
Message-Id: <20220910211623.69825-13-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220910211623.69825-1-sashal@kernel.org>
References: <20220910211623.69825-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

[ Upstream commit adada3f4930ac084740ea340bd8e94028eba4f22 ]

Google Chromebooks use Chrome OS Embedded Controller Sensor Hub instead
of Sensor Hub Fusion and leaves MP2 uninitialized, which disables all
functionalities, even including the registers necessary for feature
detections.

The behavior was observed with Lenovo ThinkPad C13 Yoga.

Signed-off-by: Akihiko Odaki <akihiko.odaki@gmail.com>
Suggested-by: Mario Limonciello <mario.limonciello@amd.com>
Acked-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/amd-sfh-hid/amd_sfh_pcie.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
index 1441787a154a8..9b97dc0695e3a 100644
--- a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
+++ b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
@@ -285,11 +285,29 @@ static int amd_sfh_irq_init(struct amd_mp2_dev *privdata)
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
-- 
2.35.1

