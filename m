Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D91AA635E81
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 13:57:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237917AbiKWMsE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 07:48:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238042AbiKWMrW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 07:47:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 874496C705;
        Wed, 23 Nov 2022 04:43:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3CF1EB81F5C;
        Wed, 23 Nov 2022 12:43:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47742C433C1;
        Wed, 23 Nov 2022 12:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669207400;
        bh=9feipTEZVnmKr0so6fmonGOFjbgcUpUFTTVeyL8nBlk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qNTEgGZuch2jf3MmWjcQiU6bT2o2CkCaWZyhAhHWqbNLqM2f/Ovb0nwyOg5JB0Gp7
         sp4GMQZ/V2ZghlDxMvadrAcjG1inZlZk3kn6sXf/ze3lkVaZpr4SDxVHYJuxSlvrI5
         3ZM+MZhCtxIf45JYS8FQCAAcEVcA+dxq7WIZrF62xG9Cdhp4Bwj6+kaYD24qomo7xS
         BUYxHRJtrJa+/1Y7ivzC7+DviIYkk4XgmyTmL3HikjFh5+ahGXhB2qjeATt6Y2hVF2
         3S/seMxjMWwE1Qkzu0TNWc5xxTxLk9qrgaxEtuGrP31Oxa1OFA1+q161N9TPVLMlzD
         jGLjzthdRdT0w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maximilian Luz <luzmaximilian@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, markgross@kernel.org,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 19/31] platform/surface: aggregator_registry: Add support for Surface Laptop 5
Date:   Wed, 23 Nov 2022 07:42:20 -0500
Message-Id: <20221123124234.265396-19-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221123124234.265396-1-sashal@kernel.org>
References: <20221123124234.265396-1-sashal@kernel.org>
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

[ Upstream commit 4a567d164d0e0c57e7b694b988db86361f130cb7 ]

Add device nodes to enable support for battery and charger status, the
ACPI platform profile, as well as internal HID devices (including
touchpad and keyboard) on the Surface Laptop 5.

Signed-off-by: Maximilian Luz <luzmaximilian@gmail.com>
Link: https://lore.kernel.org/r/20221115231440.1338142-1-luzmaximilian@gmail.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../surface/surface_aggregator_registry.c        | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/platform/surface/surface_aggregator_registry.c b/drivers/platform/surface/surface_aggregator_registry.c
index 5c0451c56ea8..0964c42c0281 100644
--- a/drivers/platform/surface/surface_aggregator_registry.c
+++ b/drivers/platform/surface/surface_aggregator_registry.c
@@ -195,6 +195,19 @@ static const struct software_node *ssam_node_group_sl3[] = {
 	NULL,
 };
 
+/* Devices for Surface Laptop 5. */
+static const struct software_node *ssam_node_group_sl5[] = {
+	&ssam_node_root,
+	&ssam_node_bat_ac,
+	&ssam_node_bat_main,
+	&ssam_node_tmp_pprof,
+	&ssam_node_hid_main_keyboard,
+	&ssam_node_hid_main_touchpad,
+	&ssam_node_hid_main_iid5,
+	&ssam_node_hid_sam_ucm_ucsi,
+	NULL,
+};
+
 /* Devices for Surface Laptop Studio. */
 static const struct software_node *ssam_node_group_sls[] = {
 	&ssam_node_root,
@@ -555,6 +568,9 @@ static const struct acpi_device_id ssam_platform_hub_match[] = {
 	/* Surface Laptop 4 (13", Intel) */
 	{ "MSHW0250", (unsigned long)ssam_node_group_sl3 },
 
+	/* Surface Laptop 5 */
+	{ "MSHW0350", (unsigned long)ssam_node_group_sl5 },
+
 	/* Surface Laptop Go 1 */
 	{ "MSHW0118", (unsigned long)ssam_node_group_slg1 },
 
-- 
2.35.1

