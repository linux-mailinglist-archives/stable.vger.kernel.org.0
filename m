Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF9AA6583CA
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:52:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235146AbiL1QwU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:52:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231183AbiL1Qv4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:51:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 367EF2098C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:46:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D1137B8171F
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:46:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B884C433D2;
        Wed, 28 Dec 2022 16:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245976;
        bh=0Dowszw+M3xbVXpxd9r+vcp2wE7GhUHIdP1j3o9nBQk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uk4xGhZPnYCH6lTXr/0p/U019r6zumZWYZNS6Hy9wcAtnJYxnW7YWIKtAC2/mxAcn
         X4YamSxvBchion8dArrJWhLgVFSYYo8NuUOOi9lL4r/w8sw8bh8qiSI5Wi2hl70ozr
         vMnw3AbxA5Trwuqzw1xL13YBO49EeyK1Alx2xph0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Stefan Joosten <stefan@atcomputing.nl>,
        Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0956/1146] ACPI: video: Add force_native quirk for Sony Vaio VPCY11S1E
Date:   Wed, 28 Dec 2022 15:41:35 +0100
Message-Id: <20221228144356.287119083@linuxfoundation.org>
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

[ Upstream commit f5a6ff923d4a1d639da36228d00e95ff67d417f0 ]

The Sony Vaio VPCY11S1E advertises both native and ACPI video backlight
control interfaces, but only the native interface works and the default
heuristics end up picking ACPI video on this model.

Add a video_detect_force_native DMI quirk for this.

Reported-by: Stefan Joosten <stefan@atcomputing.nl>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/video_detect.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index 8e8b435b4c8c..ffa19d418847 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -619,6 +619,14 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
 		DMI_MATCH(DMI_PRODUCT_NAME, "VPCEH3U1E"),
 		},
 	},
+	{
+	 .callback = video_detect_force_native,
+	 /* Sony Vaio VPCY11S1E */
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "VPCY11S1E"),
+		},
+	},
 
 	/*
 	 * These Toshibas have a broken acpi-video interface for brightness
-- 
2.35.1



