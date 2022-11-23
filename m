Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 421CA635D66
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 13:46:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236897AbiKWMoF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 07:44:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236031AbiKWMnS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 07:43:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B5B267F78;
        Wed, 23 Nov 2022 04:41:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DB2A5B81F3A;
        Wed, 23 Nov 2022 12:41:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C26C7C433D7;
        Wed, 23 Nov 2022 12:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669207314;
        bh=1VEU9O42H1rgdwk4tsEI2XVTh9Gyc8mZWzHlL48sqj4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LNIzcDn00M+tfuY2pCGkbJspPURszsfwGT3+9oLRLH2qeDPWd0f1cCdjh6Dt3r11r
         MwftNZjNwuwRPMdH3aALXpL1xexnt8jrDOIEt2i6PmDJCWFWUWKXZzHGLyuanJ3Mm0
         gLXZV61bX6uWFSQnUHPkK2sSTl9Mn2zcXK0EPEWCd6+0DodYdMw1jbARmhdJuqBcw8
         ojt3UFX7GTaVARgQ7paN/siMDdWXn+orfQId/rdYp5y0HM8o+k1eAZEdLYCzVaXNib
         XA8CNHFzVX6mdBjHPBBN35kccyIlN5sn0vTR2mSHZrtmLmY47n3CzZ34vlQ1ZY4fE3
         6AVYov5E3Xo9Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Rudolf Polzer <rpolzer@google.com>,
        Sasha Levin <sashal@kernel.org>, jlee@suse.com,
        markgross@kernel.org, platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 24/44] platform/x86: acer-wmi: Enable SW_TABLET_MODE on Switch V 10 (SW5-017)
Date:   Wed, 23 Nov 2022 07:40:33 -0500
Message-Id: <20221123124057.264822-24-sashal@kernel.org>
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
index f1259d81d86d..df4c1f08f0c6 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -564,6 +564,15 @@ static const struct dmi_system_id acer_quirks[] __initconst = {
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

