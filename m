Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A42CA635E3D
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 13:57:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238149AbiKWMxz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 07:53:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238197AbiKWMvg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 07:51:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F5F185152;
        Wed, 23 Nov 2022 04:44:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B44C61CAE;
        Wed, 23 Nov 2022 12:44:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1E92C433C1;
        Wed, 23 Nov 2022 12:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669207451;
        bh=bvxefQTvaK5KtzYdS8OroZp3L97TDlXZv1Iqvn5SU2o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hWeT2VjmQVjdUBtV5D8KqHWedG5HyRXYduZ5DJWxT8esR0Mb5owe+8wJEd0tor5vg
         EmExEgLiHZWI2NAqdSa8MNa+/0zYw+YdnFRKxU510G/appxhKnnfTowRWu/knPUur2
         EMSD+u49xuT9rzUT9dZLOQfm2zSI7pB5Q1ahho9c1HNVPlkc1Q8ThNcZRXn6K2PE5u
         bTGoHMREZ80nSrqlCgpouYBGAyasMVxaaeoFavLApab5OGybrxjlYofzNJYJNPaadd
         3nIdRBxPM369PdfXQGu4r12ui99BW9QD71ASHb6Mq6+R/ZzNzPNewqxXn+/gDd8cuZ
         zca+UdgrtGxqg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Rudolf Polzer <rpolzer@google.com>,
        Sasha Levin <sashal@kernel.org>, jlee@suse.com,
        markgross@kernel.org, platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 12/22] platform/x86: acer-wmi: Enable SW_TABLET_MODE on Switch V 10 (SW5-017)
Date:   Wed, 23 Nov 2022 07:43:27 -0500
Message-Id: <20221123124339.265912-12-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221123124339.265912-1-sashal@kernel.org>
References: <20221123124339.265912-1-sashal@kernel.org>
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

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 1e817b889c7d8c14e7005258e15fec62edafe03c ]

Like the Acer Switch 10 (SW5-012) and Acer Switch 10 (S1003) models
the Acer Switch V 10 (SW5-017) supports reporting SW_TABLET_MODE
through acer-wmi.

Add a DMI quirk for the SW5-017 setting force_caps to ACER_CAP_KBD_DOCK
(these devices have no other acer-wmi based functionality).

Cc: Rudolf Polzer <rpolzer@google.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20221111111639.35730-1-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/acer-wmi.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index 8e696262215f..ebec49957ed0 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -536,6 +536,15 @@ static const struct dmi_system_id acer_quirks[] __initconst = {
 		},
 		.driver_data = (void *)ACER_CAP_KBD_DOCK,
 	},
+	{
+		.callback = set_force_caps,
+		.ident = "Acer Aspire Switch V 10 SW5-017",
+		.matches = {
+			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "SW5-017"),
+		},
+		.driver_data = (void *)ACER_CAP_KBD_DOCK,
+	},
 	{
 		.callback = set_force_caps,
 		.ident = "Acer One 10 (S1003)",
-- 
2.35.1

