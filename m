Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E73625B7582
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232621AbiIMPp4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 11:45:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234634AbiIMPpO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 11:45:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A547A8688F;
        Tue, 13 Sep 2022 07:48:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D77E614D0;
        Tue, 13 Sep 2022 14:35:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60720C433C1;
        Tue, 13 Sep 2022 14:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079747;
        bh=vhBPoo9+TLK9+hQbWq1b8y3SJghTY07Qom1m3j2Diu0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z+FltSt8Utehy9wpZbmKy+qVKwelQL4Dk06HWXLvl3gTgBDmNywLGP2RFJok0oWRK
         EmJfLE/IVh8+lrxUOiPWNh81NNpNOkuRt78t5O/3cxtseHMtkvkxnY1tI3oudw19WQ
         g0v+Qlda1p/WjvRXqGJReCyGEIV0/2xlQFM6RLNg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Ling <gnaygnil@gmail.com>,
        Keguang Zhang <keguang.zhang@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 60/61] MIPS: loongson32: ls1c: Fix hang during startup
Date:   Tue, 13 Sep 2022 16:08:02 +0200
Message-Id: <20220913140349.452979631@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140346.422813036@linuxfoundation.org>
References: <20220913140346.422813036@linuxfoundation.org>
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



