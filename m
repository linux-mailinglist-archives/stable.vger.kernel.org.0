Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A35355B7400
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235658AbiIMPOv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 11:14:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235844AbiIMPN7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 11:13:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDFD278BEF;
        Tue, 13 Sep 2022 07:33:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 04B92614E2;
        Tue, 13 Sep 2022 14:33:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AFC5C433C1;
        Tue, 13 Sep 2022 14:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079590;
        bh=vhBPoo9+TLK9+hQbWq1b8y3SJghTY07Qom1m3j2Diu0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wqQgsaPTnZYVUakymKyWY8a2i+pV+IGB9oj5NAiYmsYY0uSUckJ9kn1sQPInI8wYJ
         owtrI4OoscEql7sVHfgwC4PN2nzkkTozkYvxpdDWOs3VmohGEpAIAUDIFiD60vIH3L
         yVxyXKR75owa/1eC89Oe5U4YLwH6Z+me7oxHJVZ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Ling <gnaygnil@gmail.com>,
        Keguang Zhang <keguang.zhang@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 78/79] MIPS: loongson32: ls1c: Fix hang during startup
Date:   Tue, 13 Sep 2022 16:07:36 +0200
Message-Id: <20220913140352.641002229@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140348.835121645@linuxfoundation.org>
References: <20220913140348.835121645@linuxfoundation.org>
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
index eb2d913c694fd..2d9675a6782c3 100644
--- a/arch/mips/loongson32/ls1c/board.c
+++ b/arch/mips/loongson32/ls1c/board.c
@@ -19,7 +19,6 @@ static struct platform_device *ls1c_platform_devices[] __initdata = {
 static int __init ls1c_platform_init(void)
 {
 	ls1x_serial_set_uartclk(&ls1x_uart_pdev);
-	ls1x_rtc_set_extclk(&ls1x_rtc_pdev);
 
 	return platform_add_devices(ls1c_platform_devices,
 				   ARRAY_SIZE(ls1c_platform_devices));
-- 
2.35.1



