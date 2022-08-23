Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9607359DF07
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241852AbiHWLhU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:37:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353520AbiHWLe3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:34:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D79390C47;
        Tue, 23 Aug 2022 02:27:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05438B81C86;
        Tue, 23 Aug 2022 09:27:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D019FC433C1;
        Tue, 23 Aug 2022 09:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661246826;
        bh=Ky0G+HXDAibndQuRjRtmrE/WIXSqg4zZpDs5vU9WPBI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=149PHoGSF3eqngqU/ggGsqFaI5dT/CliBim+bLPoXIcYXaWsUt/Rwgsx24KA/NuoU
         1/Ie4pEWTHXypSkCfFeetj6FAken3nHwaKa4I3Fou/iOUHIb61puERQBFC7Ovp3u7e
         KmWbcY7fjmGP9hsiF7YW41cX1ijT8tYTbvom2XOo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tang Bin <tangbin@cmss.chinamobile.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 202/389] opp: Fix error check in dev_pm_opp_attach_genpd()
Date:   Tue, 23 Aug 2022 10:24:40 +0200
Message-Id: <20220823080124.080067446@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
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

[ Upstream commit 4ea9496cbc959eb5c78f3e379199aca9ef4e386b ]

dev_pm_domain_attach_by_name() may return NULL in some cases,
so IS_ERR() doesn't meet the requirements. Thus fix it.

Fixes: 6319aee10e53 ("opp: Attach genpds to devices from within OPP core")
Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
[ Viresh: Replace ENODATA with ENODEV ]
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/opp/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/opp/core.c b/drivers/opp/core.c
index 088c93dc0085..08f5d1c3d665 100644
--- a/drivers/opp/core.c
+++ b/drivers/opp/core.c
@@ -1881,8 +1881,8 @@ struct opp_table *dev_pm_opp_attach_genpd(struct device *dev,
 		}
 
 		virt_dev = dev_pm_domain_attach_by_name(dev, *name);
-		if (IS_ERR(virt_dev)) {
-			ret = PTR_ERR(virt_dev);
+		if (IS_ERR_OR_NULL(virt_dev)) {
+			ret = PTR_ERR(virt_dev) ? : -ENODEV;
 			dev_err(dev, "Couldn't attach to pm_domain: %d\n", ret);
 			goto err;
 		}
-- 
2.35.1



