Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 245E54012A6
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 03:20:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239053AbhIFBVv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 21:21:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:38430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238771AbhIFBVj (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Sep 2021 21:21:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8E16610A2;
        Mon,  6 Sep 2021 01:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630891235;
        bh=wGZM8zog7rThUPN2nV/u4oz3dn8HYQj1lojGGQuQW1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UiW6rhQw/nP6NeQ2VZa9g5nUcvpq5lXmevdIrb3Cdxf9w/7QDZar6Lnh87TUwoSis
         9H/FnsB2vkoYU0zWKs7/QJy9LEfC7Sw20k7AV9GMcVhhPiNI4Oby8dhTJK8JPJm4Of
         jqPI7wca6HdnmtLPD9kFt0JZHcUOQiGZ+MYpZXyLhQJK0FbimBK8lbGMDQVIAIIU/n
         NaA36jI+WWn6hShIbpPTmyFlsinxfsJlE/HS38+YexG1YRlEY+CaeBeWC8R9afJ/K6
         obTx07HiffAvC7tq0j04k7yYY1Dttj/HRdmOEbHQSX4GOcXBzxoX8snkxBH8CJ5FB6
         sdCMRalBt2Xlg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kai Ye <yekai13@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 35/47] crypto: hisilicon/sec - fix the abnormal exiting process
Date:   Sun,  5 Sep 2021 21:19:39 -0400
Message-Id: <20210906011951.928679-35-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210906011951.928679-1-sashal@kernel.org>
References: <20210906011951.928679-1-sashal@kernel.org>
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
index 490db7bccf61..8addbd7a3339 100644
--- a/drivers/crypto/hisilicon/sec2/sec_main.c
+++ b/drivers/crypto/hisilicon/sec2/sec_main.c
@@ -984,7 +984,8 @@ static int sec_probe(struct pci_dev *pdev, const struct pci_device_id *id)
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

