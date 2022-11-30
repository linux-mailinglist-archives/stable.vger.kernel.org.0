Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BC4763DE2D
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:34:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbiK3Ser (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:34:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230337AbiK3SeU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:34:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4250126545
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:34:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EAE33B81B37
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:34:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54E73C433C1;
        Wed, 30 Nov 2022 18:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833257;
        bh=byvrxZJaj1l/XHn81nDgB0ZoJzO1qFy058Lqec5jzrU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1OVQcEumKqZhDXdBv733qNAYKvdcVstffuWf9GOGl+Chwtq0Bgia66LOJErY6psBi
         yCmHdHNWVDywHOehVs8Dil25x8+f4s4ytT0K/IqxBk5pip8abVmppRjSnxA6AnUYKC
         TCBlqIvaXZRG36uS5ajijRjDAi/MKTPpfBXC8Jac=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 042/206] platform/x86: touchscreen_dmi: Add info for the RCA Cambio W101 v2 2-in-1
Date:   Wed, 30 Nov 2022 19:21:34 +0100
Message-Id: <20221130180534.066962379@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
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

[ Upstream commit 0df044b34bf33e7e35c32b3bf6747fde6279c162 ]

Add touchscreen info for the RCA Cambio W101 v2 2-in-1.

Link: https://github.com/onitake/gsl-firmware/discussions/193
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20221025141131.509211-1-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/touchscreen_dmi.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/platform/x86/touchscreen_dmi.c b/drivers/platform/x86/touchscreen_dmi.c
index c608078538a7..3d0790263fa7 100644
--- a/drivers/platform/x86/touchscreen_dmi.c
+++ b/drivers/platform/x86/touchscreen_dmi.c
@@ -773,6 +773,22 @@ static const struct ts_dmi_data predia_basic_data = {
 	.properties	= predia_basic_props,
 };
 
+static const struct property_entry rca_cambio_w101_v2_props[] = {
+	PROPERTY_ENTRY_U32("touchscreen-min-x", 4),
+	PROPERTY_ENTRY_U32("touchscreen-min-y", 20),
+	PROPERTY_ENTRY_U32("touchscreen-size-x", 1644),
+	PROPERTY_ENTRY_U32("touchscreen-size-y", 874),
+	PROPERTY_ENTRY_BOOL("touchscreen-swapped-x-y"),
+	PROPERTY_ENTRY_STRING("firmware-name", "gsl1680-rca-cambio-w101-v2.fw"),
+	PROPERTY_ENTRY_U32("silead,max-fingers", 10),
+	{ }
+};
+
+static const struct ts_dmi_data rca_cambio_w101_v2_data = {
+	.acpi_name = "MSSL1680:00",
+	.properties = rca_cambio_w101_v2_props,
+};
+
 static const struct property_entry rwc_nanote_p8_props[] = {
 	PROPERTY_ENTRY_U32("touchscreen-min-y", 46),
 	PROPERTY_ENTRY_U32("touchscreen-size-x", 1728),
@@ -1394,6 +1410,15 @@ const struct dmi_system_id touchscreen_dmi_table[] = {
 			DMI_EXACT_MATCH(DMI_BOARD_NAME, "0E57"),
 		},
 	},
+	{
+		/* RCA Cambio W101 v2 */
+		/* https://github.com/onitake/gsl-firmware/discussions/193 */
+		.driver_data = (void *)&rca_cambio_w101_v2_data,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "RCA"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "W101SA23T1"),
+		},
+	},
 	{
 		/* RWC NANOTE P8 */
 		.driver_data = (void *)&rwc_nanote_p8_data,
-- 
2.35.1



