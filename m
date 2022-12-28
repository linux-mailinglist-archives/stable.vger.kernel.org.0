Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB558657ACF
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:15:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233064AbiL1PPT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:15:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233122AbiL1PPJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:15:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF6D013E9D
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:15:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B5C16155C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:15:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ADE5C433EF;
        Wed, 28 Dec 2022 15:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240507;
        bh=pUFWZ5MW5W9wyBN/ICba+Rofm1EMP5FUmDntusvg0yE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AC07xze9EYxD3XaFwzb0aTC3B1jqzHzZVWRhE0QfuuVRrgmKWhxvYMkk1zbiINKVF
         JSaz6Q7YlFzmHqH7W1lc90Q7w9x7LHqmIE3w56TWLGMD1oNF6QuE6qr8IMSe4xuSxt
         E95AC12VwQGg7z/eKB/GoHpGnk8lQDX/SkvVhtIA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Weili Qian <qianweili@huawei.com>,
        Yang Shen <shenyang39@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 361/731] crypto: hisilicon/qm - fix missing destroy qp_idr
Date:   Wed, 28 Dec 2022 15:37:48 +0100
Message-Id: <20221228144307.025779269@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

From: Weili Qian <qianweili@huawei.com>

[ Upstream commit 116be08f6e4e385733d42360a33c3d883d2dd702 ]

In the function hisi_qm_memory_init(), if resource alloc fails after
idr_init, the initialized qp_idr needs to be destroyed.

Signed-off-by: Weili Qian <qianweili@huawei.com>
Signed-off-by: Yang Shen <shenyang39@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/qm.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index b8900a5dbf6e..fd89918abd19 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -5727,8 +5727,8 @@ static int hisi_qm_memory_init(struct hisi_qm *qm)
 					 GFP_ATOMIC);
 	dev_dbg(dev, "allocate qm dma buf size=%zx)\n", qm->qdma.size);
 	if (!qm->qdma.va) {
-		ret =  -ENOMEM;
-		goto err_alloc_qdma;
+		ret = -ENOMEM;
+		goto err_destroy_idr;
 	}
 
 	QM_INIT_BUF(qm, eqe, QM_EQ_DEPTH);
@@ -5744,7 +5744,8 @@ static int hisi_qm_memory_init(struct hisi_qm *qm)
 
 err_alloc_qp_array:
 	dma_free_coherent(dev, qm->qdma.size, qm->qdma.va, qm->qdma.dma);
-err_alloc_qdma:
+err_destroy_idr:
+	idr_destroy(&qm->qp_idr);
 	kfree(qm->factor);
 
 	return ret;
-- 
2.35.1



