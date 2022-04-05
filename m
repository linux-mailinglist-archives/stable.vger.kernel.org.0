Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FADB4F422B
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 23:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382455AbiDEMPR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:15:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242983AbiDEKfX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:35:23 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 552015159C;
        Tue,  5 Apr 2022 03:21:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C1D0DCE1C9D;
        Tue,  5 Apr 2022 10:21:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE301C385A1;
        Tue,  5 Apr 2022 10:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649154071;
        bh=GJWTx2va9kVPJ+UsHarwUFYycQHMaT1jG3zkI1xGkhM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q55aI/fAz+Fx406NumGvvgsXOg9L4mTrGSdLnUHK5xs9/8pFzFR6HH8g8b7+PEb5z
         Sgle4GO3KJBTknA3/FOCg2WO1RWgZuQGbbmR2sl5DbZswBhQfW7b5bK13ZAWUaGEN0
         PBz0DJobBFjeAFgFX0/e7kE8ymE3FDfEufo5Br6w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 410/599] clk: loongson1: Terminate clk_div_table with sentinel element
Date:   Tue,  5 Apr 2022 09:31:44 +0200
Message-Id: <20220405070311.033626747@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
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

From: Jonathan Neuschäfer <j.neuschaefer@gmx.net>

[ Upstream commit 3eb00f89162e80083dfcaa842468b510462cfeaa ]

In order that the end of a clk_div_table can be detected, it must be
terminated with a sentinel element (.div = 0).

Fixes: b4626a7f4892 ("CLK: Add Loongson1C clock support")
Signed-off-by: Jonathan Neuschäfer <j.neuschaefer@gmx.net>
Reviewed-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Link: https://lore.kernel.org/r/20220218000922.134857-3-j.neuschaefer@gmx.net
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/loongson1/clk-loongson1c.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/loongson1/clk-loongson1c.c b/drivers/clk/loongson1/clk-loongson1c.c
index 703f87622cf5..1ebf740380ef 100644
--- a/drivers/clk/loongson1/clk-loongson1c.c
+++ b/drivers/clk/loongson1/clk-loongson1c.c
@@ -37,6 +37,7 @@ static const struct clk_div_table ahb_div_table[] = {
 	[1] = { .val = 1, .div = 4 },
 	[2] = { .val = 2, .div = 3 },
 	[3] = { .val = 3, .div = 3 },
+	[4] = { /* sentinel */ }
 };
 
 void __init ls1x_clk_init(void)
-- 
2.34.1



