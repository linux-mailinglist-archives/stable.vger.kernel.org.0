Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 859AA2E640F
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:48:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392583AbgL1Pqw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:46:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:43304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391949AbgL1Nnr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:43:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 130082063A;
        Mon, 28 Dec 2020 13:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163011;
        bh=giG/b2Ryjn5XhGnC4faFFHVJIqA0wpdveaBebTx4g/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NoIVqvzRaKDnYGZgqoff4HSPagpSudrhmVpO/THzP8+7VatWeiS9A4bPTtIZgY8l8
         G5OPYlXvUedq9fsbazV4AwniORCuA9RXCBEqEvtwhcFkPDqSCZVjmHMLJrnmTt5uCp
         i9oZo0oLmsvrucGn+c21z6LuhEiBtYczaXwyxbco=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Alain Volmat <alain.volmat@st.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 108/453] spi: stm32: fix reference leak in stm32_spi_resume
Date:   Mon, 28 Dec 2020 13:45:44 +0100
Message-Id: <20201228124942.410245956@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit 900ccdcb79bb61471df1566a70b2b39687a628d5 ]

pm_runtime_get_sync will increment pm usage counter even it
failed. Forgetting to pm_runtime_put_noidle will result in
reference leak in stm32_spi_resume, so we should fix it.

Fixes: db96bf976a4fc ("spi: stm32: fixes suspend/resume management")
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Reviewed-by: Alain Volmat <alain.volmat@st.com>
Link: https://lore.kernel.org/r/20201106015217.140476-1-zhangqilong3@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-stm32.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-stm32.c b/drivers/spi/spi-stm32.c
index 9d8ceb63f7db1..ed20ad2950885 100644
--- a/drivers/spi/spi-stm32.c
+++ b/drivers/spi/spi-stm32.c
@@ -2055,6 +2055,7 @@ static int stm32_spi_resume(struct device *dev)
 
 	ret = pm_runtime_get_sync(dev);
 	if (ret < 0) {
+		pm_runtime_put_noidle(dev);
 		dev_err(dev, "Unable to power device:%d\n", ret);
 		return ret;
 	}
-- 
2.27.0



