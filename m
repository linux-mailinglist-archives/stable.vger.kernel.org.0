Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CCDD6517B2
	for <lists+stable@lfdr.de>; Tue, 20 Dec 2022 02:21:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbiLTBVE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 20:21:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbiLTBVB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 20:21:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93D36639E;
        Mon, 19 Dec 2022 17:20:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A661B810FA;
        Tue, 20 Dec 2022 01:20:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A42DC433D2;
        Tue, 20 Dec 2022 01:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671499255;
        bh=ZkixGrRTxImmU34BC5VYjzY5BB/QJrVjCRSK6oVAM/w=;
        h=From:To:Cc:Subject:Date:From;
        b=nDPbOQK45vxLnVShtpG/8sO7wh4o3VAAt34ny8DqZFCxjUHe88RGkirp0P154A2Cs
         mxzaAS1FQXDJQXFbXy7CWNTsXZdBm2AMcI0qiipC36/5A5wVIf+XAAcpoOAqh9/GU7
         /XxHuMKe4XNirzfldqPq0NSfqef8awb43L7s5xom0VpaDKiJ/r3ZfE22fa5qdRYmn4
         Qr7CeBOMlI+G8abTA1zuuuof/UEwJMt4DazQnNX7gwZg2pEEXOxJ6+DXr9+lsApZNL
         Qo2ASR/LV7edEt3vsCEW9yOwz2ppIFgjUxMj9P3pGO+XxJIQopIHcZ97eQBDxFzKiI
         o5pqT+blUIiyw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhiqi Song <songzhiqi1@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, liulongfang@huawei.com,
        davem@davemloft.net, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 01/16] crypto: hisilicon/hpre - fix resource leak in remove process
Date:   Mon, 19 Dec 2022 20:20:38 -0500
Message-Id: <20221220012053.1222101-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhiqi Song <songzhiqi1@huawei.com>

[ Upstream commit 45e6319bd5f2154d8b8c9f1eaa4ac030ba0d330c ]

In hpre_remove(), when the disable operation of qm sriov failed,
the following logic should continue to be executed to release the
remaining resources that have been allocated, instead of returning
directly, otherwise there will be resource leakage.

Signed-off-by: Zhiqi Song <songzhiqi1@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/hpre/hpre_main.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index 471e5ca720f5..baf1faec7046 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -1437,18 +1437,12 @@ static int hpre_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 static void hpre_remove(struct pci_dev *pdev)
 {
 	struct hisi_qm *qm = pci_get_drvdata(pdev);
-	int ret;
 
 	hisi_qm_pm_uninit(qm);
 	hisi_qm_wait_task_finish(qm, &hpre_devices);
 	hisi_qm_alg_unregister(qm, &hpre_devices);
-	if (qm->fun_type == QM_HW_PF && qm->vfs_num) {
-		ret = hisi_qm_sriov_disable(pdev, true);
-		if (ret) {
-			pci_err(pdev, "Disable SRIOV fail!\n");
-			return;
-		}
-	}
+	if (qm->fun_type == QM_HW_PF && qm->vfs_num)
+		hisi_qm_sriov_disable(pdev, true);
 
 	hpre_debugfs_exit(qm);
 	hisi_qm_stop(qm, QM_NORMAL);
-- 
2.35.1

