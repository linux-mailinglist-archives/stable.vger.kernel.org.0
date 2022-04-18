Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB31505144
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236292AbiDRMeM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:34:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239734AbiDRMdW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:33:22 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACFFC1DA55;
        Mon, 18 Apr 2022 05:25:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1680CCE106E;
        Mon, 18 Apr 2022 12:25:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3C6FC385A7;
        Mon, 18 Apr 2022 12:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284723;
        bh=ZHMZnOit5c8zTbyxv8NwyQI3YVinWF2OZ+PTUpwGha4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1XcLq9jfJMMcTzkAEGyI/I03hxWa/w1edK9f6sAU8Z8eES7sQ7BiDrAKJPNR7N/4X
         Qfz1rAQiTGeWBIXbTX9haSevrvzcZ+srJdbTJRTTaZz5TLQ5m4K0shShscQ+1nt+AF
         l4kJtgyqhHfahbh1MGFSUILFmdks7fmJr8E6Oofg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Alexander Sverdlin <alexander.sverdlin@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5.17 206/219] ep93xx: clock: Fix UAF in ep93xx_clk_register_gate()
Date:   Mon, 18 Apr 2022 14:12:55 +0200
Message-Id: <20220418121212.634259061@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
References: <20220418121203.462784814@linuxfoundation.org>
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

From: Alexander Sverdlin <alexander.sverdlin@gmail.com>

commit 3b68b08885217abd9c57ff9b3bb3eb173eee02a9 upstream.

arch/arm/mach-ep93xx/clock.c:154:2: warning: Use of memory after it is freed [clang-analyzer-unix.Malloc]
arch/arm/mach-ep93xx/clock.c:151:2: note: Taking true branch
if (IS_ERR(clk))
^
arch/arm/mach-ep93xx/clock.c:152:3: note: Memory is released
kfree(psc);
^~~~~~~~~~
arch/arm/mach-ep93xx/clock.c:154:2: note: Use of memory after it is freed
return &psc->hw;
^ ~~~~~~~~

Fixes: 9645ccc7bd7a ("ep93xx: clock: convert in-place to COMMON_CLK")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@gmail.com>
Cc: stable@vger.kernel.org
Link: https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org/thread/B5YCO2NJEXINCYE26Y255LCVMO55BGWW/
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/mach-ep93xx/clock.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/arm/mach-ep93xx/clock.c
+++ b/arch/arm/mach-ep93xx/clock.c
@@ -148,8 +148,10 @@ static struct clk_hw *ep93xx_clk_registe
 	psc->lock = &clk_lock;
 
 	clk = clk_register(NULL, &psc->hw);
-	if (IS_ERR(clk))
+	if (IS_ERR(clk)) {
 		kfree(psc);
+		return ERR_CAST(clk);
+	}
 
 	return &psc->hw;
 }


