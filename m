Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D388C63E015
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:53:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231493AbiK3Sxc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:53:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231500AbiK3SxR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:53:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2231C1DDC6
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:53:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9AE67B81CAA
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:53:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09537C433D6;
        Wed, 30 Nov 2022 18:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834394;
        bh=tpwxalOIr033n4zxpSwbmtQYC/89BGrEv8m6E7cmNn8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FUdWX28PZotrGEmK7+j7Ytw8Zt9aiUkqPiDb0/yzluYiTltoCHSi24PLzAAWA2Z1X
         /9+Y91SeBBHYL1f4zNtNdROdHa9aKvfTVcVmf2DvV1yyMghKzqYTC7wdeLLa6GfFtg
         tzR7vBJwL1WcfYMus4mqx65CsmdHucA6KP+gnkVE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 238/289] Input: soc_button_array - add Acer Switch V 10 to dmi_use_low_level_irq[]
Date:   Wed, 30 Nov 2022 19:23:43 +0100
Message-Id: <20221130180549.506085704@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
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

[ Upstream commit e13757f52496444b994a7ac67b6e517a15d89bbc ]

Like on the Acer Switch 10 SW5-012, the Acer Switch V 10 SW5-017's _LID
method messes with home- and power-button GPIO IRQ settings, causing an
IRQ storm.

Add a quirk entry for the Acer Switch V 10 to the dmi_use_low_level_irq[]
DMI quirk list, to use low-level IRQs on this model, fixing the IRQ storm.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20221106215320.67109-2-hdegoede@redhat.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/misc/soc_button_array.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/input/misc/soc_button_array.c b/drivers/input/misc/soc_button_array.c
index 50497dd05027..09489380afda 100644
--- a/drivers/input/misc/soc_button_array.c
+++ b/drivers/input/misc/soc_button_array.c
@@ -77,6 +77,13 @@ static const struct dmi_system_id dmi_use_low_level_irq[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire SW5-012"),
 		},
 	},
+	{
+		/* Acer Switch V 10 SW5-017, same issue as Acer Switch 10 SW5-012. */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "SW5-017"),
+		},
+	},
 	{
 		/*
 		 * Acer One S1003. _LID method messes with power-button GPIO
-- 
2.35.1



