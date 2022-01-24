Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE617499985
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:45:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1455581AbiAXVfl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:35:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1453266AbiAXV3t (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:29:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9328CC0A8935;
        Mon, 24 Jan 2022 12:19:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3363B61496;
        Mon, 24 Jan 2022 20:19:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17B64C340E5;
        Mon, 24 Jan 2022 20:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055576;
        bh=wstrC+IV/cNIbO9MQU9ClBIKDF2ZwJOJuBP3G7iJnG8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K2nBXJ9wooprTgFhDQwc5MS7pfdYpH7fstc9psAAN5YQUAbXAI/DM+fvkwzuUMrM8
         Le6R7jajYKeMmxJEk4kikx3SNzbpnfcMuhHnFPMGteAw/vJiKeS8E7ZsI9XLPoWGzj
         t/j37lqdgu3Ya0dr+lrlpuBzPmMNKBaTO9W+N+2A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark-yw Chen <mark-yw.chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 197/846] Bluetooth: btmtksdio: fix resume failure
Date:   Mon, 24 Jan 2022 19:35:14 +0100
Message-Id: <20220124184107.737782288@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Wang <sean.wang@mediatek.com>

[ Upstream commit 561ae1d46a8ddcbc13162d5771f5ed6c8249e730 ]

btmtksdio have to rely on MMC_PM_KEEP_POWER in pm_flags to avoid that
SDIO power is being shut off during the device is in suspend. That fixes
the SDIO command fails to access the bus after the device is resumed.

Fixes: 7f3c563c575e7 ("Bluetooth: btmtksdio: Add runtime PM support to SDIO based Bluetooth")
Co-developed-by: Mark-yw Chen <mark-yw.chen@mediatek.com>
Signed-off-by: Mark-yw Chen <mark-yw.chen@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btmtksdio.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bluetooth/btmtksdio.c b/drivers/bluetooth/btmtksdio.c
index 9872ef18f9fea..1cbdeca1fdc4a 100644
--- a/drivers/bluetooth/btmtksdio.c
+++ b/drivers/bluetooth/btmtksdio.c
@@ -1042,6 +1042,8 @@ static int btmtksdio_runtime_suspend(struct device *dev)
 	if (!bdev)
 		return 0;
 
+	sdio_set_host_pm_flags(func, MMC_PM_KEEP_POWER);
+
 	sdio_claim_host(bdev->func);
 
 	sdio_writel(bdev->func, C_FW_OWN_REQ_SET, MTK_REG_CHLPCR, &err);
-- 
2.34.1



