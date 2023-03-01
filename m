Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE556A7301
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 19:11:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbjCASLk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 13:11:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbjCASLg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 13:11:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60D5E4AFF3
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 10:11:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 20857B810C3
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 18:11:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91650C433D2;
        Wed,  1 Mar 2023 18:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677694292;
        bh=EiqR2mBNb2HeO81ozJwc7sAeGUmXpu05lg8Yb4g7VOk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J6lkaCV0xAuthB8BY+JJ1HMCiS1tLZ1w2P8VW+VlGMJ9sJDC7E6WeWAKFaTmwBHEi
         J/DTNN4FJZsetHhnBrR3eXI3nkRz+NjuwqowWjderCv+O0knwf1fjrvmXi52938BF6
         JJ3Ack9ZScwrPIGcZ/OuuSdxj0oCzrynOsUjg33U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mario Limonciello <mario.limonciello@amd.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 10/42] pinctrl: amd: Fix debug output for debounce time
Date:   Wed,  1 Mar 2023 19:08:31 +0100
Message-Id: <20230301180657.499893825@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230301180657.003689969@linuxfoundation.org>
References: <20230301180657.003689969@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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



