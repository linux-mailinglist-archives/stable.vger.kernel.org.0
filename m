Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72E106A70EC
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 17:29:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbjCAQ3t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 11:29:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbjCAQ3l (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 11:29:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89DFA43902;
        Wed,  1 Mar 2023 08:29:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0A1E3B810B9;
        Wed,  1 Mar 2023 16:29:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FAE6C433EF;
        Wed,  1 Mar 2023 16:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677688177;
        bh=F8FewJ31dQ1Dg861HaHKWxUUUXVVumBqMtx5jiA84Jg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IQaJVanyhCa0T+ff+yz305fgnuzEcmS3Hl8yRh1BVsJml1CMabiB2oFsogfcWuSau
         35KBtVbSVKPdDUDC/aILX00QDeP33I+HOjjlvWHTRNG/bEH6OEpyob5JzomUgnCnGH
         7mfI0MxfgPgqh+L1bRYI5d+RfOtUIILr+pliZF0ZKwY7D7aEO5mkL+gp7WErJ6dbZM
         MF9zHmW/crgDSwGSl7bs80Ay+OoMVvWbV8j8tmTbuTI5SpgZnDM/CbWn5voOrWVmET
         AWdY21PGzpdFmkRLNmBES3o2KUpOkrNIUhMespH/CNpwR1Mg6xbWf0jli55heD1+OJ
         LY4tPr+GsLxhQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Liang He <windhl@126.com>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Lee Jones <lee@kernel.org>, Sasha Levin <sashal@kernel.org>,
        patches@opensource.cirrus.com
Subject: [PATCH AUTOSEL 6.2 6/6] mfd: arizona: Use pm_runtime_resume_and_get() to prevent refcnt leak
Date:   Wed,  1 Mar 2023 11:29:29 -0500
Message-Id: <20230301162929.1302785-6-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230301162929.1302785-1-sashal@kernel.org>
References: <20230301162929.1302785-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
index bd7ee3260d53f..c166fcd331f11 100644
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

