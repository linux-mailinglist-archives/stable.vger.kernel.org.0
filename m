Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA1A4CF6B1
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:42:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238223AbiCGJmz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:42:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239671AbiCGJkI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:40:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D44474616;
        Mon,  7 Mar 2022 01:36:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E10B61185;
        Mon,  7 Mar 2022 09:35:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 790CEC340F4;
        Mon,  7 Mar 2022 09:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645739;
        bh=3Q6HfLvnyk20c5KteC9b+hLzCTbQ2st3hb44bFNMDzQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iExzYQpolPWYmeHG/Y2iqg+cTXQ1LrVDUvRXZ4ztpS/W349Ec5gvec+pmVewLPmEw
         ipSOVWcZJiPNfVEBN1C64VCWg49kn6V1ZriCXJkPgQCV6z1A6xYj72G5VWoLP8BiWY
         k4+g1Jk2h3u1S5Hs8UD9DGW+vTNqPpKE6LhONR7E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yongzhi Liu <lyz_cs@pku.edu.cn>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 021/262] dmaengine: shdma: Fix runtime PM imbalance on error
Date:   Mon,  7 Mar 2022 10:16:05 +0100
Message-Id: <20220307091702.972709358@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yongzhi Liu <lyz_cs@pku.edu.cn>

[ Upstream commit 455896c53d5b803733ddd84e1bf8a430644439b6 ]

pm_runtime_get_() increments the runtime PM usage counter even
when it returns an error code, thus a matching decrement is needed on
the error handling path to keep the counter balanced.

Signed-off-by: Yongzhi Liu <lyz_cs@pku.edu.cn>
Link: https://lore.kernel.org/r/1642311296-87020-1-git-send-email-lyz_cs@pku.edu.cn
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/sh/shdma-base.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/sh/shdma-base.c b/drivers/dma/sh/shdma-base.c
index 7f72b3f4cd1ae..19ac95c0098f0 100644
--- a/drivers/dma/sh/shdma-base.c
+++ b/drivers/dma/sh/shdma-base.c
@@ -115,8 +115,10 @@ static dma_cookie_t shdma_tx_submit(struct dma_async_tx_descriptor *tx)
 		ret = pm_runtime_get(schan->dev);
 
 		spin_unlock_irq(&schan->chan_lock);
-		if (ret < 0)
+		if (ret < 0) {
 			dev_err(schan->dev, "%s(): GET = %d\n", __func__, ret);
+			pm_runtime_put(schan->dev);
+		}
 
 		pm_runtime_barrier(schan->dev);
 
-- 
2.34.1



