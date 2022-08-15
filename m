Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15B195943D3
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346097AbiHOWsQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:48:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352099AbiHOWrv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:47:51 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62254135AE0;
        Mon, 15 Aug 2022 12:53:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5522ECE12C1;
        Mon, 15 Aug 2022 19:53:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CECCC433D6;
        Mon, 15 Aug 2022 19:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593202;
        bh=hyTcSWCJpM8XrR++nPsIwaPrLzF9BBedKqDgX0Srn/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kUuHy/+V3COipcsKw8jGJcNicuMAWydJ353y82ab/nsg/UmLHrCM3MbJMURuDq2J2
         poZkzI5ulExEHkgFBpfF7zwy4PowRKlsu1zAxVpOaxScZZERnJmVvKsWSKkjBKMw8W
         w5a65Rz4LFYkoNSaEJVVXOcmkUw5KzveZsRVwLU0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0893/1095] mfd: t7l66xb: Drop platform disable callback
Date:   Mon, 15 Aug 2022 20:04:52 +0200
Message-Id: <20220815180506.269443880@linuxfoundation.org>
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

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 128ac294e1b437cb8a7f2ff8ede1cde9082bddbe ]

None of the in-tree instantiations of struct t7l66xb_platform_data
provides a disable callback. So better don't dereference this function
pointer unconditionally. As there is no user, drop it completely instead
of calling it conditional.

This is a preparation for making platform remove callbacks return void.

Fixes: 1f192015ca5b ("mfd: driver for the T7L66XB TMIO SoC")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Link: https://lore.kernel.org/r/20220530192430.2108217-3-u.kleine-koenig@pengutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/t7l66xb.c       | 6 +-----
 include/linux/mfd/t7l66xb.h | 1 -
 2 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/mfd/t7l66xb.c b/drivers/mfd/t7l66xb.c
index 5369c67e3280..663ffd4b8570 100644
--- a/drivers/mfd/t7l66xb.c
+++ b/drivers/mfd/t7l66xb.c
@@ -397,11 +397,8 @@ static int t7l66xb_probe(struct platform_device *dev)
 
 static int t7l66xb_remove(struct platform_device *dev)
 {
-	struct t7l66xb_platform_data *pdata = dev_get_platdata(&dev->dev);
 	struct t7l66xb *t7l66xb = platform_get_drvdata(dev);
-	int ret;
 
-	ret = pdata->disable(dev);
 	clk_disable_unprepare(t7l66xb->clk48m);
 	clk_put(t7l66xb->clk48m);
 	clk_disable_unprepare(t7l66xb->clk32k);
@@ -412,8 +409,7 @@ static int t7l66xb_remove(struct platform_device *dev)
 	mfd_remove_devices(&dev->dev);
 	kfree(t7l66xb);
 
-	return ret;
-
+	return 0;
 }
 
 static struct platform_driver t7l66xb_platform_driver = {
diff --git a/include/linux/mfd/t7l66xb.h b/include/linux/mfd/t7l66xb.h
index 69632c1b07bd..ae3e7a5c5219 100644
--- a/include/linux/mfd/t7l66xb.h
+++ b/include/linux/mfd/t7l66xb.h
@@ -12,7 +12,6 @@
 
 struct t7l66xb_platform_data {
 	int (*enable)(struct platform_device *dev);
-	int (*disable)(struct platform_device *dev);
 	int (*suspend)(struct platform_device *dev);
 	int (*resume)(struct platform_device *dev);
 
-- 
2.35.1



