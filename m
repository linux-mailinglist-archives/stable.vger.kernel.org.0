Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEEEB6583D4
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:52:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234661AbiL1Qwt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:52:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235021AbiL1Qvi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:51:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1A6C205C4
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:46:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 87C7C60D41
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:46:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 935F0C433EF;
        Wed, 28 Dec 2022 16:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245968;
        bh=joUiXrawmAJHiaVDfPQdm0pzrZtel83AWOUVXLSsXaw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KZ+8VAyjk3VozFvwJRuh+k9sfXuKc2A4/gz9qHE3YV7k3TJ1p2VEtwmmcxjnTY9Hn
         r5JrYYLpxvDvscx3QFYVTZPhtAM+1CRzokazmhvNIKaK1ZBbzngnXYWk+KfO2Aij5E
         7HJCVYJJg3mNw2S1Odmv6ssEgIIrzAsHYiQTl2bw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0955/1146] ACPI: video: Add force_vendor quirk for Sony Vaio PCG-FRV35
Date:   Wed, 28 Dec 2022 15:41:34 +0100
Message-Id: <20221228144356.259328375@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

[ Upstream commit 23735543eb228c604e59f99f2f5d13aa507e5db2 ]

The Sony Vaio PCG-FRV35 advertises both native and vendor backlight
control interfaces. With the upcoming changes to prefer native over
vendor acpi_video_get_backlight_type() will start returning native on
these laptops.

But the native radeon_bl0 interface does not work, where as the sony
vendor interface does work. Add a quirk to force use of the vendor
interface.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/video_detect.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index 0ab98f2e484c..8e8b435b4c8c 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -237,6 +237,19 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
 		},
 	},
 
+	/*
+	 * Models which should use the vendor backlight interface,
+	 * because of broken native backlight control.
+	 */
+	{
+	 .callback = video_detect_force_vendor,
+	 /* Sony Vaio PCG-FRV35 */
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "PCG-FRV35"),
+		},
+	},
+
 	/*
 	 * Toshiba models with Transflective display, these need to use
 	 * the toshiba_acpi vendor driver for proper Transflective handling.
-- 
2.35.1



