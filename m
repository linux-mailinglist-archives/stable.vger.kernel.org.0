Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D4D4370C97
	for <lists+stable@lfdr.de>; Sun,  2 May 2021 16:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232952AbhEBOGp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 May 2021 10:06:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:50872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232953AbhEBOFz (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 May 2021 10:05:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 56979613D7;
        Sun,  2 May 2021 14:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619964303;
        bh=gx7YaaLG+/q2NLR1sJdc6IOzuJlWAKa4fh2qkLtGoMw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uW2RBULYgPgeWPTRo2sS/54zifl41CBAMzBu1ZYOGnTE2ZWQhpd60/U2QIWddHn9N
         guwzreR5SvTwd7sMwHlGcJaLPEg3NheR753haO6kNSdgTsQAFikUYFhyeutPDwj4yS
         1Gn07zL0F8mpvqD5/sbcKMO+8s/Q7qYHeuA/nEYdLIUVut+6xN0ZyePFL2eV2ZgCck
         IKUs8v6ogmginV6Nuc5ytCAM2rtIp89u7thFv/rvZO0YlLn7lzKl76zwPrPbqDMD6h
         vaBv4rpY4BpKj8yMZqfHr/q9Al4x/vAUni6fflU8e/YvHeUfHzca77jHTDM2oep5LJ
         +TD+ho7HmL/7Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wang Li <wangli74@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 23/34] spi: qup: fix PM reference leak in spi_qup_remove()
Date:   Sun,  2 May 2021 10:04:23 -0400
Message-Id: <20210502140434.2719553-23-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502140434.2719553-1-sashal@kernel.org>
References: <20210502140434.2719553-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Li <wangli74@huawei.com>

[ Upstream commit cec77e0a249892ceb10061bf17b63f9fb111d870 ]

pm_runtime_get_sync will increment pm usage counter even it failed.
Forgetting to putting operation will result in reference leak here.
Fix it by replacing it with pm_runtime_resume_and_get to keep usage
counter balanced.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Li <wangli74@huawei.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20210409095458.29921-1-wangli74@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-qup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-qup.c b/drivers/spi/spi-qup.c
index fa8079fbea77..d1dfb52008b4 100644
--- a/drivers/spi/spi-qup.c
+++ b/drivers/spi/spi-qup.c
@@ -1263,7 +1263,7 @@ static int spi_qup_remove(struct platform_device *pdev)
 	struct spi_qup *controller = spi_master_get_devdata(master);
 	int ret;
 
-	ret = pm_runtime_get_sync(&pdev->dev);
+	ret = pm_runtime_resume_and_get(&pdev->dev);
 	if (ret < 0)
 		return ret;
 
-- 
2.30.2

