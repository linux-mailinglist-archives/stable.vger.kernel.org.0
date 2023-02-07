Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50C5968D7C1
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:03:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231996AbjBGNDH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:03:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232100AbjBGNC5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:02:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D9372FCF2
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:02:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AAEA961411
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:02:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B72A0C433EF;
        Tue,  7 Feb 2023 13:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675774956;
        bh=LGhrTu8dDwWqP1rkr28Vl8YPkH6lCuJpFE2ruP5mHYE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N3Lgr3Nffoz56IeRj9lA5Ua4MrHweHfsLUFP8ogOAmqwNvfqMnP47CS/x2qTLiv9d
         0L8AK+c9u/Omyt6yQts/hzGLIE/Aeoe/yA7thq/Nemy04MSoVWfcxYjFiE8pKIIQqV
         eekxgtDU5CWFmoDEx9ZOVYl6aqGRUq18vQTB52TI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Arnd Bergmann <arnd@arndb.de>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 090/208] rtc: sunplus: fix format string for printing resource
Date:   Tue,  7 Feb 2023 13:55:44 +0100
Message-Id: <20230207125638.434274692@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 08279468a294d8c996a657ecc9e51bd5c084c75d ]

On 32-bit architectures with 64-bit resource_size_t, sp_rtc_probe()
causes a compiler warning:

drivers/rtc/rtc-sunplus.c: In function 'sp_rtc_probe':
drivers/rtc/rtc-sunplus.c:243:33: error: format '%x' expects argument of type 'unsigned int', but argument 4 has type 'resource_size_t' {aka 'long long unsigned int'} [-Werror=format=]
  243 |         dev_dbg(&plat_dev->dev, "res = 0x%x, reg_base = 0x%lx\n",
      |                                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The best way to print a resource is the special %pR format string,
and similarly to print a pointer we can use %p and avoid the cast.

Fixes: fad6cbe9b2b4 ("rtc: Add driver for RTC in Sunplus SP7021")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20230117172450.2938962-1-arnd@kernel.org
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-sunplus.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-sunplus.c b/drivers/rtc/rtc-sunplus.c
index e8e2ab1103fc..4b578e4d44f6 100644
--- a/drivers/rtc/rtc-sunplus.c
+++ b/drivers/rtc/rtc-sunplus.c
@@ -240,8 +240,8 @@ static int sp_rtc_probe(struct platform_device *plat_dev)
 	if (IS_ERR(sp_rtc->reg_base))
 		return dev_err_probe(&plat_dev->dev, PTR_ERR(sp_rtc->reg_base),
 					    "%s devm_ioremap_resource fail\n", RTC_REG_NAME);
-	dev_dbg(&plat_dev->dev, "res = 0x%x, reg_base = 0x%lx\n",
-		sp_rtc->res->start, (unsigned long)sp_rtc->reg_base);
+	dev_dbg(&plat_dev->dev, "res = %pR, reg_base = %p\n",
+		sp_rtc->res, sp_rtc->reg_base);
 
 	sp_rtc->irq = platform_get_irq(plat_dev, 0);
 	if (sp_rtc->irq < 0)
-- 
2.39.0



