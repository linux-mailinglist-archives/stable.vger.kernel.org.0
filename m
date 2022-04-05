Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C47FF4F3954
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:46:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377349AbiDEL2q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:28:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349898AbiDEJv6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:51:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B95372E08C;
        Tue,  5 Apr 2022 02:50:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 56C1F61577;
        Tue,  5 Apr 2022 09:50:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E6D9C385A1;
        Tue,  5 Apr 2022 09:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152199;
        bh=4iVXIPkT3ePxCznX2ZMKrI8so8HKS+0aauaqn24SB9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yAuVgwe53/xlbGYREHj6tplk0C8A2Yh3HJXFgDQd6PTbbemsAe3CuK5HuGvC1tHG4
         V47jSh0V0liNk3j49+IE1djrr1ImaNIcxZMMuWVEpM/+h0O2n5ajR0rRb/GBArvZ07
         g4+9FZh834EWr/yNJJ5VkN7hnrLlN0AluFwyH7+Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kai Ye <yekai13@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 690/913] crypto: hisilicon/sec - not need to enable sm4 extra mode at HW V3
Date:   Tue,  5 Apr 2022 09:29:12 +0200
Message-Id: <20220405070400.517367958@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



