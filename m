Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1233F658371
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:47:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233305AbiL1Qry (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:47:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235098AbiL1QrY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:47:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48EC422C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:42:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA36FB8171F
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:42:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32FB8C433D2;
        Wed, 28 Dec 2022 16:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245753;
        bh=eOD5xF4l3voCHKji6uotozJLhreiNAuDHg892/xOdLo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XDfPSEK2AxibNxrQ9CYnBbLCPFCgkzYdDwYCou9+mRqTdVjS+T/X6BrjH5hrSQva3
         Qdr3jRkui6KplTe15nyAtbuyKUZUjOzYY2te5U/P6MsXv+W4dTpz9AhbY4lamk01R+
         HnYLUSbcHaGrqc5Gqe4v92WnXQ4rl2REfrUDNhZw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, GUO Zihua <guozihua@huawei.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0916/1146] rtc: mxc_v2: Add missing clk_disable_unprepare()
Date:   Wed, 28 Dec 2022 15:40:55 +0100
Message-Id: <20221228144355.125428310@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: GUO Zihua <guozihua@huawei.com>

[ Upstream commit 55d5a86618d3b1a768bce01882b74cbbd2651975 ]

The call to clk_disable_unprepare() is left out in the error handling of
devm_rtc_allocate_device. Add it back.

Fixes: 5490a1e018a4 ("rtc: mxc_v2: fix possible race condition")
Signed-off-by: GUO Zihua <guozihua@huawei.com>
Link: https://lore.kernel.org/r/20221122085046.21689-1-guozihua@huawei.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-mxc_v2.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-mxc_v2.c b/drivers/rtc/rtc-mxc_v2.c
index 5e0383401629..f6d2ad91ff7a 100644
--- a/drivers/rtc/rtc-mxc_v2.c
+++ b/drivers/rtc/rtc-mxc_v2.c
@@ -336,8 +336,10 @@ static int mxc_rtc_probe(struct platform_device *pdev)
 	}
 
 	pdata->rtc = devm_rtc_allocate_device(&pdev->dev);
-	if (IS_ERR(pdata->rtc))
+	if (IS_ERR(pdata->rtc)) {
+		clk_disable_unprepare(pdata->clk);
 		return PTR_ERR(pdata->rtc);
+	}
 
 	pdata->rtc->ops = &mxc_rtc_ops;
 	pdata->rtc->range_max = U32_MAX;
-- 
2.35.1



