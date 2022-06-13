Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A44154901E
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381990AbiFMOZe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:25:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383409AbiFMOWm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:22:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0F50A26E0;
        Mon, 13 Jun 2022 04:44:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 45E12B80E2C;
        Mon, 13 Jun 2022 11:44:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A79D1C34114;
        Mon, 13 Jun 2022 11:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120645;
        bh=uG0I/gJsRKxBuo++ROArv2w/vHAcrZRr6c1u6N1YxZ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gqBDzvw+trlm1XrQp7jWWAYCCLLcEnHH+3wJIMkM02vdgaCmp+ck2kkclD1Pzc/gf
         1vTldbAQMU3WpEUNS0DaKJTU9pAfW9Jsw4o4Q4NhDSO1eS0ihuY7spUQ97Jgg2+g6i
         +LwNzjCRVvdzl/j7Jy8IiohirE85o/d9GKlRx1xk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Genjian Zhang <zhanggenjian@kylinos.cn>,
        Alexander Sverdlin <alexander.sverdlin@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 088/298] ep93xx: clock: Do not return the address of the freed memory
Date:   Mon, 13 Jun 2022 12:09:42 +0200
Message-Id: <20220613094927.618030909@linuxfoundation.org>
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

From: Genjian Zhang <zhanggenjian123@gmail.com>

[ Upstream commit 8a7322a3a05f75e8a4902bdf8129aecd37d54fe9 ]

Avoid return freed memory addresses,Modified to the actual error
return value of clk_register().

Fixes: 9645ccc7bd7a ("ep93xx: clock: convert in-place to COMMON_CLK")
Signed-off-by: Genjian Zhang <zhanggenjian@kylinos.cn>
Acked-by: Alexander Sverdlin <alexander.sverdlin@gmail.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-ep93xx/clock.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-ep93xx/clock.c b/arch/arm/mach-ep93xx/clock.c
index 28e0ae6e890e..00c2db101ce5 100644
--- a/arch/arm/mach-ep93xx/clock.c
+++ b/arch/arm/mach-ep93xx/clock.c
@@ -345,9 +345,10 @@ static struct clk_hw *clk_hw_register_ddiv(const char *name,
 	psc->hw.init = &init;
 
 	clk = clk_register(NULL, &psc->hw);
-	if (IS_ERR(clk))
+	if (IS_ERR(clk)) {
 		kfree(psc);
-
+		return ERR_CAST(clk);
+	}
 	return &psc->hw;
 }
 
@@ -452,9 +453,10 @@ static struct clk_hw *clk_hw_register_div(const char *name,
 	psc->hw.init = &init;
 
 	clk = clk_register(NULL, &psc->hw);
-	if (IS_ERR(clk))
+	if (IS_ERR(clk)) {
 		kfree(psc);
-
+		return ERR_CAST(clk);
+	}
 	return &psc->hw;
 }
 
-- 
2.35.1



