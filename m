Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 670F33C4E45
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244543AbhGLHRj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:17:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:48022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243698AbhGLHRA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:17:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9728F61351;
        Mon, 12 Jul 2021 07:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074040;
        bh=xLYV4apqV4LLWjiyNx9glDFt4ET/31YO6roVMfISxW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X9nipJatXPEmTXWITQs5cOomWhWq6w1JVSdwvcxlkb8cDI90LkQ9bKb7yxm+Yp9sG
         yWsREH9f78hf/5D3gyHYdJ1UYv0QZ/2OTdc47LYlDcw1ilWN2B/f5ptG15REj8Gu+0
         yplqyzO0XSQABUa0/3unZBm9u2Tu6ND1LLJJCo8A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 401/700] ath10k: go to path err_unsupported when chip id is not supported
Date:   Mon, 12 Jul 2021 08:08:04 +0200
Message-Id: <20210712061019.049808061@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
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
index e7fde635e0ee..463cf3f8f8a5 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -3701,7 +3701,7 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 		goto err_unsupported;
 
 	if (!ath10k_pci_chip_is_supported(pdev->device, bus_params.chip_id))
-		goto err_free_irq;
+		goto err_unsupported;
 
 	ret = ath10k_core_register(ar, &bus_params);
 	if (ret) {
-- 
2.30.2



