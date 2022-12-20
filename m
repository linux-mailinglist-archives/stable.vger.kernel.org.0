Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85130651824
	for <lists+stable@lfdr.de>; Tue, 20 Dec 2022 02:25:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233238AbiLTBZ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 20:25:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232633AbiLTBXP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 20:23:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EBD5F023;
        Mon, 19 Dec 2022 17:22:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 18056B80F9B;
        Tue, 20 Dec 2022 01:22:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02D84C433EF;
        Tue, 20 Dec 2022 01:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671499321;
        bh=2PV6rZ6kwN1VEo166SUCdr4uGIWFt0H3y7Ea7llfnzY=;
        h=From:To:Cc:Subject:Date:From;
        b=FASoHPC2RsY55LJ+2ZE4YUI/KWKTe6e47a6l26M0pjnSmnOfYkbgGsrCmy0clU5SF
         g+KM7J6YzkGqc7qvoyHnY0smzekMnZMZpz4xAc5OgV382VJwjGd8Waghp2ct48XqY+
         SfTICReWng7V3Z+EDGYy4JpQSUTY88STqNk62TqOB5WJDNjF4DA2CXBChNJ+MO70GK
         9RG+BdLxZsBknQS2BdotF/meeQlevQBE3S+LVtZVNurze7O8YnVV4wrE+iIfY0ftA5
         oBw+ZEA5JsfDdczAvufFey651YZpa7Fo2b+HikZDgTXbkJQ9BpEBpoLDoVsbN2dAJq
         bkT+8thiUpNIQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhiqi Song <songzhiqi1@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, liulongfang@huawei.com,
        davem@davemloft.net, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 1/9] crypto: hisilicon/hpre - fix resource leak in remove process
Date:   Mon, 19 Dec 2022 20:21:51 -0500
Message-Id: <20221220012159.1222517-1-sashal@kernel.org>
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
index 65a641396c07..edc61e4105f3 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -1143,18 +1143,12 @@ static int hpre_probe(struct pci_dev *pdev, const struct pci_device_id *id)
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

