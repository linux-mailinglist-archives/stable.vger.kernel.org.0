Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49B144BDFD8
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:50:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbiBUKDf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 05:03:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353429AbiBUJ50 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:57:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0A873916A;
        Mon, 21 Feb 2022 01:25:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A0783B80EC8;
        Mon, 21 Feb 2022 09:25:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C44AEC340E9;
        Mon, 21 Feb 2022 09:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435540;
        bh=E8X8be894fHh241pFPixddfhnlq8eHFkwL8tLTXtjqA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mVYXJAFjRQ2SRbx6Fymslw6w6INyvadUnfkGZ4YBbUPPWujGuO4gJhNEAMAevOHnf
         /2bl6pbpxbEeEgLCjaDnST4vzpPjFgWqEM6pQK/wyU5owz5hfu8RdIlS9yezJJeNgT
         chG07YZHnnQZ+7vFfFartMXOjSpyjD3PfrqVzic4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zeal Robot <zealci@zte.com.cn>,
        Ye Guojin <ye.guojin@zte.com.cn>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 199/227] ARM: OMAP2+: adjust the location of put_device() call in omapdss_init_of
Date:   Mon, 21 Feb 2022 09:50:18 +0100
Message-Id: <20220221084941.430868060@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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



