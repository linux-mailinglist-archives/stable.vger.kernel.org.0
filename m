Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA1D2E3ADA
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404228AbgL1Nmc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:42:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:42760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404216AbgL1Nm2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:42:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4DD04208B3;
        Mon, 28 Dec 2020 13:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162907;
        bh=83jB+2SiUlnBFwgy4mpZgWFrRPXBFUaLgwxOj7lA4jM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zwc6vUrCuPAuVxnwrTtyH75ilyXvQNII0tsfdofMMETeifMuUO4wH9Slv1kh0LCkq
         FNSX+sIbraRKqt+F1NgqfpfHVRrs+wi7wm73iWDfpMDRaC/+YvXcmF0gqK1+qQjga7
         QdtiL9hUPR9vJ9We4Kr8Vx5MiIs0wEtiwSZw7SBE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 101/453] spi: img-spfi: fix reference leak in img_spfi_resume
Date:   Mon, 28 Dec 2020 13:45:37 +0100
Message-Id: <20201228124942.076239473@linuxfoundation.org>
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
index f4a8f470aecc2..e9ef80983b791 100644
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



