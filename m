Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE1755EA583
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 14:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239069AbiIZMGc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 08:06:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239638AbiIZMEw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 08:04:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDE4017590;
        Mon, 26 Sep 2022 03:54:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7B023B80835;
        Mon, 26 Sep 2022 10:48:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB42BC433D6;
        Mon, 26 Sep 2022 10:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189306;
        bh=09tTN7yUH5tIKpaq/OFSWMXTbbcnSxc+91PHZDmxjQk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fG1wA3HhACGToDa/AJw6gNhk4YG2v31DnKDTsONE5eHVcYBNi/+bHBEffsHJwNWmZ
         BrnI/h4p+lng6x/Md41n2zmA0r7a3mUJw19/5e97mTECl1yYhLzNJbHOTKGzsugUid
         19CAovVXS6P2bS219q7/exAwEyP6pNL0WekDknwo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Dongliang Mu <mudongliangabcd@gmail.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 143/207] gpio: tqmx86: fix uninitialized variable girq
Date:   Mon, 26 Sep 2022 12:12:12 +0200
Message-Id: <20220926100812.906881247@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dongliang Mu <mudongliangabcd@gmail.com>

[ Upstream commit 21a9acc162457402c74c5c1e16471fda6eb090c0 ]

The commit 924610607f19 ("gpio: tpmx86: Move PM device over to
irq domain") adds a dereference of girq that may be uninitialized.

Fix this by moving irq_domain_set_pm_device into if true branch
as suggested by Marc Zyngier.

Fixes: 924610607f19 ("gpio: tpmx86: Move PM device over to irq domain")
Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
Acked-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-tqmx86.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-tqmx86.c b/drivers/gpio/gpio-tqmx86.c
index fa4bc7481f9a..e739dcea61b2 100644
--- a/drivers/gpio/gpio-tqmx86.c
+++ b/drivers/gpio/gpio-tqmx86.c
@@ -307,6 +307,8 @@ static int tqmx86_gpio_probe(struct platform_device *pdev)
 		girq->default_type = IRQ_TYPE_NONE;
 		girq->handler = handle_simple_irq;
 		girq->init_valid_mask = tqmx86_init_irq_valid_mask;
+
+		irq_domain_set_pm_device(girq->domain, dev);
 	}
 
 	ret = devm_gpiochip_add_data(dev, chip, gpio);
@@ -315,8 +317,6 @@ static int tqmx86_gpio_probe(struct platform_device *pdev)
 		goto out_pm_dis;
 	}
 
-	irq_domain_set_pm_device(girq->domain, dev);
-
 	dev_info(dev, "GPIO functionality initialized with %d pins\n",
 		 chip->ngpio);
 
-- 
2.35.1



