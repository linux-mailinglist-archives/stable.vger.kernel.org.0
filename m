Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 532116A7120
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 17:31:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbjCAQbh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 11:31:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230044AbjCAQbI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 11:31:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3377848E08;
        Wed,  1 Mar 2023 08:30:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 85EA16143A;
        Wed,  1 Mar 2023 16:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30895C433D2;
        Wed,  1 Mar 2023 16:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677688216;
        bh=ced601IhyK1K90b/nXeeu6qc3sVmWuekntbizS2kQBA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ihPA79vtf6O/kAhdK5Q5bYgxqz9OVYdHEChu0LTJIBeuAn55mahgXF+lIeecbh15e
         Ku5mT8MS9nCOgj6Dz4GtddcZm6bcIGYqUQUi5UNbGk2qx6Yc9nDkcn36PxUBCXJLL8
         zBQKec7XhEn+nTU6weR05mKlJA0ourGDKbJXS2YgT4nbsCDXR5Xr41+DRB650fQK9z
         zaBKLLyp2rtm2x06Y3h1EZWFeAU6SKDVbJe10pIiKbzFLm3zi11LJcFAeaCYFTz3Gp
         uU3zgn9epc5y3cDBk7161iU1gnA2ndj7PBZ1vS8PRlun4rLe/DmSbt3f+G+3Uh0aS7
         +eH3dFKOgXoMQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Liang He <windhl@126.com>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Lee Jones <lee@kernel.org>, Sasha Levin <sashal@kernel.org>,
        patches@opensource.cirrus.com
Subject: [PATCH AUTOSEL 5.4 4/4] mfd: arizona: Use pm_runtime_resume_and_get() to prevent refcnt leak
Date:   Wed,  1 Mar 2023 11:30:07 -0500
Message-Id: <20230301163007.1303162-4-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230301163007.1303162-1-sashal@kernel.org>
References: <20230301163007.1303162-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liang He <windhl@126.com>

[ Upstream commit 4414a7ab80cebf715045e3c4d465feefbad21139 ]

In arizona_clk32k_enable(), we should use pm_runtime_resume_and_get()
as pm_runtime_get_sync() will increase the refcnt even when it
returns an error.

Signed-off-by: Liang He <windhl@126.com>
Acked-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Signed-off-by: Lee Jones <lee@kernel.org>
Link: https://lore.kernel.org/r/20230105061055.1509261-1-windhl@126.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/arizona-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index 3ff872c205eeb..07d256e6875c0 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -45,7 +45,7 @@ int arizona_clk32k_enable(struct arizona *arizona)
 	if (arizona->clk32k_ref == 1) {
 		switch (arizona->pdata.clk32k_src) {
 		case ARIZONA_32KZ_MCLK1:
-			ret = pm_runtime_get_sync(arizona->dev);
+			ret = pm_runtime_resume_and_get(arizona->dev);
 			if (ret != 0)
 				goto err_ref;
 			ret = clk_prepare_enable(arizona->mclk[ARIZONA_MCLK1]);
-- 
2.39.2

