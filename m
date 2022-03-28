Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A98F24E9411
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 13:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241076AbiC1L0I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 07:26:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241689AbiC1LYG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 07:24:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F5EF55773;
        Mon, 28 Mar 2022 04:21:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F9C4611B7;
        Mon, 28 Mar 2022 11:21:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD38AC340ED;
        Mon, 28 Mar 2022 11:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648466498;
        bh=Gyix2CQ34Gq69PxjvLdjwTq82hEB1eQcP6V6TXWjEEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S2xx9DIigIY+gyIkw5yMksleNUM2JW+9P9RrYX62JzMxdmG9tgbwirD+MeOkKUQAy
         3MXQeLDAu7Ps+zsq33I1CA813awznGmAyFQscz3P322ZNN8hkjDZR7UHVL0Pimwvcl
         wHqb8yMnKuQUXX1E9llK1PSU7FITEQ7+nig6pFEU+FMQW0tdNso2IwnTawTQcLSi78
         lU3UDPcMZQNEfaDUqzmnBb9NDrVSN1J4SHM+t4EbVbCw5c/NON7Tnkpy6KALU0fEZO
         AZIoLtVf7bi1gbcx4BUYsAQslPmzfaUBolNECoQF+UkYknf4tkxuE0V7AplCdkwmR+
         qIO3IZlWGFNbA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kai Ye <yekai13@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, wangzhou1@hisilicon.com,
        davem@davemloft.net, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 03/29] crypto: hisilicon/qm - cleanup warning in qm_vf_read_qos
Date:   Mon, 28 Mar 2022 07:21:05 -0400
Message-Id: <20220328112132.1555683-3-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220328112132.1555683-1-sashal@kernel.org>
References: <20220328112132.1555683-1-sashal@kernel.org>
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

[ Upstream commit 05b3bade290d6c940701f97f3233c07cfe27205d ]

The kernel test rebot report this warning: Uninitialized variable: ret.
The code flow may return value of ret directly. This value is an
uninitialized variable, here is fix it.

Signed-off-by: Kai Ye <yekai13@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/qm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index ff1122153fbe..b616d2d8e773 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -4107,7 +4107,7 @@ static void qm_vf_get_qos(struct hisi_qm *qm, u32 fun_num)
 static int qm_vf_read_qos(struct hisi_qm *qm)
 {
 	int cnt = 0;
-	int ret;
+	int ret = -EINVAL;
 
 	/* reset mailbox qos val */
 	qm->mb_qos = 0;
-- 
2.34.1

