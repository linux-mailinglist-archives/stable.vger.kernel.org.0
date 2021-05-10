Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CEC73787DB
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235170AbhEJLTQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:19:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:46128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236698AbhEJLIf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:08:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A71F619C0;
        Mon, 10 May 2021 11:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644609;
        bh=BZ0ndxHIGXHhwN/T9tjYm4VD+c2e9yJki+gYk3dhELo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uyNXM3YjwRdyoQsPhcSzWKDKnWYh/GQQ7VqO//di7JKcisnxKwm4gFodqNH6a6BV1
         duIHAopWi+fhwIt3qqPDJgxZikABG/7Twv2fmo95CE5UCIe3ZGeIyyPRNC6nwpY9AU
         iM1OHITsxKt7vFIPWbUfYIdVqKwLDQiXNVtFWz0E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wang Li <wangli74@huawei.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 116/384] spi: qup: fix PM reference leak in spi_qup_remove()
Date:   Mon, 10 May 2021 12:18:25 +0200
Message-Id: <20210510102018.720533980@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 8dcb2e70735c..d39dec6d1c91 100644
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



