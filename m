Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62E7C59A0C5
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352171AbiHSQVU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:21:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352306AbiHSQUe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:20:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC343EC4EF;
        Fri, 19 Aug 2022 09:01:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B8A0A617A5;
        Fri, 19 Aug 2022 16:01:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4D9EC433D6;
        Fri, 19 Aug 2022 16:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924877;
        bh=Rb4IuH7qbdBC3csFboi8CTFe/x5QTqmzTvRnL83eiIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RIzjmkDd1kKcawH/fdwoi7kVX15aeGiPhUunPHE2RbE8+hBEPnv0N2HFyMWViOIz7
         +uowJ2P0DPadbXo1H/1kCdw/C8WSL39wiQ7Kax3pFMbfUDx16w8X7FxvQxIV2SdXfS
         cXgFFlS029QVGeE+di9HEIIG8UoCF6VS1sOjAhiY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tang Bin <tangbin@cmss.chinamobile.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 281/545] usb: gadget: tegra-xudc: Fix error check in tegra_xudc_powerdomain_init()
Date:   Fri, 19 Aug 2022 17:40:51 +0200
Message-Id: <20220819153841.886856141@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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

From: Tang Bin <tangbin@cmss.chinamobile.com>

[ Upstream commit f08aa7c80dac27ee00fa6827f447597d2fba5465 ]

dev_pm_domain_attach_by_name() may return NULL in some cases,
so IS_ERR() doesn't meet the requirements. Thus fix it.

Fixes: 49db427232fe ("usb: gadget: Add UDC driver for tegra XUSB device mode controller")
Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
Link: https://lore.kernel.org/r/20220525135332.23144-1-tangbin@cmss.chinamobile.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/tegra-xudc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/gadget/udc/tegra-xudc.c b/drivers/usb/gadget/udc/tegra-xudc.c
index de178bf264c2..3ebc8c5416e3 100644
--- a/drivers/usb/gadget/udc/tegra-xudc.c
+++ b/drivers/usb/gadget/udc/tegra-xudc.c
@@ -3693,15 +3693,15 @@ static int tegra_xudc_powerdomain_init(struct tegra_xudc *xudc)
 	int err;
 
 	xudc->genpd_dev_device = dev_pm_domain_attach_by_name(dev, "dev");
-	if (IS_ERR(xudc->genpd_dev_device)) {
-		err = PTR_ERR(xudc->genpd_dev_device);
+	if (IS_ERR_OR_NULL(xudc->genpd_dev_device)) {
+		err = PTR_ERR(xudc->genpd_dev_device) ? : -ENODATA;
 		dev_err(dev, "failed to get device power domain: %d\n", err);
 		return err;
 	}
 
 	xudc->genpd_dev_ss = dev_pm_domain_attach_by_name(dev, "ss");
-	if (IS_ERR(xudc->genpd_dev_ss)) {
-		err = PTR_ERR(xudc->genpd_dev_ss);
+	if (IS_ERR_OR_NULL(xudc->genpd_dev_ss)) {
+		err = PTR_ERR(xudc->genpd_dev_ss) ? : -ENODATA;
 		dev_err(dev, "failed to get SuperSpeed power domain: %d\n", err);
 		return err;
 	}
-- 
2.35.1



