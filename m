Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 026A1499115
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:09:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352014AbiAXUJF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:09:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376679AbiAXUDd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:03:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 055D2C08E6DC;
        Mon, 24 Jan 2022 11:29:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7B28B81238;
        Mon, 24 Jan 2022 19:29:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4820C340E5;
        Mon, 24 Jan 2022 19:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052581;
        bh=J8duQaotuAl4FUUuOIClzvWBYiFdiRFM92W/pHtQcoo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SJmM+oGcqZ0BG+Ym7hvZlF3eRAAxm9HG+6F+1DxrFKAFbLab2lljYwjPoWhzc6PPv
         pRExZGqps2tmTp3tzPNZ15RUAluIzj5v8PvqEA15qZwldYbCU5DzHu6PtZwmvUFP9I
         gQVUznnK8H6FsxYsebs5yAhAWd5zp/iErJnG5iAQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 107/320] Bluetooth: hci_bcm: Check for error irq
Date:   Mon, 24 Jan 2022 19:41:31 +0100
Message-Id: <20220124183957.360997824@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit b38cd3b42fba66cc538edb9cf77e07881f43f8e2 ]

For the possible failure of the platform_get_irq(), the returned irq
could be error number and will finally cause the failure of the
request_irq().
Consider that platform_get_irq() can now in certain cases return
-EPROBE_DEFER, and the consequences of letting request_irq() effectively
convert that into -EINVAL, even at probe time rather than later on.
So it might be better to check just now.

Fixes: 0395ffc1ee05 ("Bluetooth: hci_bcm: Add PM for BCM devices")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_bcm.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/hci_bcm.c b/drivers/bluetooth/hci_bcm.c
index 94ed734c1d7eb..c6bb380806f9b 100644
--- a/drivers/bluetooth/hci_bcm.c
+++ b/drivers/bluetooth/hci_bcm.c
@@ -1127,7 +1127,12 @@ static int bcm_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	dev->dev = &pdev->dev;
-	dev->irq = platform_get_irq(pdev, 0);
+
+	ret = platform_get_irq(pdev, 0);
+	if (ret < 0)
+		return ret;
+
+	dev->irq = ret;
 
 	if (has_acpi_companion(&pdev->dev)) {
 		ret = bcm_acpi_probe(dev);
-- 
2.34.1



