Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64D504BE460
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:59:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347713AbiBUJQs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:16:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348531AbiBUJPy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:15:54 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6538220F6B;
        Mon, 21 Feb 2022 01:06:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B1F98CE0E8C;
        Mon, 21 Feb 2022 09:06:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B31CC340E9;
        Mon, 21 Feb 2022 09:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434412;
        bh=C9+r6K9CKqbLGqkt3mB9J/OJvtR9LupLVAs5w8dtfXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jXvvXAa8rTQvFgS5cuBEsnJSSg+Qo+xhRIZLnZmR23STC/MjmUh51XmiLIB4ZEpzP
         mdm2ix4r7ZVO8DRJEiSuKx/BAXDUSEHlZ9+33Zy184ufQcfpkKWj42M0yVhfWcf66l
         G4W/p4dqGgkHceXesvU71+IykvcMEmC0KddZBPGk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zeal Robot <zealci@zte.com.cn>,
        Ye Guojin <ye.guojin@zte.com.cn>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 093/121] ARM: OMAP2+: adjust the location of put_device() call in omapdss_init_of
Date:   Mon, 21 Feb 2022 09:49:45 +0100
Message-Id: <20220221084924.338847741@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084921.147454846@linuxfoundation.org>
References: <20220221084921.147454846@linuxfoundation.org>
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
index 2000fca6bd4e6..6098666e928d0 100644
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



