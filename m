Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7EA863DDF7
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:32:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbiK3ScX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:32:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230000AbiK3ScV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:32:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A73A18DFFC
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:32:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B50EB81C9C
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:32:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DB84C433C1;
        Wed, 30 Nov 2022 18:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833137;
        bh=r8taBK0juFTsm9rFk+xkwG9CEgBXIN5Wo0LyZmOehcg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KhsIfcT0GN89fqSuUmjj/6psbzd6/Yo40nWR7o/aLMF6GW/146cIGwqO6Do6aIFlZ
         0SClTQ0/+uFX6UGSowDQ0QWCxlLzL1MsGYRanFE6B/OmcJm0kp3+F7gyM03qvwXRpC
         Q2ytDvk0wNoMMS6K/kdNgnRssYeL/6DAOGs5h4OQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 136/162] Input: soc_button_array - add Acer Switch V 10 to dmi_use_low_level_irq[]
Date:   Wed, 30 Nov 2022 19:23:37 +0100
Message-Id: <20221130180532.171977470@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180528.466039523@linuxfoundation.org>
References: <20221130180528.466039523@linuxfoundation.org>
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
index 46ba8218de99..31c02c2019c1 100644
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



