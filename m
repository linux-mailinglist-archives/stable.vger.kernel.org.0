Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7DE965800B
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:13:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234521AbiL1QNT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:13:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234708AbiL1QMa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:12:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9A131A223
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:11:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9C6EDB817AC
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:10:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E94C1C433D2;
        Wed, 28 Dec 2022 16:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243858;
        bh=CEFHAZI9IQgGa18yT9NV81LV/2qCI8eTtWGWC/jGKVM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q4z6N/G5J4Jdte3Cto3lax70w4CWPFyHT9AiDAMZB9CehjodU4ZXa/HXWW71oDNJm
         XUM469xVsj7ZKH2X2DJsEE9Fe6wV9CvWxIjrezDd4Wvde+1givlz2jLUuGT7VT6x19
         uWXTfVvmN27A45is6gfTlxhy2xQO5I6oDN2Ld7Hs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Xiongfeng Wang <wangxiongfeng2@huawei.com>,
        Weili Qian <qianweili@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0600/1073] crypto: hisilicon/qm - add missing pci_dev_put() in q_num_set()
Date:   Wed, 28 Dec 2022 15:36:28 +0100
Message-Id: <20221228144344.342939670@linuxfoundation.org>
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
index 851c962ba473..ce0c3ed67a5f 100644
--- a/include/linux/hisi_acc_qm.h
+++ b/include/linux/hisi_acc_qm.h
@@ -400,14 +400,14 @@ struct hisi_qp {
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
@@ -417,6 +417,8 @@ static inline int q_num_set(const char *val, const struct kernel_param *kp,
 			q_num = QM_QNUM_V1;
 		else
 			q_num = QM_QNUM_V2;
+
+		pci_dev_put(pdev);
 	}
 
 	ret = kstrtou32(val, 10, &n);
-- 
2.35.1



