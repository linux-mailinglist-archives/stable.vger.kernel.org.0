Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBC032E4153
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:06:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439575AbgL1OLR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:11:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:44922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439222AbgL1OLA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:11:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF18D206D4;
        Mon, 28 Dec 2020 14:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164645;
        bh=djoh+KZa49Y8MAq1v+kB1czG/Imo+5uqgRP8l3YTr0s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uRa8nzuQwF87TfpP6uGUPBjc7qeWisTX/J3TljTq70y1QtCeELvMIb1lxRJbx53Uf
         YqCbAvIH/atJD/KwHAQyoGf1MCeqz0SWsfX8nDsY8HE1yi8Ygtu4fLQuLo/DukYk6T
         Ku1e9O6n03efHktmthDXmnCWQ6Smb4Z0lZvfyOHM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 217/717] serial: 8250-mtk: Fix reference leak in mtk8250_probe
Date:   Mon, 28 Dec 2020 13:43:35 +0100
Message-Id: <20201228125031.373196857@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit 6e4e636e0e3e0b5deffc5e233adcb2cd4e68f2d0 ]

The pm_runtime_enable will increase power disable depth.
Thus a pairing decrement is needed on the error handling
path to keep it balanced according to context.

Fixes: e32a83c70cf98 ("serial: 8250-mtk: modify mtk uart power and clock management")
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Link: https://lore.kernel.org/r/20201119141126.168850-1-zhangqilong3@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_mtk.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_mtk.c b/drivers/tty/serial/8250/8250_mtk.c
index fa876e2c13e5d..f7d3023f860f0 100644
--- a/drivers/tty/serial/8250/8250_mtk.c
+++ b/drivers/tty/serial/8250/8250_mtk.c
@@ -572,15 +572,22 @@ static int mtk8250_probe(struct platform_device *pdev)
 	pm_runtime_enable(&pdev->dev);
 	err = mtk8250_runtime_resume(&pdev->dev);
 	if (err)
-		return err;
+		goto err_pm_disable;
 
 	data->line = serial8250_register_8250_port(&uart);
-	if (data->line < 0)
-		return data->line;
+	if (data->line < 0) {
+		err = data->line;
+		goto err_pm_disable;
+	}
 
 	data->rx_wakeup_irq = platform_get_irq_optional(pdev, 1);
 
 	return 0;
+
+err_pm_disable:
+	pm_runtime_disable(&pdev->dev);
+
+	return err;
 }
 
 static int mtk8250_remove(struct platform_device *pdev)
-- 
2.27.0



