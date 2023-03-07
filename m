Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE9DC6AF3E5
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:11:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233751AbjCGTLM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:11:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233619AbjCGTKp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:10:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FB41C80AC
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:55:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E1B1CB819D0
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:55:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2328EC433EF;
        Tue,  7 Mar 2023 18:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215313;
        bh=NJokxeRz2ElFMC5qjGsE5/0I78RhCF054mqHRAsKAMQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rzo6oG3/A9GsAVeKO8MBuWd5NFv6Uaa5EXx/2tvcxFYVoz9kp7RiwOn7Iw0hOk+NT
         hEAR8z3z317qpoh3uff9V92JaJ+sNJviXY5Y6OcgQuOiaMxekWfJ1bPJpSVDMSBDIa
         BJDBGUv8DYPOQcKdVNKC7KH/XoCSRUvCqhVlLOos=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Clark Wang <xiaoning.wang@nxp.com>,
        Haibo Chen <haibo.chen@nxp.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 219/567] gpio: vf610: connect GPIO label to dev name
Date:   Tue,  7 Mar 2023 17:59:15 +0100
Message-Id: <20230307165915.382599961@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Haibo Chen <haibo.chen@nxp.com>

[ Upstream commit 6f8ecb7f85f441eb7d78ba2a4df45ee8a821934e ]

Current GPIO label is fixed, so can't distinguish different GPIO
controllers through labels. Use dev name instead.

Fixes: 7f2691a19627 ("gpio: vf610: add gpiolib/IRQ chip driver for Vybrid")
Signed-off-by: Clark Wang <xiaoning.wang@nxp.com>
Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-vf610.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-vf610.c b/drivers/gpio/gpio-vf610.c
index 47e191e11c696..edb28af7ba3b0 100644
--- a/drivers/gpio/gpio-vf610.c
+++ b/drivers/gpio/gpio-vf610.c
@@ -304,7 +304,7 @@ static int vf610_gpio_probe(struct platform_device *pdev)
 	gc = &port->gc;
 	gc->of_node = np;
 	gc->parent = dev;
-	gc->label = "vf610-gpio";
+	gc->label = dev_name(dev);
 	gc->ngpio = VF610_GPIO_PER_PORT;
 	gc->base = of_alias_get_id(np, "gpio") * VF610_GPIO_PER_PORT;
 
-- 
2.39.2



