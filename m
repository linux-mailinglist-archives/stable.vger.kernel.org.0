Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7C56B4224
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231499AbjCJOAP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:00:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231510AbjCJOAH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:00:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E9B2112A4C
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:00:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 09B14B822B1
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:00:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D4E5C433EF;
        Fri, 10 Mar 2023 14:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678456803;
        bh=F8FewJ31dQ1Dg861HaHKWxUUUXVVumBqMtx5jiA84Jg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gX6k95HHmmlLBlruSUFRv2WVRRO44QFj2kR4FteYvgrnHoAiJOOqJLSkktlYnMVLX
         qCA+qBJWw9QvgcrnOGds0IlqRqI3dsdwtUruPAFXsmnFE8uxJkFFLBMixdYaoO59ob
         fqbJYsKBJElv9UIBvpDAcvHSUXTnqPGsX0lpywEE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Liang He <windhl@126.com>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Lee Jones <lee@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 129/211] mfd: arizona: Use pm_runtime_resume_and_get() to prevent refcnt leak
Date:   Fri, 10 Mar 2023 14:38:29 +0100
Message-Id: <20230310133722.652204513@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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



