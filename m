Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D8B66985EA
	for <lists+stable@lfdr.de>; Wed, 15 Feb 2023 21:46:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbjBOUqd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Feb 2023 15:46:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbjBOUqY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Feb 2023 15:46:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4C2843466;
        Wed, 15 Feb 2023 12:46:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3961161D9E;
        Wed, 15 Feb 2023 20:46:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6158DC433D2;
        Wed, 15 Feb 2023 20:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676493970;
        bh=EiqR2mBNb2HeO81ozJwc7sAeGUmXpu05lg8Yb4g7VOk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P1aaWKwyEIJWV4OIcWS/JBZpz1GhlWyWC52gd/IrNCYF1mZec+sc5JlkEQ4Ookp4G
         RY2AFJncXktvddhlDp47nFp8TtUl+ypBED/K/Y3ae9qA6Bk5Rky4I4RL7BAztxaI4B
         9K9FpwyMKEn5BZEI6W8+wako3shygG9trUHjpWgfwdbRMVD3mMNkybWWvc96+245jj
         /X7e/Im60oSwpGlKkv7uvAQQTrUl5gXdKLt4drQCJ62dlY1d1/VNzYPFLxKFkn86cp
         4e9bVvLP8YxRvM877EeXvYBKnfM855Uxc88MI294bXWK2Lv9sewSAMcc+VZbBLA46S
         dcOS/FMWVDhOg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mario Limonciello <mario.limonciello@amd.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, Basavaraj.Natikar@amd.com,
        Shyam-sundar.S-k@amd.com, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 10/24] pinctrl: amd: Fix debug output for debounce time
Date:   Wed, 15 Feb 2023 15:45:33 -0500
Message-Id: <20230215204547.2760761-10-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230215204547.2760761-1-sashal@kernel.org>
References: <20230215204547.2760761-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit c6e0679b8381bf03315e6660cf5370f916c1a1c6 ]

If one GPIO has debounce enabled but future GPIOs in the list don't
have debounce the time never gets reset and shows wrong value.

Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20230121134812.16637-2-mario.limonciello@amd.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-amd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/pinctrl-amd.c b/drivers/pinctrl/pinctrl-amd.c
index 9bc6e3922e78e..32c3edaf90385 100644
--- a/drivers/pinctrl/pinctrl-amd.c
+++ b/drivers/pinctrl/pinctrl-amd.c
@@ -365,6 +365,7 @@ static void amd_gpio_dbg_show(struct seq_file *s, struct gpio_chip *gc)
 
 			} else {
 				debounce_enable = "  ∅";
+				time = 0;
 			}
 			snprintf(debounce_value, sizeof(debounce_value), "%u", time * unit);
 			seq_printf(s, "debounce %s (🕑 %sus)| ", debounce_enable, debounce_value);
-- 
2.39.0

