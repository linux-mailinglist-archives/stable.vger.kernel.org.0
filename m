Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB5A11971D
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:31:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728188AbfLJVJd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:09:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:58088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727809AbfLJVJa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:09:30 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39F7E246A2;
        Tue, 10 Dec 2019 21:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012170;
        bh=Uu84qpMnEvTek01jYaB5sD7m/AD+QkDsg73IgbTZqkI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=11qm0ncgsqu23jJFRvuEqlC0ws4zA0Z6/B2X4w9CeCU2bbK2wr25yp+cdxEpWqhON
         QYJo/DbyeU4OQ4JZsqTVWGu/Kv9CNTWg80/cjysNgFnUD6yidHWidl498AUv4KRaFF
         7xow5Hbq74eW71JphrqwENmUhRgaXWklx2hMIAS4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chuhong Yuan <hslester96@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 5.4 129/350] staging: iio: ad9834: add a check for devm_clk_get
Date:   Tue, 10 Dec 2019 16:03:54 -0500
Message-Id: <20191210210735.9077-90-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>

[ Upstream commit a96de139301385e5992768c0f60240ddfbb33325 ]

ad9834_probe misses a check for devm_clk_get and may cause problems.
Add a check like what ad9832 does to fix it.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/iio/frequency/ad9834.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/staging/iio/frequency/ad9834.c b/drivers/staging/iio/frequency/ad9834.c
index 038d6732c3fdb..23026978a5a5f 100644
--- a/drivers/staging/iio/frequency/ad9834.c
+++ b/drivers/staging/iio/frequency/ad9834.c
@@ -417,6 +417,10 @@ static int ad9834_probe(struct spi_device *spi)
 	st = iio_priv(indio_dev);
 	mutex_init(&st->lock);
 	st->mclk = devm_clk_get(&spi->dev, NULL);
+	if (IS_ERR(st->mclk)) {
+		ret = PTR_ERR(st->mclk);
+		goto error_disable_reg;
+	}
 
 	ret = clk_prepare_enable(st->mclk);
 	if (ret) {
-- 
2.20.1

