Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3C051A8DB
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:15:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353062AbiEDRMY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:12:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356945AbiEDRJu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:09:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56C4B4739C;
        Wed,  4 May 2022 09:56:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E953561794;
        Wed,  4 May 2022 16:56:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44B46C385AF;
        Wed,  4 May 2022 16:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683394;
        bh=0ttIZ0ihhyBidXV9m5MwjSKUbj2JnWrIM5mZ6cMm7M8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lYrmYT9GlpEb0B6xKTGGp4ucJC2pTLAZRcXWp4xpNOchO0A9KlyQ7byFOuQj3aJPS
         FuAeSc1/kW3Pwss1bCCuGtp7rrHRe6dUFcSl1kjGw3fABAllv2xBiSeh9UL4/t29XS
         rN5yQjFkrkYZTJ0x07kf2Nzhj8Pv99sPf7jsMinw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kevin Hilman <khilman@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 079/225] bus: ti-sysc: Make omap3 gpt12 quirk handling SoC specific
Date:   Wed,  4 May 2022 18:45:17 +0200
Message-Id: <20220504153118.282106726@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
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

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit a12315d6d27093392b6c634e1d35a59f1d1f7a59 ]

On beagleboard revisions A to B4 we need to use gpt12 as the system timer.
However, the quirk handling added for gpt12 caused a regression for system
suspend for am335x as the PM coprocessor needs the timers idled for
suspend.

Let's make the gpt12 quirk specific to omap34xx, other SoCs don't need
it. Beagleboard revisions C and later no longer need to use the gpt12
related quirk. Then at some point, if we decide to drop support for the old
beagleboard revisions A to B4, we can also drop the gpt12 related quirks
completely.

Fixes: 3ff340e24c9d ("bus: ti-sysc: Fix gpt12 system timer issue with reserved status")
Reported-by: Kevin Hilman <khilman@baylibre.com>
Suggested-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/ti-sysc.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/bus/ti-sysc.c b/drivers/bus/ti-sysc.c
index 54c0ee6dda30..7a1b1f9e4933 100644
--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -3232,13 +3232,27 @@ static int sysc_check_disabled_devices(struct sysc *ddata)
  */
 static int sysc_check_active_timer(struct sysc *ddata)
 {
+	int error;
+
 	if (ddata->cap->type != TI_SYSC_OMAP2_TIMER &&
 	    ddata->cap->type != TI_SYSC_OMAP4_TIMER)
 		return 0;
 
+	/*
+	 * Quirk for omap3 beagleboard revision A to B4 to use gpt12.
+	 * Revision C and later are fixed with commit 23885389dbbb ("ARM:
+	 * dts: Fix timer regression for beagleboard revision c"). This all
+	 * can be dropped if we stop supporting old beagleboard revisions
+	 * A to B4 at some point.
+	 */
+	if (sysc_soc->soc == SOC_3430)
+		error = -ENXIO;
+	else
+		error = -EBUSY;
+
 	if ((ddata->cfg.quirks & SYSC_QUIRK_NO_RESET_ON_INIT) &&
 	    (ddata->cfg.quirks & SYSC_QUIRK_NO_IDLE))
-		return -ENXIO;
+		return error;
 
 	return 0;
 }
-- 
2.35.1



