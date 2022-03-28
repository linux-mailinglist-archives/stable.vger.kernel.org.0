Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD9C4E9354
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 13:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234256AbiC1LVn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 07:21:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240731AbiC1LV3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 07:21:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 842AF56224;
        Mon, 28 Mar 2022 04:18:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0F415B8104D;
        Mon, 28 Mar 2022 11:18:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E707FC340ED;
        Mon, 28 Mar 2022 11:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648466334;
        bh=KL2U+DdtwFetDLdywa1BvKB0ub14yiL29O6JG2SZpkM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QB+LqtuXiIejX/CPG2WgoNxeB699oEp1GwEVqFJSElnSW+ZHjmz1Bp3b5bl2l6HA+
         TwsrdBSz6zZvw+XJN7wYfVquVCA/6/C6zYflTXq4QjkfQ06pp3eWU43g84CYhOyG6V
         GsMSBknwaycnQ5nAtC7RbMweCJDzynt3orki07v90mB8k6lyQaPc/zOwww23dwIEUr
         mDfQBUqLmbSai9+wfSCkRIVeAKgGs+mJi96NwFJpgffC3tdzmju+F/cpL6g3x9o48I
         RRD+vxfRH66hS39cOAsZEtoo6IQRM/k97MRhCOTHersAp1/pI09XbdBsA2ZJxee367
         GWtVk2/MaC7DA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kai Ye <yekai13@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, liulongfang@huawei.com,
        davem@davemloft.net, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 13/43] crypto: hisilicon/sec - not need to enable sm4 extra mode at HW V3
Date:   Mon, 28 Mar 2022 07:17:57 -0400
Message-Id: <20220328111828.1554086-13-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220328111828.1554086-1-sashal@kernel.org>
References: <20220328111828.1554086-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Kai Ye <yekai13@huawei.com>

[ Upstream commit f8a2652826444d13181061840b96a5d975d5b6c6 ]

It is not need to enable sm4 extra mode in at HW V3. Here is fix it.

Signed-off-by: Kai Ye <yekai13@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/sec2/sec_main.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
index 26d3ab1d308b..89d4cc767d36 100644
--- a/drivers/crypto/hisilicon/sec2/sec_main.c
+++ b/drivers/crypto/hisilicon/sec2/sec_main.c
@@ -443,9 +443,11 @@ static int sec_engine_init(struct hisi_qm *qm)
 
 	writel(SEC_SAA_ENABLE, qm->io_base + SEC_SAA_EN_REG);
 
-	/* Enable sm4 extra mode, as ctr/ecb */
-	writel_relaxed(SEC_BD_ERR_CHK_EN0,
-		       qm->io_base + SEC_BD_ERR_CHK_EN_REG0);
+	/* HW V2 enable sm4 extra mode, as ctr/ecb */
+	if (qm->ver < QM_HW_V3)
+		writel_relaxed(SEC_BD_ERR_CHK_EN0,
+			       qm->io_base + SEC_BD_ERR_CHK_EN_REG0);
+
 	/* Enable sm4 xts mode multiple iv */
 	writel_relaxed(SEC_BD_ERR_CHK_EN1,
 		       qm->io_base + SEC_BD_ERR_CHK_EN_REG1);
-- 
2.34.1

