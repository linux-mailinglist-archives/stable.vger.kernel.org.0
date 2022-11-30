Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53AA263DF9F
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:49:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231453AbiK3StE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:49:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231433AbiK3Ssu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:48:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 946084908C
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:48:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B47FA61D56
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:48:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6D4DC433D6;
        Wed, 30 Nov 2022 18:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834126;
        bh=o9uSvNsAIfzXiZca4keuSiJpQj8TmnCSVSIxhnQDkdk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b3E4E9cZItcPe3tjM6oPWPr8O6zQsCdVQSgKObQKocC6Ptr85EtV6ooZggpizwINS
         ndLcnY4od/kMytO4cbOhRR9OZenRLRP/eRWBszAHM+IwpRmKRWbML4OOYNolQwwPu8
         QcI5ii2MPcvpelpP/fEXcMRtnRm9ZOoPUOoePJbY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wei Yongjun <weiyongjun1@huawei.com>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 112/289] net: phy: at803x: fix error return code in at803x_probe()
Date:   Wed, 30 Nov 2022 19:21:37 +0100
Message-Id: <20221130180546.679475495@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
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

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit 1f0dd412e34e177621769866bef347f0b22364df ]

Fix to return a negative error code from the ccr read error handling
case instead of 0, as done elsewhere in this function.

Fixes: 3265f4218878 ("net: phy: at803x: add fiber support")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20221118103635.254256-1-weiyongjun@huaweicloud.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/at803x.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 59fe356942b5..249e7ee4a2bb 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -862,8 +862,10 @@ static int at803x_probe(struct phy_device *phydev)
 			.wolopts = 0,
 		};
 
-		if (ccr < 0)
+		if (ccr < 0) {
+			ret = ccr;
 			goto err;
+		}
 		mode_cfg = ccr & AT803X_MODE_CFG_MASK;
 
 		switch (mode_cfg) {
-- 
2.35.1



