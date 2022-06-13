Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3DCC548852
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381582AbiFMOIm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:08:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382676AbiFMOGL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:06:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E655972AE;
        Mon, 13 Jun 2022 04:41:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5793AB80ECE;
        Mon, 13 Jun 2022 11:41:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3CB5C34114;
        Mon, 13 Jun 2022 11:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120469;
        bh=DWggWnX2xNbDWS0Nu1a/WLOOSmvEs+6Jfo+l1xZDVc0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0FK4LbjPEMMPr8iR8Oxnwj0HLrt1j9XjiqZ5DIjHXQJE1c/vbVAeFFUFXNc2/7Vl/
         IluMeUrWgcG9ZMgrFZeukoYkMSDxuY3JGT14zitCiLcZeuARe8EQ/eeUT7/31gBLbU
         CPHEs7Sy4gYTDvcHCWHJbzigQVxRFIgqi251Qi3A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Biju Das <biju.das.jz@bp.renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 044/298] watchdog: rzg2l_wdt: Fix reset control imbalance
Date:   Mon, 13 Jun 2022 12:08:58 +0200
Message-Id: <20220613094926.280675937@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094924.913340374@linuxfoundation.org>
References: <20220613094924.913340374@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit 33d04d0fdba9fae18c7d58364643d2c606a43dba ]

Both rzg2l_wdt_probe() and rzg2l_wdt_start() calls reset_control_
deassert() which results in a reset control imbalance.

This patch fixes reset control imbalance by removing reset_control_
deassert() from rzg2l_wdt_start() and replaces reset_control_assert with
reset_control_reset in rzg2l_wdt_stop() as watchdog module can be stopped
only by a module reset. This change will allow us to restart WDT after
stop() by configuring WDT timeout and enable registers.

Fixes: 2cbc5cd0b55fa2 ("watchdog: Add Watchdog Timer driver for RZ/G2L")
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20220225175320.11041-5-biju.das.jz@bp.renesas.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/rzg2l_wdt.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/watchdog/rzg2l_wdt.c b/drivers/watchdog/rzg2l_wdt.c
index 48dfe6e5e64f..88274704b260 100644
--- a/drivers/watchdog/rzg2l_wdt.c
+++ b/drivers/watchdog/rzg2l_wdt.c
@@ -88,7 +88,6 @@ static int rzg2l_wdt_start(struct watchdog_device *wdev)
 {
 	struct rzg2l_wdt_priv *priv = watchdog_get_drvdata(wdev);
 
-	reset_control_deassert(priv->rstc);
 	pm_runtime_get_sync(wdev->parent);
 
 	/* Initialize time out */
@@ -108,7 +107,7 @@ static int rzg2l_wdt_stop(struct watchdog_device *wdev)
 	struct rzg2l_wdt_priv *priv = watchdog_get_drvdata(wdev);
 
 	pm_runtime_put(wdev->parent);
-	reset_control_assert(priv->rstc);
+	reset_control_reset(priv->rstc);
 
 	return 0;
 }
-- 
2.35.1



