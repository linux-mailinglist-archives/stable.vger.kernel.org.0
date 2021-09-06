Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D095E40132F
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 03:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239223AbhIFBY2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 21:24:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:38636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239323AbhIFBXY (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Sep 2021 21:23:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6237E610CF;
        Mon,  6 Sep 2021 01:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630891298;
        bh=RVvqkOD6e+5BgfIzLEczbyRZYoL2Wp6cZwFgx8spkZc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lfvoJi+8XQQYOuAE0tcedYToXskBeGaQiCVZrEBmEqnZ0cUub2fuJM3VJSCgIomEO
         KsmEuv7kpxkgsGKPcK7H5YOXr9syfhxI568C43LUd4r5F7P4nOTobGDzxDBmUsp+GH
         Zh7zUFmdUu6+tMgzOu635HqUq1XiTONEPUPK7OtBxXFadmNxGxshFgqvL/8taq2I9E
         JTBmUxZur/ylEs/JbJOI8hq5fFbxBUkE71oG85iXLMza2BmdcSxqlVDv7vWpYMuC/z
         FDN6CmevSUi0G/ROBb1RuYuyV4SKXC3TzoGB23y0PRz8pIrwI/5Ysl53DerPyX7VqK
         URhbi2UqhYi9w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kai Ye <yekai13@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 35/46] crypto: hisilicon/sec - fix the abnormal exiting process
Date:   Sun,  5 Sep 2021 21:20:40 -0400
Message-Id: <20210906012052.929174-35-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210906012052.929174-1-sashal@kernel.org>
References: <20210906012052.929174-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

