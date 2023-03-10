Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB2046B41D2
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 14:57:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231356AbjCJN5G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 08:57:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231284AbjCJN5A (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 08:57:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 043E0116B84
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 05:56:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D55F616F0
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 13:56:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FB1DC433D2;
        Fri, 10 Mar 2023 13:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678456601;
        bh=aRt7IUzICRpx12TUtqvx6RnBWQGAPDdz3FJYOgArrAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uYZ/xvTP577c74QP9FF1TNHn7bXzs7t68TR/DlvhvNWxfoUsAg0BgUBUVm7FdXI22
         zWix2zwWgrfPgBH55DhKcnAK7LZlXuYHnmEKOHx10J844JhbI2gkhpIL+TDVwyI4gd
         95JcNqxcF4cL8ZBPJ59vVhc4dx+7oNaVYs19fPM8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 060/211] watchdog: rzg2l_wdt: Issue a reset before we put the PM clocks
Date:   Fri, 10 Mar 2023 14:37:20 +0100
Message-Id: <20230310133720.553562090@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit 6ba6f0f5910d5916539268c0ad55657bb8940616 ]

On RZ/Five SoC it was observed that setting timeout (to say 1 sec) wouldn't
reset the system.

The procedure described in the HW manual (Procedure for Activating Modules)
for activating the target module states we need to start supply of the
clock module before applying the reset signal. This patch makes sure we
follow the same procedure to clear the registers of the WDT module, fixing
the issues seen on RZ/Five SoC.

While at it re-used rzg2l_wdt_stop() in rzg2l_wdt_set_timeout() as it has
the same function calls.

Fixes: 4055ee81009e ("watchdog: rzg2l_wdt: Add set_timeout callback")
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
Link: https://lore.kernel.org/r/20221117114907.138583-2-fabrizio.castro.jz@renesas.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/rzg2l_wdt.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/watchdog/rzg2l_wdt.c b/drivers/watchdog/rzg2l_wdt.c
index 974a4194a8fd6..ceca42db08374 100644
--- a/drivers/watchdog/rzg2l_wdt.c
+++ b/drivers/watchdog/rzg2l_wdt.c
@@ -115,25 +115,23 @@ static int rzg2l_wdt_stop(struct watchdog_device *wdev)
 {
 	struct rzg2l_wdt_priv *priv = watchdog_get_drvdata(wdev);
 
-	pm_runtime_put(wdev->parent);
 	reset_control_reset(priv->rstc);
+	pm_runtime_put(wdev->parent);
 
 	return 0;
 }
 
 static int rzg2l_wdt_set_timeout(struct watchdog_device *wdev, unsigned int timeout)
 {
-	struct rzg2l_wdt_priv *priv = watchdog_get_drvdata(wdev);
-
 	wdev->timeout = timeout;
 
 	/*
 	 * If the watchdog is active, reset the module for updating the WDTSET
-	 * register so that it is updated with new timeout values.
+	 * register by calling rzg2l_wdt_stop() (which internally calls reset_control_reset()
+	 * to reset the module) so that it is updated with new timeout values.
 	 */
 	if (watchdog_active(wdev)) {
-		pm_runtime_put(wdev->parent);
-		reset_control_reset(priv->rstc);
+		rzg2l_wdt_stop(wdev);
 		rzg2l_wdt_start(wdev);
 	}
 
-- 
2.39.2



