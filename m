Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64CAE12C681
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:54:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731325AbfL2Rrq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:47:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:58604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731323AbfL2Rrp (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:47:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17C03208C4;
        Sun, 29 Dec 2019 17:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641665;
        bh=LXYiXgod8Q1KuufpoU54Za2Mw1z6mmO+GcTyh3GQB30=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SAHmB7vQZknPXvTwtLtPH/8C6g8X7GPX+Os1IAB25ru+9Nzks+cHJe5fmhQ6kfKHm
         TQdcXj3MQLWy/4I3gnnboKUd7dINsb85JG1O9tdqA8GzbzvgYpwyTf18WRVBfeqLJj
         N86zqGLOdDOxAPD/FpgXXt700Xx8mSnAHqM+iNQs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 161/434] staging: iio: ad9834: add a check for devm_clk_get
Date:   Sun, 29 Dec 2019 18:23:34 +0100
Message-Id: <20191229172712.466855783@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 038d6732c3fd..23026978a5a5 100644
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



