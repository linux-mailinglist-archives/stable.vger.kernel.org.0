Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B83A52E3C93
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:05:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437366AbgL1OE3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:04:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:38394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437361AbgL1OE3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:04:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C0032063A;
        Mon, 28 Dec 2020 14:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164253;
        bh=/2JmIDdhAKmZwE2B5eV/D4avkZ+BWKt4Rl0Qhwe9fyc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ujcyqzVoiCn4IsHMOBafsnLtEeWcrGJ91OwWPlOcZp8YICYFip9eHorjXYsxIQkGC
         6I3WEncPFoVNGzdPtGFar7sc3dxY/0uATkleD0aai2+RfUovjpbtovzDGgyUsa93za
         WmQvBvL/QrHBSmyrMV/PWeQN1x+5Fe1BZlKZ5ZQo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 075/717] spi: stm32-qspi: fix reference leak in stm32 qspi operations
Date:   Mon, 28 Dec 2020 13:41:13 +0100
Message-Id: <20201228125024.589079240@linuxfoundation.org>
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

[ Upstream commit 88e1419b5ee30cc50e0c4d5265bdee1ba04af539 ]

pm_runtime_get_sync will increment pm usage counter even it
failed. Forgetting to pm_runtime_put_noidle will result in
reference leak in two callers(stm32_qspi_exec_op and
stm32_qspi_setup), so we should fix it.

Fixes: 9d282c17b023a ("spi: stm32-qspi: Add pm_runtime support")
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Reviewed-by: Patrice Chotard <patrice.chotard@st.com>
Link: https://lore.kernel.org/r/20201106015357.141235-1-zhangqilong3@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-stm32-qspi.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-stm32-qspi.c b/drivers/spi/spi-stm32-qspi.c
index a900962b4336e..947e6b9dc9f4d 100644
--- a/drivers/spi/spi-stm32-qspi.c
+++ b/drivers/spi/spi-stm32-qspi.c
@@ -434,8 +434,10 @@ static int stm32_qspi_exec_op(struct spi_mem *mem, const struct spi_mem_op *op)
 	int ret;
 
 	ret = pm_runtime_get_sync(qspi->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_noidle(qspi->dev);
 		return ret;
+	}
 
 	mutex_lock(&qspi->lock);
 	ret = stm32_qspi_send(mem, op);
@@ -462,8 +464,10 @@ static int stm32_qspi_setup(struct spi_device *spi)
 		return -EINVAL;
 
 	ret = pm_runtime_get_sync(qspi->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_noidle(qspi->dev);
 		return ret;
+	}
 
 	presc = DIV_ROUND_UP(qspi->clk_rate, spi->max_speed_hz) - 1;
 
-- 
2.27.0



