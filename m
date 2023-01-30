Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21C49681114
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:10:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237202AbjA3OKD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:10:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237188AbjA3OKA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:10:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C3163B66A
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:09:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF3E361025
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:09:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF13AC433D2;
        Mon, 30 Jan 2023 14:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087795;
        bh=QLX6WgW1wIuVM837j38lDg2WUtVYMLuCnvNM1srsRJk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UPINpBPIbJJUzsQJUhwlKcgjSvqFvXHOIfiYimFLG7lOShrwgg6E210nItf9so0wY
         9Fg2jmbbtIsuwMooJiFSlDwfUolwuU3btKmcYZqLQ+xhWXWJonAX14xZbiHoZYGcIJ
         JRWtBZjZdbkM7gUm652pvjRRLS+/aAcXiQrAj82M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Miaoqian Lin <linmq006@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 013/204] soc: imx8m: Fix incorrect check for of_clk_get_by_name()
Date:   Mon, 30 Jan 2023 14:49:38 +0100
Message-Id: <20230130134316.887623406@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 490748874ebf1875420fc29b335bba2075dd1b5e ]

of_clk_get_by_name() returns error pointers instead of NULL.
Use IS_ERR() checks the return value to catch errors.

Fixes: 836fb30949d9 ("soc: imx8m: Enable OCOTP clock before reading the register")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/imx/soc-imx8m.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/soc/imx/soc-imx8m.c b/drivers/soc/imx/soc-imx8m.c
index 28144c699b0c..32ed9dc88e45 100644
--- a/drivers/soc/imx/soc-imx8m.c
+++ b/drivers/soc/imx/soc-imx8m.c
@@ -66,8 +66,8 @@ static u32 __init imx8mq_soc_revision(void)
 	ocotp_base = of_iomap(np, 0);
 	WARN_ON(!ocotp_base);
 	clk = of_clk_get_by_name(np, NULL);
-	if (!clk) {
-		WARN_ON(!clk);
+	if (IS_ERR(clk)) {
+		WARN_ON(IS_ERR(clk));
 		return 0;
 	}
 
-- 
2.39.0



