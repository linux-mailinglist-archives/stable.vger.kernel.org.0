Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 741D8594405
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242895AbiHOWsO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:48:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351932AbiHOWrX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:47:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79FA5134B9C;
        Mon, 15 Aug 2022 12:53:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E41E861178;
        Mon, 15 Aug 2022 19:53:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB43FC433D6;
        Mon, 15 Aug 2022 19:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593184;
        bh=n53XmxCgwLMlqFZN8KbH07lCxfM9RjyR4HTH0+4uqBk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XHfhGwCZC66ElinauN7Z/MJItsmlvvDr1QfHA8TQpfFheVOSxFyHlUlDcYiLigQFp
         oE7QTBLrvC7c1LKipf4yCIwO5lntM34O+18S+Zg9n56QRG4h3VyIqheRn6TiaMSwm/
         gxlV9OAZdAy0R0sZ/JdCe7xKGzS1DxvRObbEv4aY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0908/1095] watchdog: f71808e_wdt: Add check for platform_driver_register
Date:   Mon, 15 Aug 2022 20:05:07 +0200
Message-Id: <20220815180506.855128263@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit 97d5ec548150764946f38632e62e79759832b54b ]

As platform_driver_register() could fail, it should be better
to deal with the return value in order to maintain the code
consisitency.

Fixes: 27e0fe00a5c6 ("watchdog: f71808e_wdt: refactor to platform device/driver pair")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
https://lore.kernel.org/r/20220526080303.1005063-1-jiasheng@iscas.ac.cn
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/f71808e_wdt.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/watchdog/f71808e_wdt.c b/drivers/watchdog/f71808e_wdt.c
index 7f59c680de25..6a16d3d0bb1e 100644
--- a/drivers/watchdog/f71808e_wdt.c
+++ b/drivers/watchdog/f71808e_wdt.c
@@ -634,7 +634,9 @@ static int __init fintek_wdt_init(void)
 
 	pdata.type = ret;
 
-	platform_driver_register(&fintek_wdt_driver);
+	ret = platform_driver_register(&fintek_wdt_driver);
+	if (ret)
+		return ret;
 
 	wdt_res.name = "superio port";
 	wdt_res.flags = IORESOURCE_IO;
-- 
2.35.1



