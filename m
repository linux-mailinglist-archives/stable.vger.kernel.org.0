Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A40255198F
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:06:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243559AbiFTNAZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:00:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244579AbiFTM7n (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 08:59:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 434F419FB9;
        Mon, 20 Jun 2022 05:56:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 919D6B811A0;
        Mon, 20 Jun 2022 12:56:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE15FC341C4;
        Mon, 20 Jun 2022 12:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655729795;
        bh=D2UwmSnr5W4IRYDH4+1SoWClJ8DsSUAmAlrFDCiml44=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kyB1MXYhVucFYGssMdM9NFWpfTypS6ELzgceS/IOLpHnQF0SoJsahtKTZoh9XBW/M
         bCWLCP02dNs75VmT6UWz1Zr4HvDti5zFgWJOid4p59NrWvGfGVkQPnzAhmSumYMFwP
         pMKKKg3X1Ks6VPOEEk+Iy//cKy7s28IcNIAfKaaU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marius Hoch <mail@mariushoch.de>,
        Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 026/141] Input: soc_button_array - also add Lenovo Yoga Tablet2 1051F to dmi_use_low_level_irq
Date:   Mon, 20 Jun 2022 14:49:24 +0200
Message-Id: <20220620124730.302867023@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124729.509745706@linuxfoundation.org>
References: <20220620124729.509745706@linuxfoundation.org>
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
index cbb1599a520e..480476121c01 100644
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



