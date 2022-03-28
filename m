Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9EE04E939A
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 13:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240888AbiC1LYe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 07:24:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241252AbiC1LXZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 07:23:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F20F58E64;
        Mon, 28 Mar 2022 04:20:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C5F261195;
        Mon, 28 Mar 2022 11:20:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAB5CC340ED;
        Mon, 28 Mar 2022 11:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648466432;
        bh=4iVXIPkT3ePxCznX2ZMKrI8so8HKS+0aauaqn24SB9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VFPXhVb1KmN/pdrkiuTevoltK53hvTywgQL0oGTx5oR41vd8+kCVUShNdb6/mVErr
         if8waa1jhCMuTb2eIYijiB+2sp2mz+xfkPLk0gduFRQs7jGdGzMz0bRWwG6z+vTYc7
         tD5/i6v+qOw4SSCuNBuUpb7AKTkA2TFUD/mVCBwCOgyaj39RWn+2/h3D5lPqE3yaYq
         DOJeIzM3AaS+xCEISMcUdbunljoyPX4lKN8fGUvooHhPjvFHeYj5YV4tjUv0PDTVIV
         MJSdmeW4MB/D9vQGe9Kq4Kxgfvl97gRsuKzMZJDl0XHM8tI9otE+7AYTMeAjKKCkeh
         MvfBBuIrhd33Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kai Ye <yekai13@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, liulongfang@huawei.com,
        davem@davemloft.net, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 12/35] crypto: hisilicon/sec - not need to enable sm4 extra mode at HW V3
Date:   Mon, 28 Mar 2022 07:19:48 -0400
Message-Id: <20220328112011.1555169-12-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220328112011.1555169-1-sashal@kernel.org>
References: <20220328112011.1555169-1-sashal@kernel.org>
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
index 90551bf38b52..03d239cfdf8c 100644
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

