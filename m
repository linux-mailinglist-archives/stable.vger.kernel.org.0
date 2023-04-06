Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22EBF6D95E7
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 13:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238459AbjDFLio (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 07:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238016AbjDFLiO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 07:38:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D584EBDD7;
        Thu,  6 Apr 2023 04:35:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 292056465D;
        Thu,  6 Apr 2023 11:34:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D400C433D2;
        Thu,  6 Apr 2023 11:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680780846;
        bh=9sQTzdzQIRmdNZ+niKlHkq4sOuPXASqIJ/yStmcsx48=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jZTdC8nYR/4aw+0BDTs5Io5SuYQplI6VMSDZZT3RpxH7sWXO7wyy+cJ8bwZlXZHza
         8Xu5ABOg+uH3pSRjFZufzIxfhzBvH/lM/iQ2iLViJWqIlm09GL+8mqNwVT7LjYn577
         9PJf/M+/MHNt3kruFPrkuT6uOb+HbpKaueVmXwz7r1LntVIsaLGi5eWjJaxuUZItmJ
         TblXocfhxiBdEpfn5IKgzMB7qAU4epvcjuJ8VZUpdyl4VDzlZinCte9Pc3lqdCkTBz
         xNqm3crQoATbBVLYjh8LPw6vyY37iTrBdBfY4H5jio7YjSEaHpKGH4C1gdh/82rPqb
         vzThgKvakyB0w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jonathan Denose <jdenose@chromium.org>,
        Jonathan Denose <jdenose@google.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, wse@tuxedocomputers.com,
        wsa+renesas@sang-engineering.com, mkorpershoek@baylibre.com,
        chenhuacai@kernel.org, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 2/8] Input: i8042 - add quirk for Fujitsu Lifebook A574/H
Date:   Thu,  6 Apr 2023 07:33:54 -0400
Message-Id: <20230406113400.649038-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230406113400.649038-1-sashal@kernel.org>
References: <20230406113400.649038-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Denose <jdenose@chromium.org>

[ Upstream commit f5bad62f9107b701a6def7cac1f5f65862219b83 ]

Fujitsu Lifebook A574/H requires the nomux option to properly
probe the touchpad, especially when waking from sleep.

Signed-off-by: Jonathan Denose <jdenose@google.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20230303152623.45859-1-jdenose@google.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/serio/i8042-x86ia64io.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
index b2ab20c16cc77..da2bf8259330e 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -605,6 +605,14 @@ static const struct dmi_system_id i8042_dmi_quirk_table[] __initconst = {
 		},
 		.driver_data = (void *)(SERIO_QUIRK_NOMUX)
 	},
+	{
+		/* Fujitsu Lifebook A574/H */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "FMVA0501PZ"),
+		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX)
+	},
 	{
 		/* Gigabyte M912 */
 		.matches = {
-- 
2.39.2

