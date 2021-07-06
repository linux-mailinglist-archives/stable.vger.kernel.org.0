Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB7123BCC1A
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232507AbhGFLS1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:18:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:53640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232390AbhGFLSN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:18:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 85D7A61C65;
        Tue,  6 Jul 2021 11:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570135;
        bh=3TknRs7jyrXAfj5flQ03eMn8DEVq11RAc6wlWlgdPjM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q7giBTTXq3840tPYKx7BIwOza9mFdl0B0gsPkWf6Re+q5JSedLM4h2yvblfiFUeb6
         kht6yBc4NxqaxXyx+WdQ4OvUC7pJhUVmn1LVJEzektUXtnZ5OiwAwfrc3ilEe/jNCC
         eiDk8cLB3oRNiRAHXXkD0UDpsdP0pNOSCOpvUovhCqc1lo6sJCuntO1S23Z+ybOfp0
         IUu71eM6WKZBRZPsZgnBa92J4Jj+n86PiPhvyGtBJfC+JXrPoyoI1SZaiexuoELzhM
         EwBHBe3OZFlrA0UREAFlcicbhOzc4vhowPdzkENalBeg6WPvg3AqIXGQmMR410n/+U
         XTN2JZEAzQGsQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yu Kuai <yukuai3@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.13 061/189] drm: bridge: cdns-mhdp8546: Fix PM reference leak in
Date:   Tue,  6 Jul 2021 07:12:01 -0400
Message-Id: <20210706111409.2058071-61-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit f674555ee5444c8987dfea0922f1cf6bf0c12847 ]

pm_runtime_get_sync will increment pm usage counter even it failed.
Forgetting to putting operation will result in reference leak here.
Fix it by replacing it with pm_runtime_resume_and_get to keep usage
counter balanced.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Robert Foss <robert.foss@linaro.org>
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20210531135622.3348252-1-yukuai3@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-core.c b/drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-core.c
index 989a05bc8197..ddcd5b6ad37a 100644
--- a/drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-core.c
+++ b/drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-core.c
@@ -2369,9 +2369,9 @@ static int cdns_mhdp_probe(struct platform_device *pdev)
 	clk_prepare_enable(clk);
 
 	pm_runtime_enable(dev);
-	ret = pm_runtime_get_sync(dev);
+	ret = pm_runtime_resume_and_get(dev);
 	if (ret < 0) {
-		dev_err(dev, "pm_runtime_get_sync failed\n");
+		dev_err(dev, "pm_runtime_resume_and_get failed\n");
 		pm_runtime_disable(dev);
 		goto clk_disable;
 	}
-- 
2.30.2

