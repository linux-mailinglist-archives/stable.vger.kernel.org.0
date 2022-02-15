Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 751584B72F5
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 17:42:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239967AbiBOPaJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 10:30:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240106AbiBOP3v (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 10:29:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52A19AF1F9;
        Tue, 15 Feb 2022 07:28:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 51713615CE;
        Tue, 15 Feb 2022 15:28:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF969C340F1;
        Tue, 15 Feb 2022 15:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644938915;
        bh=E8X8be894fHh241pFPixddfhnlq8eHFkwL8tLTXtjqA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G1HYo8frO0hwy/Id252sLBhPa/C18zMnSEwDmyRamIf863fWBD+C6HlcunLXfPMdX
         ScTGY1vPohNnv1ho9+Y5jalsmU+vtDQgXBNiigphD3jlBQ4K62XGMt5BzGjBP21bfX
         /Z8HU9i8/XKA5mJtQhaHrMSs9VuB/SgfaEGEa+DtTKGRP1ijQfskkBGjA2TPMn76bT
         2VvSS5rhUegn2RdSHVxsbITaW64TyRtKGLrCjkO2VThwYin+6pwG3L6aSB9h2ZQeMd
         uiFDhid63gsD99G6EGOs+j7g2Z+TxON3B/X/RIcQp+gq8Y4kSFeswVg29Vqi52oe/0
         yKw3GzaYEBL+g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ye Guojin <ye.guojin@zte.com.cn>, Zeal Robot <zealci@zte.com.cn>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>, linux@armlinux.org.uk,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 02/33] ARM: OMAP2+: adjust the location of put_device() call in omapdss_init_of
Date:   Tue, 15 Feb 2022 10:28:00 -0500
Message-Id: <20220215152831.580780-2-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220215152831.580780-1-sashal@kernel.org>
References: <20220215152831.580780-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ye Guojin <ye.guojin@zte.com.cn>

[ Upstream commit 34596ba380b03d181e24efd50e2f21045bde3696 ]

This was found by coccicheck:
./arch/arm/mach-omap2/display.c, 272, 1-7, ERROR missing put_device;
call of_find_device_by_node on line 258, but without a corresponding
object release within this function.

Move the put_device() call before the if judgment.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Ye Guojin <ye.guojin@zte.com.cn>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap2/display.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/display.c b/arch/arm/mach-omap2/display.c
index 6daaa645ae5d9..21413a9b7b6c6 100644
--- a/arch/arm/mach-omap2/display.c
+++ b/arch/arm/mach-omap2/display.c
@@ -263,9 +263,9 @@ static int __init omapdss_init_of(void)
 	}
 
 	r = of_platform_populate(node, NULL, NULL, &pdev->dev);
+	put_device(&pdev->dev);
 	if (r) {
 		pr_err("Unable to populate DSS submodule devices\n");
-		put_device(&pdev->dev);
 		return r;
 	}
 
-- 
2.34.1

