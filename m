Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85DF7594CA5
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:33:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234177AbiHPAgi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:36:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346491AbiHPAeP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:34:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C12B8187FB2;
        Mon, 15 Aug 2022 13:37:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D959DB8113E;
        Mon, 15 Aug 2022 20:37:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13BE6C433D6;
        Mon, 15 Aug 2022 20:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595833;
        bh=rluxVmy3NVmSakIwv/OCznUngpWOb3PtWKVLTkuHedA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OEzmJviKorsVs6xwzu9R8vzbgTFsq/yRlLNEyK5I17FSyA7IXWLFonDeM0vG02rQ1
         IaDgjtj6P4XV9hBiefWA/8LvU+3GCqFMOsgj3CDr9xC/pf9SwXdaYkNLPp5Db69MG4
         rrVLtw2WPQwNNCGnGsaHnLspd9II2Tz6GIRanBmA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tang Bin <tangbin@cmss.chinamobile.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0889/1157] opp: Fix error check in dev_pm_opp_attach_genpd()
Date:   Mon, 15 Aug 2022 20:04:05 +0200
Message-Id: <20220815180515.010892390@linuxfoundation.org>
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
index 84063eaebb91..ff0364733dcb 100644
--- a/drivers/opp/core.c
+++ b/drivers/opp/core.c
@@ -2528,8 +2528,8 @@ struct opp_table *dev_pm_opp_attach_genpd(struct device *dev,
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



