Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B1292E3895
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:14:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731973AbgL1NMK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:12:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:39566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731968AbgL1NMK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:12:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 45E93206ED;
        Mon, 28 Dec 2020 13:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161114;
        bh=jxrjnqIMyw4tF0dbRn8yKHdCEljgt65L9YbVWa44q3k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oMHolew5Nn7E4p+FE+YcsmuwyBEkemDodOcUqfzLMr5rSGunQrYFd6CEeKlD0p3j6
         o5/pikJLMcs2f5DYOqt3OV9xWY6xZCUvXFr81sWCiBY4P57HHeBR6/kCq26nFbXCYl
         uMpCEVU/tFuBkcTLr3D9w8OtjL4f9dvAaZW2+wkk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 076/242] spi: img-spfi: fix reference leak in img_spfi_resume
Date:   Mon, 28 Dec 2020 13:48:01 +0100
Message-Id: <20201228124908.428565523@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124904.654293249@linuxfoundation.org>
References: <20201228124904.654293249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit ee5558a9084584015c8754ffd029ce14a5827fa8 ]

pm_runtime_get_sync will increment pm usage counter even it
failed. Forgetting to pm_runtime_put_noidle will result in
reference leak in img_spfi_resume, so we should fix it.

Fixes: deba25800a12b ("spi: Add driver for IMG SPFI controller")
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Link: https://lore.kernel.org/r/20201102145651.3875-1-zhangqilong3@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-img-spfi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-img-spfi.c b/drivers/spi/spi-img-spfi.c
index 2e65b70c78792..2a340234c85c1 100644
--- a/drivers/spi/spi-img-spfi.c
+++ b/drivers/spi/spi-img-spfi.c
@@ -771,8 +771,10 @@ static int img_spfi_resume(struct device *dev)
 	int ret;
 
 	ret = pm_runtime_get_sync(dev);
-	if (ret)
+	if (ret) {
+		pm_runtime_put_noidle(dev);
 		return ret;
+	}
 	spfi_reset(spfi);
 	pm_runtime_put(dev);
 
-- 
2.27.0



