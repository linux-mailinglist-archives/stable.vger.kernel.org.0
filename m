Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46CAA2E14FB
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:48:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729679AbgLWCqk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:46:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:51608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729588AbgLWCWX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:22:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D82F22D73;
        Wed, 23 Dec 2020 02:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690103;
        bh=XitNI+swoahknvrU7wIkuQWm/ZDSEfLzITifbQu7TJI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=js5wlD4wxHTpiZFhD4qJsYquaDLNqZDK1JObJvDEKisbGpmjcFOTMlowsYVKOOXoj
         H1wCuOAmr8IOfBBifpQILQYZaxqU5PtZ05/f9IhwbL/oKP3aArc4yrCU2l0OKVQLLf
         MlR7WBN+A99wwjFyWII4jVZILs7Ywy+aKAgGvwGyAyj2HCQDzlbl8ZARI/er51RKx2
         ii8T1/STzHBjYzNMdlRUkzrAV3/3uLbljoLSY1L6UvlzMFZn0eTIVHGt8WrGIy09fd
         MSG/f/y+hVPQVLWe7MOK/OSfnqYQST9KoXT52fgMYaKhq+k2fbS/ZX4CrnRtrF1TUd
         PQctjBP4av+xw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzk@kernel.org>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-mmc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 32/87] mmc: tmio: do not print real IOMEM pointer
Date:   Tue, 22 Dec 2020 21:20:08 -0500
Message-Id: <20201223022103.2792705-32-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022103.2792705-1-sashal@kernel.org>
References: <20201223022103.2792705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit ade8e9d3fb9232ddfb87a4bc641b35b988d9757b ]

Printing kernel pointers is discouraged because they might leak kernel
memory layout.  This fixes smatch warning:

    drivers/mmc/host/tmio_mmc.c:177 tmio_mmc_probe() warn: argument 3 to %08lx specifier is cast from pointer

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Link: https://lore.kernel.org/r/20201116164252.44078-1-krzk@kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/tmio_mmc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/mmc/host/tmio_mmc.c b/drivers/mmc/host/tmio_mmc.c
index 43a2ea5cff24f..9564aaf71442b 100644
--- a/drivers/mmc/host/tmio_mmc.c
+++ b/drivers/mmc/host/tmio_mmc.c
@@ -114,8 +114,7 @@ static int tmio_mmc_probe(struct platform_device *pdev)
 	if (ret)
 		goto host_remove;
 
-	pr_info("%s at 0x%08lx irq %d\n", mmc_hostname(host->mmc),
-		(unsigned long)host->ctl, irq);
+	pr_info("%s at 0x%p irq %d\n", mmc_hostname(host->mmc), host->ctl, irq);
 
 	return 0;
 
-- 
2.27.0

