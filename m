Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 979EE551BDA
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343791AbiFTNVC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:21:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344829AbiFTNTc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:19:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7144CBC0C;
        Mon, 20 Jun 2022 06:08:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8BE45B811BD;
        Mon, 20 Jun 2022 13:05:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAF79C3411B;
        Mon, 20 Jun 2022 13:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730341;
        bh=YnT0A5pYx7LECS7ve6dpcfSYlTvAMThZz2MiAayKHIE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DH8smWCikGt1gQeIM7CqTUccwYfRBN8jdyeCnim2LFghGvjP4g9MZzWXdcb25+L22
         Fz3hdN4AbCkjaUcvHcRE6AoMXAhBGT3ahhWT2RANFwlDgWRY9PSgtPW5SCc3eYv5AC
         uphE00ZibH7h4/tPKfqvUZcGK2T8vjQEQ32DDHR4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marius Hoch <mail@mariushoch.de>,
        Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 022/106] Input: soc_button_array - also add Lenovo Yoga Tablet2 1051F to dmi_use_low_level_irq
Date:   Mon, 20 Jun 2022 14:50:41 +0200
Message-Id: <20220620124725.040020885@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124724.380838401@linuxfoundation.org>
References: <20220620124724.380838401@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marius Hoch <mail@mariushoch.de>

[ Upstream commit 6ab2e51898cd4343bbdf8587af8ce8fbabddbcb5 ]

Commit 223f61b8c5ad ("Input: soc_button_array - add Lenovo Yoga Tablet2
1051L to the dmi_use_low_level_irq list") added the 1051L to this list
already, but the same problem applies to the 1051F. As there are no
further 1051 variants (just the F/L), we can just DMI match 1051.

Tested on a Lenovo Yoga Tablet2 1051F: Without this patch the
home-button stops working after a wakeup from suspend.

Signed-off-by: Marius Hoch <mail@mariushoch.de>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20220603120246.3065-1-mail@mariushoch.de
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/misc/soc_button_array.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/input/misc/soc_button_array.c b/drivers/input/misc/soc_button_array.c
index cb6ec59a045d..efffcf0ebd3b 100644
--- a/drivers/input/misc/soc_button_array.c
+++ b/drivers/input/misc/soc_button_array.c
@@ -85,13 +85,13 @@ static const struct dmi_system_id dmi_use_low_level_irq[] = {
 	},
 	{
 		/*
-		 * Lenovo Yoga Tab2 1051L, something messes with the home-button
+		 * Lenovo Yoga Tab2 1051F/1051L, something messes with the home-button
 		 * IRQ settings, leading to a non working home-button.
 		 */
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "60073"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "1051L"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "1051"),
 		},
 	},
 	{} /* Terminating entry */
-- 
2.35.1



