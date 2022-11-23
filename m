Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCE2E635DAC
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 13:47:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237489AbiKWMnG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 07:43:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237433AbiKWMmE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 07:42:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D0EC6CA01;
        Wed, 23 Nov 2022 04:41:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CFDB561C9C;
        Wed, 23 Nov 2022 12:41:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 647CFC433D6;
        Wed, 23 Nov 2022 12:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669207299;
        bh=tpwxalOIr033n4zxpSwbmtQYC/89BGrEv8m6E7cmNn8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PiVOYVKsWBYn78NOvURLE402ndTN8Ne6ngR03cl9/kwKSCgx5/A/8eNkHz8DiddXv
         ays37Zm1Jh5vMe84Eln7JZ9fjodHnmN0IIlK6O4jwWQqlEUqukxJJbVICwAU+153xo
         rCPXTuwCIljXPwRzgKe83mlz5BQqSay5c7QUEV00oEIA3vDkX3l82t2EnGgr1DHZGP
         7iM+ddKlJ7y82IUEJFY+4ke8ndkvl03K2xoogcSMwzCFk9ROQzH05PHU+D/s2d01fT
         kvPw8Q5lSEv6p7HugKusWfjizQlbt8VhOKUjznvCm5svMpZykxjsrE4K6SDp2yZA+O
         8eUFBrKRW4nag==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>,
        andriy.shevchenko@linux.intel.com, rafael.j.wysocki@intel.com,
        mail@mariushoch.de, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 16/44] Input: soc_button_array - add Acer Switch V 10 to dmi_use_low_level_irq[]
Date:   Wed, 23 Nov 2022 07:40:25 -0500
Message-Id: <20221123124057.264822-16-sashal@kernel.org>
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

