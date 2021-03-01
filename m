Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45A99328EFD
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:45:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241669AbhCATlk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:41:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:50632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241589AbhCATcu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:32:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC53A65038;
        Mon,  1 Mar 2021 17:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618902;
        bh=gMSNn9tMPspDTuCyI1ctQlZGGgm3lYEuGaVKkrylgYM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u56/ll2Qw7jatzagFOWZRQMMj3V9SSWA2GJnXEcIukXbYu3q1kEbLrLJk0k+JtB4j
         mrlRj3adBGENBWzU4UZlzmnLEiHExjpA/rTn/aslx/vHaRCCz44YUwf0rYdLfWJX+9
         7jThwE+eJpGz7qV/SsDxMQ7KZIoZhaEInPcVCFrQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Sebastian Reichel <sre@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 258/663] HSI: Fix PM usage counter unbalance in ssi_hw_init
Date:   Mon,  1 Mar 2021 17:08:26 +0100
Message-Id: <20210301161154.582961573@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit aa57e77b3d28f0df07149d88c47bc0f3aa77330b ]

pm_runtime_get_sync will increment pm usage counter
even it failed. Forgetting to putting operation will
result in reference leak here. We fix it by replacing
it with pm_runtime_resume_and_get to keep usage counter
balanced.

Fixes: b209e047bc743 ("HSI: Introduce OMAP SSI driver")
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Signed-off-by: Sebastian Reichel <sre@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hsi/controllers/omap_ssi_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hsi/controllers/omap_ssi_core.c b/drivers/hsi/controllers/omap_ssi_core.c
index 7596dc1646484..44a3f5660c109 100644
--- a/drivers/hsi/controllers/omap_ssi_core.c
+++ b/drivers/hsi/controllers/omap_ssi_core.c
@@ -424,7 +424,7 @@ static int ssi_hw_init(struct hsi_controller *ssi)
 	struct omap_ssi_controller *omap_ssi = hsi_controller_drvdata(ssi);
 	int err;
 
-	err = pm_runtime_get_sync(ssi->device.parent);
+	err = pm_runtime_resume_and_get(ssi->device.parent);
 	if (err < 0) {
 		dev_err(&ssi->device, "runtime PM failed %d\n", err);
 		return err;
-- 
2.27.0



