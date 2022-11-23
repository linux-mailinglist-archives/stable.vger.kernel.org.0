Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3AC635DA0
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 13:47:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237051AbiKWMoH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 07:44:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237556AbiKWMnU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 07:43:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 518B967F59;
        Wed, 23 Nov 2022 04:41:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0950AB81F40;
        Wed, 23 Nov 2022 12:41:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FB97C433C1;
        Wed, 23 Nov 2022 12:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669207315;
        bh=VxTm3MxpMPyyN/3fO9f250rjVnY+Vey+f1Yno6Te7mw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HgAovSxRLj2F0hl8GpZHEjwAwgeQYQTtTIq/Jn2NOnaQ5sM8r8NWrsWvs+K3e635M
         spPql5eatS/DRatTrvU3QDOgriskHdxZDHjqt/vnnKMx91FD5f65HC/9s53soH9D7V
         9/puNyl1UP9SI0OUYdQMa6nuk5uTiG11AW16Glp5CLfxz6h+Y+siY7USS+kij3S8vz
         gGW57ffEcta8uD4caK1QnUD5ziVworVIGmeVmmTJ0tTan1CStqpObuifxaxjgeADRz
         z0KmtkyAEfw1v0QmT8JcfxLZUSPb2dN0eIh67/o6TYJ4/sIfsUir0x/tuGdgKWmgM+
         h69oBpp3N5sUg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maximilian Luz <luzmaximilian@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, markgross@kernel.org,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 25/44] platform/surface: aggregator_registry: Add support for Surface Pro 9
Date:   Wed, 23 Nov 2022 07:40:34 -0500
Message-Id: <20221123124057.264822-25-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221123124057.264822-1-sashal@kernel.org>
References: <20221123124057.264822-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maximilian Luz <luzmaximilian@gmail.com>

[ Upstream commit d076f30957b1d026e9f6340691624926db0d369d ]

Add device nodes to enable support for battery and charger status, the
ACPI platform profile, as well as internal and type-cover HID devices
(including sensors, touchpad, keyboard, and other miscellaneous devices)
on the Surface Pro 9.

This does not include support for a tablet-mode switch yet, as that is
now handled via the POS subsystem (unlike the Surface Pro 8, where it is
handled via the KIP subsystem) and therefore needs further changes.

While we're at it, also add the missing comment for the Surface Pro 8.

Signed-off-by: Maximilian Luz <luzmaximilian@gmail.com>
Link: https://lore.kernel.org/r/20221113185951.224759-2-luzmaximilian@gmail.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../surface/surface_aggregator_registry.c     | 21 +++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/platform/surface/surface_aggregator_registry.c b/drivers/platform/surface/surface_aggregator_registry.c
index 585911020cea..db82c2a7c567 100644
--- a/drivers/platform/surface/surface_aggregator_registry.c
+++ b/drivers/platform/surface/surface_aggregator_registry.c
@@ -268,6 +268,7 @@ static const struct software_node *ssam_node_group_sp7[] = {
 	NULL,
 };
 
+/* Devices for Surface Pro 8 */
 static const struct software_node *ssam_node_group_sp8[] = {
 	&ssam_node_root,
 	&ssam_node_hub_kip,
@@ -284,6 +285,23 @@ static const struct software_node *ssam_node_group_sp8[] = {
 	NULL,
 };
 
+/* Devices for Surface Pro 9 */
+static const struct software_node *ssam_node_group_sp9[] = {
+	&ssam_node_root,
+	&ssam_node_hub_kip,
+	&ssam_node_bat_ac,
+	&ssam_node_bat_main,
+	&ssam_node_tmp_pprof,
+	/* TODO: Tablet mode switch (via POS subsystem) */
+	&ssam_node_hid_kip_keyboard,
+	&ssam_node_hid_kip_penstash,
+	&ssam_node_hid_kip_touchpad,
+	&ssam_node_hid_kip_fwupd,
+	&ssam_node_hid_sam_sensors,
+	&ssam_node_hid_sam_ucm_ucsi,
+	NULL,
+};
+
 
 /* -- SSAM platform/meta-hub driver. ---------------------------------------- */
 
@@ -303,6 +321,9 @@ static const struct acpi_device_id ssam_platform_hub_match[] = {
 	/* Surface Pro 8 */
 	{ "MSHW0263", (unsigned long)ssam_node_group_sp8 },
 
+	/* Surface Pro 9 */
+	{ "MSHW0343", (unsigned long)ssam_node_group_sp9 },
+
 	/* Surface Book 2 */
 	{ "MSHW0107", (unsigned long)ssam_node_group_gen5 },
 
-- 
2.35.1

