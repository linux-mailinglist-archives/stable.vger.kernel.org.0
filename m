Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 194FE594FB2
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbiHPEbr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:31:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230014AbiHPEbR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:31:17 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 991CD16658A;
        Mon, 15 Aug 2022 13:22:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5B312CE12DE;
        Mon, 15 Aug 2022 20:22:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3059DC433C1;
        Mon, 15 Aug 2022 20:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594968;
        bh=2iiww0YZVx3IsAfXGgFTGknilWMD0Hkj0gj15HbjlMg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZdRcUG/Ec9MbF5GgK36iizLEzsdSEGWOptT35dtYmYr2xtNO7QiTbsi1GbEXQNwFN
         USm+yZ2Y53Lpz/C/zMk5wl/Aw66DOR/k3Q4+oX41514TM5eqmdjq5A0BD981JKkk2b
         A6U7i22HsROZXCg47K4aoFhoUimNijKsl7130AJY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tang Bin <tangbin@cmss.chinamobile.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0614/1157] usb: xhci: tegra: Fix error check
Date:   Mon, 15 Aug 2022 19:59:30 +0200
Message-Id: <20220815180504.209528033@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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
index 996958a6565c..bdb776553826 100644
--- a/drivers/usb/host/xhci-tegra.c
+++ b/drivers/usb/host/xhci-tegra.c
@@ -1010,15 +1010,15 @@ static int tegra_xusb_powerdomain_init(struct device *dev,
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



