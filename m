Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E090F37C1E5
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231776AbhELPFt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:05:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:59200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232164AbhELPDi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:03:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4910A61936;
        Wed, 12 May 2021 14:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831532;
        bh=Dw8RPcxzKL1Kx+A7tHq6t2f97yWJOJVe6YXpUBFR3mE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RIVhKP42QuC8oeAYTZ3lPbeHcGWFulr2658r4nL6XSIeRy482IwrEksYSW6WpCAIW
         KijelIYoJKruEFYkIugy+hQ2hR/9Y3IjMhCQrNzCF56SpWhiK48DiY7/PU/ZB8iqJI
         Zi/BZkMqXYh1RflqdDGQ3ooPcaoeQFGZ9QbrUAyo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wang Li <wangli74@huawei.com>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 122/244] spi: fsl-lpspi: Fix PM reference leak in lpspi_prepare_xfer_hardware()
Date:   Wed, 12 May 2021 16:48:13 +0200
Message-Id: <20210512144746.923778069@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144743.039977287@linuxfoundation.org>
References: <20210512144743.039977287@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Li <wangli74@huawei.com>

[ Upstream commit a03675497970a93fcf25d81d9d92a59c2d7377a7 ]

pm_runtime_get_sync will increment pm usage counter even it failed.
Forgetting to putting operation will result in reference leak here.
Fix it by replacing it with pm_runtime_resume_and_get to keep usage
counter balanced.

Fixes: 944c01a889d9 ("spi: lpspi: enable runtime pm for lpspi")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Li <wangli74@huawei.com>
Link: https://lore.kernel.org/r/20210409095430.29868-1-wangli74@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsl-lpspi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-fsl-lpspi.c b/drivers/spi/spi-fsl-lpspi.c
index ecb4396707cf..58b2da91be1c 100644
--- a/drivers/spi/spi-fsl-lpspi.c
+++ b/drivers/spi/spi-fsl-lpspi.c
@@ -207,7 +207,7 @@ static int lpspi_prepare_xfer_hardware(struct spi_controller *controller)
 				spi_controller_get_devdata(controller);
 	int ret;
 
-	ret = pm_runtime_get_sync(fsl_lpspi->dev);
+	ret = pm_runtime_resume_and_get(fsl_lpspi->dev);
 	if (ret < 0) {
 		dev_err(fsl_lpspi->dev, "failed to enable clock\n");
 		return ret;
-- 
2.30.2



