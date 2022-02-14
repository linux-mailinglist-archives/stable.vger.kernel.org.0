Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC714B45B5
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:28:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242996AbiBNJ23 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:28:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240782AbiBNJ21 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:28:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F91A60AA4;
        Mon, 14 Feb 2022 01:28:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C6EF60F6F;
        Mon, 14 Feb 2022 09:28:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7DDAC340E9;
        Mon, 14 Feb 2022 09:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644830896;
        bh=hRtrWBykj6E5T6iIICRlVCXt4vP+E52UMPBoKDEpMrQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JK9e577jt4KoioZQrM0QMJoJiedHtGZs/4Mdo1hcgXxj0GNYCCCCVfjFQtgtWpXi6
         bUo2tr/YuW8NN4zJ/ANQCkT9iB/ZmauXiMwh5CrKjGjx47F88UEr96/74RWuGX6eVJ
         RZY9YANqNsdQepSr4xtcO0A9z421Gf66jkf8dd/A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 15/34] staging: fbtft: Fix error path in fbtft_driver_module_init()
Date:   Mon, 14 Feb 2022 10:25:41 +0100
Message-Id: <20220214092446.440462381@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092445.946718557@linuxfoundation.org>
References: <20220214092445.946718557@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 426aca16e903b387a0b0001d62207a745c67cfd3 ]

If registering the platform driver fails, the function must not return
without undoing the spi driver registration first.

Fixes: c296d5f9957c ("staging: fbtft: core support")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/20220118181338.207943-1-u.kleine-koenig@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/fbtft/fbtft.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/fbtft/fbtft.h b/drivers/staging/fbtft/fbtft.h
index 0275319906748..a76723a4219a6 100644
--- a/drivers/staging/fbtft/fbtft.h
+++ b/drivers/staging/fbtft/fbtft.h
@@ -343,7 +343,10 @@ static int __init fbtft_driver_module_init(void)                           \
 	ret = spi_register_driver(&fbtft_driver_spi_driver);               \
 	if (ret < 0)                                                       \
 		return ret;                                                \
-	return platform_driver_register(&fbtft_driver_platform_driver);    \
+	ret = platform_driver_register(&fbtft_driver_platform_driver);     \
+	if (ret < 0)                                                       \
+		spi_unregister_driver(&fbtft_driver_spi_driver);           \
+	return ret;                                                        \
 }                                                                          \
 									   \
 static void __exit fbtft_driver_module_exit(void)                          \
-- 
2.34.1



