Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 555475944F6
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348222AbiHOW3x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:29:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349755AbiHOW0I (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:26:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CC1D127BDF;
        Mon, 15 Aug 2022 12:44:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B8B43B81145;
        Mon, 15 Aug 2022 19:44:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA3AEC433D6;
        Mon, 15 Aug 2022 19:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592689;
        bh=CQV3gtFCOEyCWtZCTkXMTvy003w/H2jNvTviBBARrVw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qk9xudA/hx57GE0mKnPUuCo3wje5LXqCQgLtmX1BmRNMq7DdAJcH9iHM0jCtzfsDe
         rSgP4HE0X9VypquIgqj+cVuZ5RfYakZSkfqO+x1SEKjX7zok1XCdJ+VBykjbB4wmGw
         TG/qzLBuCHtwnW2GjFbFkazMNztR08EKabG8t8W4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tang Bin <tangbin@cmss.chinamobile.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0826/1095] opp: Fix error check in dev_pm_opp_attach_genpd()
Date:   Mon, 15 Aug 2022 20:03:45 +0200
Message-Id: <20220815180503.476260372@linuxfoundation.org>
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
index 740407252298..e154b18ec4b1 100644
--- a/drivers/opp/core.c
+++ b/drivers/opp/core.c
@@ -2413,8 +2413,8 @@ struct opp_table *dev_pm_opp_attach_genpd(struct device *dev,
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



