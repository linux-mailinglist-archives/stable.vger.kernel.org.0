Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C30E40908B
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243235AbhIMNxr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:53:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:36594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243598AbhIMNvp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:51:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C94F617E5;
        Mon, 13 Sep 2021 13:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540061;
        bh=RVvqkOD6e+5BgfIzLEczbyRZYoL2Wp6cZwFgx8spkZc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1CkkBG6ahuytNudUsk755fMJDGkOx7JRMTHDrUhbFqkMfij1vPJdNeTkfBCm/Gh+j
         0C7YAZNn/MtkikwQaYFTfup6fav1cCGtSAJJXAdx2LTbH50m2drvfuavroCcNPkkCt
         do5Q/Uz5W/c1RhjiS6ABiMhJHnSGUxsQr6OH9zao=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kai Ye <yekai13@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 035/300] crypto: hisilicon/sec - fix the abnormal exiting process
Date:   Mon, 13 Sep 2021 15:11:36 +0200
Message-Id: <20210913131110.508437650@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai Ye <yekai13@huawei.com>

[ Upstream commit 90367a027a22c3a9ca8b8bac15df34d9e859fc11 ]

Because the algs registration process has added a judgment.
So need to add the judgment for the abnormal exiting process.

Signed-off-by: Kai Ye <yekai13@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/sec2/sec_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
index 6f0062d4408c..e682e2a77b70 100644
--- a/drivers/crypto/hisilicon/sec2/sec_main.c
+++ b/drivers/crypto/hisilicon/sec2/sec_main.c
@@ -921,7 +921,8 @@ static int sec_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	return 0;
 
 err_alg_unregister:
-	hisi_qm_alg_unregister(qm, &sec_devices);
+	if (qm->qp_num >= ctx_q_num)
+		hisi_qm_alg_unregister(qm, &sec_devices);
 err_qm_stop:
 	sec_debugfs_exit(qm);
 	hisi_qm_stop(qm, QM_NORMAL);
-- 
2.30.2



