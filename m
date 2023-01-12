Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2271667489
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:09:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234286AbjALOJR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:09:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233480AbjALOI1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:08:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0FD056899
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:04:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 04B5F60110
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:04:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A219C433D2;
        Thu, 12 Jan 2023 14:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673532286;
        bh=WBJtCJDaMxknpk0Gofvzh1Y9UkDVAQz9yZA/U7Di8Dc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=033pj3xcgzXr4OXeUIqqLxfJrdzjaX88i3K+bRhjIDVfkh30GLWvrehYcUOQ2/3GS
         i8J509tM5D5PW8ZAftz6ZdJhmvWf+ndzKV6W31sMmIqmcz5FzmrkrKkN9JD5Hi58TH
         /RrP1CWMeLqNyKqPosjfb1k2/1QapzHt/RLCGUxI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tang Bin <tangbin@cmss.chinamobile.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 112/783] venus: pm_helpers: Fix error check in vcodec_domains_get()
Date:   Thu, 12 Jan 2023 14:47:08 +0100
Message-Id: <20230112135529.392657485@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tang Bin <tangbin@cmss.chinamobile.com>

[ Upstream commit 0f6e8d8c94a82e85e1b9b62a7671990740dc6f70 ]

In the function vcodec_domains_get(), dev_pm_domain_attach_by_name()
may return NULL in some cases, so IS_ERR() doesn't meet the
requirements. Thus fix it.

Fixes: 7482a983dea3 ("media: venus: redesign clocks and pm domains control")
Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/venus/pm_helpers.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/pm_helpers.c b/drivers/media/platform/qcom/venus/pm_helpers.c
index 710f9a2b132b..f7de02352f1b 100644
--- a/drivers/media/platform/qcom/venus/pm_helpers.c
+++ b/drivers/media/platform/qcom/venus/pm_helpers.c
@@ -764,8 +764,8 @@ static int vcodec_domains_get(struct venus_core *core)
 	for (i = 0; i < res->vcodec_pmdomains_num; i++) {
 		pd = dev_pm_domain_attach_by_name(dev,
 						  res->vcodec_pmdomains[i]);
-		if (IS_ERR(pd))
-			return PTR_ERR(pd);
+		if (IS_ERR_OR_NULL(pd))
+			return PTR_ERR(pd) ? : -ENODATA;
 		core->pmdomains[i] = pd;
 	}
 
-- 
2.35.1



