Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 126A0657FA1
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:07:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233007AbiL1QH3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:07:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234329AbiL1QHH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:07:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32CF514D33
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:06:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E1ED5B8171C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:06:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42161C433D2;
        Wed, 28 Dec 2022 16:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243613;
        bh=VGi6d0KV4g/yo2f7z6fe2QaLPXyZ9kc+nqHCO4xi3aY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CJvSrGmGF1NhgwbKcGK7y7l7sfVuYgF1CCuYyBVXpmaYAnPpa2qNINsnp2oouKQwE
         6Ta4QUxM4tKw5WZ6ir/6ef+XPo2TJjROIhbFl6Ozct0TT7qNpZa0Z0Ge3I5cVNAVso
         AzYr9qzWJ4ZmVIoje1KSy0rgQsWXJVgNlEtTuaLE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Weili Qian <qianweili@huawei.com>,
        Yang Shen <shenyang39@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0557/1073] crypto: hisilicon/qm - fix missing destroy qp_idr
Date:   Wed, 28 Dec 2022 15:35:45 +0100
Message-Id: <20221228144343.184880055@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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
Stable-dep-of: ee1537fe3dd8 ("crypto: hisilicon/qm - re-enable communicate interrupt before notifying PF")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/qm.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 9fa2efe60153..bdb7d5ba23b8 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -6143,8 +6143,8 @@ static int hisi_qm_memory_init(struct hisi_qm *qm)
 					 GFP_ATOMIC);
 	dev_dbg(dev, "allocate qm dma buf size=%zx)\n", qm->qdma.size);
 	if (!qm->qdma.va) {
-		ret =  -ENOMEM;
-		goto err_alloc_qdma;
+		ret = -ENOMEM;
+		goto err_destroy_idr;
 	}
 
 	QM_INIT_BUF(qm, eqe, QM_EQ_DEPTH);
@@ -6160,7 +6160,8 @@ static int hisi_qm_memory_init(struct hisi_qm *qm)
 
 err_alloc_qp_array:
 	dma_free_coherent(dev, qm->qdma.size, qm->qdma.va, qm->qdma.dma);
-err_alloc_qdma:
+err_destroy_idr:
+	idr_destroy(&qm->qp_idr);
 	kfree(qm->factor);
 
 	return ret;
-- 
2.35.1



