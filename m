Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E00C24D8409
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:21:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241388AbiCNMWg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:22:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243062AbiCNMUF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:20:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 890D152E7F;
        Mon, 14 Mar 2022 05:15:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 35AF0B80DFE;
        Mon, 14 Mar 2022 12:15:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97881C340E9;
        Mon, 14 Mar 2022 12:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647260114;
        bh=rg6mB/XZeyc4/94kQYCm4veWrHrTIgQhki3atHfiu7o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h1pwZmq+Oq06Y8NK2aCCFOpm2qJ6z9FDg1sId+PDiRjHZl4xZg04e8up+jCKbdT8m
         urlhV+uRteOGFH4GiarMO02YutuV/VTHtPgedkAgEpoILM1tA9sBRoBbIQN+BnxaGo
         JDZLWwP93ViJqF7GqRV2osLBTB5LoD+b2713ByPE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Erico Nunes <nunes.erico@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 059/121] net: phy: meson-gxl: improve link-up behavior
Date:   Mon, 14 Mar 2022 12:54:02 +0100
Message-Id: <20220314112745.772714489@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112744.120491875@linuxfoundation.org>
References: <20220314112744.120491875@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 2c87c6f9fbddc5b84d67b2fa3f432fcac6d99d93 ]

Sometimes the link comes up but no data flows. This patch fixes
this behavior. It's not clear what's the root cause of the issue.

According to the tests one other link-up issue remains.
In very rare cases the link isn't even reported as up.

Fixes: 84c8f773d2dc ("net: phy: meson-gxl: remove the use of .ack_callback()")
Tested-by: Erico Nunes <nunes.erico@gmail.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Link: https://lore.kernel.org/r/e3473452-a1f9-efcf-5fdd-02b6f44c3fcd@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/meson-gxl.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/meson-gxl.c b/drivers/net/phy/meson-gxl.c
index c49062ad72c6..73f7962a37d3 100644
--- a/drivers/net/phy/meson-gxl.c
+++ b/drivers/net/phy/meson-gxl.c
@@ -243,7 +243,13 @@ static irqreturn_t meson_gxl_handle_interrupt(struct phy_device *phydev)
 	    irq_status == INTSRC_ENERGY_DETECT)
 		return IRQ_HANDLED;
 
-	phy_trigger_machine(phydev);
+	/* Give PHY some time before MAC starts sending data. This works
+	 * around an issue where network doesn't come up properly.
+	 */
+	if (!(irq_status & INTSRC_LINK_DOWN))
+		phy_queue_state_machine(phydev, msecs_to_jiffies(100));
+	else
+		phy_trigger_machine(phydev);
 
 	return IRQ_HANDLED;
 }
-- 
2.34.1



