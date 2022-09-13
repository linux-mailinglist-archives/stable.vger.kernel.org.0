Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E67C5B7050
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233571AbiIMOYz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:24:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233749AbiIMOYK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:24:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F47361B16;
        Tue, 13 Sep 2022 07:16:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A49FA614D5;
        Tue, 13 Sep 2022 14:16:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5504C433C1;
        Tue, 13 Sep 2022 14:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078562;
        bh=QguUPaIEEvBzn61sjIX+19HWvFui+vi0iCLd0a5G61A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GiGFO0elkMSb6ityFOiXBz6h8g9NyuuV4ljfgd5d9sO6gb/ioFLKEmWSOGBR9bx81
         Sy+NCpK42Uw4vUBZUrPh13418GTH6J3zg+0cRqYr8Cx0Up65deg+n5EhnYCYFXVQEz
         yzcsndzJ6i5qUR7BM+kjQJULTQOr4zgQri/9H6BE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Ling <gnaygnil@gmail.com>,
        Keguang Zhang <keguang.zhang@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 162/192] MIPS: loongson32: ls1c: Fix hang during startup
Date:   Tue, 13 Sep 2022 16:04:28 +0200
Message-Id: <20220913140418.102431761@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Yang Ling <gnaygnil@gmail.com>

[ Upstream commit 35508d2424097f9b6a1a17aac94f702767035616 ]

The RTCCTRL reg of LS1C is obselete.
Writing this reg will cause system hang.

Fixes: 60219c563c9b6 ("MIPS: Add RTC support for Loongson1C board")
Signed-off-by: Yang Ling <gnaygnil@gmail.com>
Tested-by: Keguang Zhang <keguang.zhang@gmail.com>
Acked-by: Keguang Zhang <keguang.zhang@gmail.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/loongson32/ls1c/board.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/mips/loongson32/ls1c/board.c b/arch/mips/loongson32/ls1c/board.c
index e9de6da0ce51f..9dcfe9de55b0a 100644
--- a/arch/mips/loongson32/ls1c/board.c
+++ b/arch/mips/loongson32/ls1c/board.c
@@ -15,7 +15,6 @@ static struct platform_device *ls1c_platform_devices[] __initdata = {
 static int __init ls1c_platform_init(void)
 {
 	ls1x_serial_set_uartclk(&ls1x_uart_pdev);
-	ls1x_rtc_set_extclk(&ls1x_rtc_pdev);
 
 	return platform_add_devices(ls1c_platform_devices,
 				   ARRAY_SIZE(ls1c_platform_devices));
-- 
2.35.1



