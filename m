Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2246759A14D
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:35:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352083AbiHSQVK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:21:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352228AbiHSQUK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:20:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E84D9108FA7;
        Fri, 19 Aug 2022 09:01:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5ED5B8280C;
        Fri, 19 Aug 2022 16:01:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DB01C433D6;
        Fri, 19 Aug 2022 16:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924880;
        bh=OtPWqZkomw1fPfVd90lTptA0F5WqoBTC8rGiNIX4stM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G7CgckDtXpzjXqJKhZU0iUDY4HX/pPW1glEei4SDBYEE6KKrZspWw9UKR+tpTdObf
         9TeK2HNeBZeMYQrihJxUykN29zpg0YqnM+Aigj0FxC26ykvJJ7gv6BG1CKArv5MZBe
         3VBTo4k+h/pSZp/G9opgzWlPDX+w/bLVcuRWqnJo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tang Bin <tangbin@cmss.chinamobile.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 282/545] usb: xhci: tegra: Fix error check
Date:   Fri, 19 Aug 2022 17:40:52 +0200
Message-Id: <20220819153841.931627948@linuxfoundation.org>
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

[ Upstream commit 18fc7c435be3f17ea26a21b2e2312fcb9088e01f ]

In the function tegra_xusb_powerdomain_init(),
dev_pm_domain_attach_by_name() may return NULL in some cases,
so IS_ERR() doesn't meet the requirements. Thus fix it.

Fixes: 6494a9ad86de ("usb: xhci: tegra: Add genpd support")
Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
Link: https://lore.kernel.org/r/20220524121404.18376-1-tangbin@cmss.chinamobile.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-tegra.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/host/xhci-tegra.c b/drivers/usb/host/xhci-tegra.c
index 50bb91b6a4b8..246a3d274142 100644
--- a/drivers/usb/host/xhci-tegra.c
+++ b/drivers/usb/host/xhci-tegra.c
@@ -1042,15 +1042,15 @@ static int tegra_xusb_powerdomain_init(struct device *dev,
 	int err;
 
 	tegra->genpd_dev_host = dev_pm_domain_attach_by_name(dev, "xusb_host");
-	if (IS_ERR(tegra->genpd_dev_host)) {
-		err = PTR_ERR(tegra->genpd_dev_host);
+	if (IS_ERR_OR_NULL(tegra->genpd_dev_host)) {
+		err = PTR_ERR(tegra->genpd_dev_host) ? : -ENODATA;
 		dev_err(dev, "failed to get host pm-domain: %d\n", err);
 		return err;
 	}
 
 	tegra->genpd_dev_ss = dev_pm_domain_attach_by_name(dev, "xusb_ss");
-	if (IS_ERR(tegra->genpd_dev_ss)) {
-		err = PTR_ERR(tegra->genpd_dev_ss);
+	if (IS_ERR_OR_NULL(tegra->genpd_dev_ss)) {
+		err = PTR_ERR(tegra->genpd_dev_ss) ? : -ENODATA;
 		dev_err(dev, "failed to get superspeed pm-domain: %d\n", err);
 		return err;
 	}
-- 
2.35.1



