Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 316505AB091
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237983AbiIBMym (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:54:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237811AbiIBMxb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:53:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D999FE3979;
        Fri,  2 Sep 2022 05:38:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DDF566217E;
        Fri,  2 Sep 2022 12:37:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5FA4C433C1;
        Fri,  2 Sep 2022 12:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662122258;
        bh=4Mef6oIVxypHg+mAHZHx0JWOr5/CBtzWkSoMACY3YZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V7a+TT/xmchhADjHRmBzZTAFc8ALdcJ5XYw15Lf9Db6Z1Q+d1hE90zki3xunMHQgb
         XV3TIALyEkQmbtxao9DhfFXCEge3bjCn8A/DOBsf1IpMOznW8HJHoiFBo7mo94BjZF
         vkjtgNZRAQW9Df0W4yyR9TMKNRaDbq02mSNxWHaE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Akihiko Odaki <akihiko.odaki@gmail.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 5.19 22/72] HID: AMD_SFH: Add a DMI quirk entry for Chromebooks
Date:   Fri,  2 Sep 2022 14:18:58 +0200
Message-Id: <20220902121405.511661631@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121404.772492078@linuxfoundation.org>
References: <20220902121404.772492078@linuxfoundation.org>
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
@@ -285,11 +285,29 @@ static int amd_sfh_irq_init(struct amd_m
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


