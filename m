Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2B545495FD
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353556AbiFMMar (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:30:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357101AbiFMM25 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:28:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 206E510C7;
        Mon, 13 Jun 2022 04:06:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AABCCB80EA7;
        Mon, 13 Jun 2022 11:06:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22CF9C34114;
        Mon, 13 Jun 2022 11:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655118361;
        bh=EM1LAeNCmBB5WOk5c1ZGBP6c1GWlwjUJxsOykObPuC0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GKpND4JrjouwuYrmfjfZxQCow5vTnWlDSdgTLcZiPlgseBVC46oEfdF6QnXvc/C3g
         NNt1YO7z0nGgfLPPZHswaWkUf5BiAvHJWQqFf1Jl/bSMRtuMDueT3gYauqLr90WXKL
         eIVwykpz+cDjy1+jp54JNZlev1Emf53YiF8tdEZ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 031/172] rtc: mt6397: check return value after calling platform_get_resource()
Date:   Mon, 13 Jun 2022 12:09:51 +0200
Message-Id: <20220613094857.890770760@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094850.166931805@linuxfoundation.org>
References: <20220613094850.166931805@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit d3b43eb505bffb8e4cdf6800c15660c001553fe6 ]

It will cause null-ptr-deref if platform_get_resource() returns NULL,
we need check the return value.

Fixes: fc2979118f3f ("rtc: mediatek: Add MT6397 RTC driver")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20220505125043.1594771-1-yangyingliang@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-mt6397.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/rtc/rtc-mt6397.c b/drivers/rtc/rtc-mt6397.c
index 1894aded4c85..acfcb378767d 100644
--- a/drivers/rtc/rtc-mt6397.c
+++ b/drivers/rtc/rtc-mt6397.c
@@ -269,6 +269,8 @@ static int mtk_rtc_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -EINVAL;
 	rtc->addr_base = res->start;
 
 	rtc->data = of_device_get_match_data(&pdev->dev);
-- 
2.35.1



