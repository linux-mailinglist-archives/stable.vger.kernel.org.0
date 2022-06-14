Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1600754A560
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 04:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353572AbiFNCQM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 22:16:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353911AbiFNCOJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 22:14:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 774553B02D;
        Mon, 13 Jun 2022 19:08:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 418FF60AD8;
        Tue, 14 Jun 2022 02:07:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2DBAC385A9;
        Tue, 14 Jun 2022 02:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655172460;
        bh=YnT0A5pYx7LECS7ve6dpcfSYlTvAMThZz2MiAayKHIE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sF37G6cV0yna0VN8QS9RqbE0Qbaf1qahf6RIuf7JAc8KK9+ztFGy5TrQ4O66khoEU
         LBICQJykvd1O1PpFnnbqQEuLRVvKvBmirEPQGmXGd2n+fuQB17C0FvAEwVWslIFhLD
         92pWo70YZSBRJjEqRk/SOntcCzYLgtdmYmQEZ/X3Hb2m4vZVlVxkCL4lf/C16/Wji4
         cFqKYw7LYfazgZBr/wr6H/OIckjPYm48B8MtQD8c5e2fZpItt081QBf1mLoBGC/3l/
         bwbRUfFGdBKC9Fer8NyKqxGhTb48eCZIsVOIIVzuwl92FKXqykQrApl2KLezMbuTpv
         1PbUiofiBYgNA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marius Hoch <mail@mariushoch.de>,
        Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 19/41] Input: soc_button_array - also add Lenovo Yoga Tablet2 1051F to dmi_use_low_level_irq
Date:   Mon, 13 Jun 2022 22:06:44 -0400
Message-Id: <20220614020707.1099487-19-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220614020707.1099487-1-sashal@kernel.org>
References: <20220614020707.1099487-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

