Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8B7E531BF0
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240154AbiEWRS4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:18:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239994AbiEWRPE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:15:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE5BCFD2F;
        Mon, 23 May 2022 10:12:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF141614E9;
        Mon, 23 May 2022 17:11:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8129C385A9;
        Mon, 23 May 2022 17:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653325908;
        bh=EWPceXRr9n6C5+usxhB70r1p1I7AsLGL6Q2JN/tDL8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e1nXA3QxBwrOfVuwX6aGm50A9DN5Yrwi3ZtIYjeVJ4mpbfDS/iYkEbBasg0d3w8+H
         rqKJhlycpodnjm/9O7Xm/puy3R3Bqxq3ZKETdasG6vyE0E2lx2xFWjt8h0swO319k1
         RqdEBADeOqep7+rcDx8YPFdaozGnbz75s66xtJRk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheng Yongjun <zhengyongjun3@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 08/68] crypto: stm32 - fix reference leak in stm32_crc_remove
Date:   Mon, 23 May 2022 19:04:35 +0200
Message-Id: <20220523165803.930545313@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165802.500642349@linuxfoundation.org>
References: <20220523165802.500642349@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheng Yongjun <zhengyongjun3@huawei.com>

[ Upstream commit e9a36feecee0ee5845f2e0656f50f9942dd0bed3 ]

pm_runtime_get_sync() will increment pm usage counter even it
failed. Forgetting to call pm_runtime_put_noidle will result
in reference leak in stm32_crc_remove, so we should fix it.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/stm32/stm32-crc32.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/stm32/stm32-crc32.c b/drivers/crypto/stm32/stm32-crc32.c
index fb640e0ea614..2ecc970f5cae 100644
--- a/drivers/crypto/stm32/stm32-crc32.c
+++ b/drivers/crypto/stm32/stm32-crc32.c
@@ -332,8 +332,10 @@ static int stm32_crc_remove(struct platform_device *pdev)
 	struct stm32_crc *crc = platform_get_drvdata(pdev);
 	int ret = pm_runtime_get_sync(crc->dev);
 
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_noidle(crc->dev);
 		return ret;
+	}
 
 	spin_lock(&crc_list.lock);
 	list_del(&crc->list);
-- 
2.35.1



