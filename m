Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC39E635E8D
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 13:58:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237536AbiKWMvd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 07:51:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238166AbiKWMu6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 07:50:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8F037D51A;
        Wed, 23 Nov 2022 04:44:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A54B961BDC;
        Wed, 23 Nov 2022 12:44:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55603C433D7;
        Wed, 23 Nov 2022 12:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669207444;
        bh=r8taBK0juFTsm9rFk+xkwG9CEgBXIN5Wo0LyZmOehcg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J311Z/fm4i++2JDkele8Id6eq1Cuq5WbE0I0WGIxAzhqwFMt/StSqy11FJFeCq/nO
         4TBKEMuYPmLcckVQa7P1LFJPNl/qfdy+cCb2blSgjCmeTpPdB+JXDvMcTISFUGk4h6
         pLUW0z8EBKa8+FVNq5DnT9Sjk5CPVdlRh+u2fWu3w5r7a/o+6eTiwq6CSZwtPHdIgc
         Ozo+sYpKxwKWMO7zWulvft5ARkcmiGJOfA3u+wVWqe15AGWliWAvnhAFaQEcnxUilb
         RrwdmRGY/mslHp+qWGQIZuct2jEEV2xjHOlXqtYTQeL543zbL2Z1MaWyXU8di2PcYf
         c8zBbyoD/5AUQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, mail@mariushoch.de,
        andriy.shevchenko@linux.intel.com, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 08/22] Input: soc_button_array - add Acer Switch V 10 to dmi_use_low_level_irq[]
Date:   Wed, 23 Nov 2022 07:43:23 -0500
Message-Id: <20221123124339.265912-8-sashal@kernel.org>
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

