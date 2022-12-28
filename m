Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC682658089
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:18:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234605AbiL1QSG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:18:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234731AbiL1QRV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:17:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C7E9237
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:15:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 37C306156C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:15:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DFA9C433EF;
        Wed, 28 Dec 2022 16:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244141;
        bh=Wfm1eR8kAdXO8PrZmf9DkjddDKM81VKUhPWVPqLMsT0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OxEYs+FZ9P1QOlqFBBuU54dYYnkUyco1++PjzIB91T+WJiM9yR5i6RTyBcBn9aj48
         v+YBKIa8D1HVP6A4knxIK0o2/Pf/To0ZuQ9SUj1wTn8EWQF54SjxPmyTHhQSmjZqPN
         b6E+itwFfu+pEtYkmRhkF/xOChD9x8haAMMpribc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Xiongfeng Wang <wangxiongfeng2@huawei.com>,
        Weili Qian <qianweili@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0618/1146] crypto: hisilicon/qm - add missing pci_dev_put() in q_num_set()
Date:   Wed, 28 Dec 2022 15:35:57 +0100
Message-Id: <20221228144346.956900966@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Xiongfeng Wang <wangxiongfeng2@huawei.com>

[ Upstream commit cc7710d0d4ebc6998f04035cde4f32c5ddbe9d7f ]

pci_get_device() will increase the reference count for the returned
pci_dev. We need to use pci_dev_put() to decrease the reference count
before q_num_set() returns.

Fixes: c8b4b477079d ("crypto: hisilicon - add HiSilicon HPRE accelerator")
Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Reviewed-by: Weili Qian <qianweili@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/hisi_acc_qm.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/hisi_acc_qm.h b/include/linux/hisi_acc_qm.h
index e230c7c46110..c3618255b150 100644
--- a/include/linux/hisi_acc_qm.h
+++ b/include/linux/hisi_acc_qm.h
@@ -384,14 +384,14 @@ struct hisi_qp {
 static inline int q_num_set(const char *val, const struct kernel_param *kp,
 			    unsigned int device)
 {
-	struct pci_dev *pdev = pci_get_device(PCI_VENDOR_ID_HUAWEI,
-					      device, NULL);
+	struct pci_dev *pdev;
 	u32 n, q_num;
 	int ret;
 
 	if (!val)
 		return -EINVAL;
 
+	pdev = pci_get_device(PCI_VENDOR_ID_HUAWEI, device, NULL);
 	if (!pdev) {
 		q_num = min_t(u32, QM_QNUM_V1, QM_QNUM_V2);
 		pr_info("No device found currently, suppose queue number is %u\n",
@@ -401,6 +401,8 @@ static inline int q_num_set(const char *val, const struct kernel_param *kp,
 			q_num = QM_QNUM_V1;
 		else
 			q_num = QM_QNUM_V2;
+
+		pci_dev_put(pdev);
 	}
 
 	ret = kstrtou32(val, 10, &n);
-- 
2.35.1



