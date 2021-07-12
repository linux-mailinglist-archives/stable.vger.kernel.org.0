Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C17513C4586
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 08:23:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234875AbhGLGZ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:25:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:39364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235392AbhGLGZA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:25:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C20CA61159;
        Mon, 12 Jul 2021 06:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626070929;
        bh=kC8rRiWDSQzBgx/MZgrecii21C2/p5Nk7ewqviNoMTI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sQkag+4q6f0ZlXpj6y3JoDRbtW5ty18hcC/3UJnMO9MNADfvOQ6kGxw6Nkl/qpp1Z
         P4F5/mYmPWc98NqwYDJLM+BUcikc0v+lmRHEtXcuGpi06dJ9YsczVWwWT6KqdQ7pRu
         v32UrKz6Je9ZB77suQrSzhWK/0+qxJ26wzY45adY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 200/348] ath10k: go to path err_unsupported when chip id is not supported
Date:   Mon, 12 Jul 2021 08:09:44 +0200
Message-Id: <20210712060727.971200685@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 9e88dd431d2345acdb7a549f3e88aaf4c2a307a1 ]

When chip id is not supported, it go to path err_unsupported
to print the error message.

Fixes: f8914a14623a ("ath10k: restore QCA9880-AR1A (v1) detection")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210522105822.1091848-2-yangyingliang@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index fd49d3419e79..53c791cc69a1 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -3663,7 +3663,7 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 		goto err_unsupported;
 
 	if (!ath10k_pci_chip_is_supported(pdev->device, bus_params.chip_id))
-		goto err_free_irq;
+		goto err_unsupported;
 
 	ret = ath10k_core_register(ar, &bus_params);
 	if (ret) {
-- 
2.30.2



