Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8670C4E93C8
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 13:23:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241082AbiC1LY7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 07:24:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240740AbiC1LVm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 07:21:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4352A56762;
        Mon, 28 Mar 2022 04:19:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F216EB80D13;
        Mon, 28 Mar 2022 11:19:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6509C340ED;
        Mon, 28 Mar 2022 11:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648466360;
        bh=1KWVZF7w0fNVTrIkmuPkWcffLLKVAnhqr2mFvwSQ+10=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iWs2Es2buj2lOD8y8mkwSkQwaOxJB+BY/ta7yWxDc+tz9Tp3KBjCWtbzLmpnZjRZK
         qDSQ/woVR1MQJGGEa+vY62EoutRsaedM29km4cJGyTJuN9Vo+6UATYETzGchBCmW1v
         MnwKhOGG7Ghpz2kaVw18ypDwUUMgs1hZLCddYvLua2iqV1mqNB+OeYsKX88O8ScXwk
         i/vhNiAxJHUyqT4kkmK24A4kPOrZUGti10oPJlx3NqS87uf/eiTFFAgcQQ+2adxsvv
         jc67nj8r2jHXUTmWpDDjJ+BqvQSOnhcRnrXakNeM27aiXMv6iKXle+oFl8yzFXUKXh
         PpE+vKTAxg32Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Souptick Joarder (HPE)" <jrdr.linux@gmail.com>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>,
        tglx@linutronix.de
Subject: [PATCH AUTOSEL 5.17 26/43] irqchip/nvic: Release nvic_base upon failure
Date:   Mon, 28 Mar 2022 07:18:10 -0400
Message-Id: <20220328111828.1554086-26-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220328111828.1554086-1-sashal@kernel.org>
References: <20220328111828.1554086-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: "Souptick Joarder (HPE)" <jrdr.linux@gmail.com>

[ Upstream commit e414c25e3399b2b3d7337dc47abccab5c71b7c8f ]

smatch warning was reported as below ->

smatch warnings:
drivers/irqchip/irq-nvic.c:131 nvic_of_init()
warn: 'nvic_base' not released on lines: 97.

Release nvic_base upon failure.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Souptick Joarder (HPE) <jrdr.linux@gmail.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20220218163303.33344-1-jrdr.linux@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-nvic.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/irqchip/irq-nvic.c b/drivers/irqchip/irq-nvic.c
index ba4759b3e269..94230306e0ee 100644
--- a/drivers/irqchip/irq-nvic.c
+++ b/drivers/irqchip/irq-nvic.c
@@ -107,6 +107,7 @@ static int __init nvic_of_init(struct device_node *node,
 
 	if (!nvic_irq_domain) {
 		pr_warn("Failed to allocate irq domain\n");
+		iounmap(nvic_base);
 		return -ENOMEM;
 	}
 
@@ -116,6 +117,7 @@ static int __init nvic_of_init(struct device_node *node,
 	if (ret) {
 		pr_warn("Failed to allocate irq chips\n");
 		irq_domain_remove(nvic_irq_domain);
+		iounmap(nvic_base);
 		return ret;
 	}
 
-- 
2.34.1

