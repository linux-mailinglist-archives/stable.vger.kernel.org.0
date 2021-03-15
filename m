Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 199B233BA62
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:10:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235527AbhCOOJE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:09:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:49768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234478AbhCOOD0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:03:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EBB2664EED;
        Mon, 15 Mar 2021 14:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615817006;
        bh=+vUotQlb5TcoJTD2VHMdAPOXyqzULayMhz7o7251Ejg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0uzwfGWy+T3FsBJEm7Z0UUJWyy0iFMGzKVYcc5C10pJAXxu/oxk/T960y6ute0khY
         owRRoK8c+n8VZqHo+/NUKhSi2ZZ/f7BNyXT4CST/xOBCHLOZ8WJPXCsOsDBvoSgBNL
         wNUaK32IZCIve47gEuUccdYbby4oF4XCQiNnQOH8=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 256/306] perf/arm_dmc620_pmu: Fix error return code in dmc620_pmu_device_probe()
Date:   Mon, 15 Mar 2021 14:55:19 +0100
Message-Id: <20210315135516.295499846@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit c8e3866836528a4ba3b0535834f03768d74f7d8e ]

Fix to return negative error code -ENOMEM from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: 53c218da220c ("driver/perf: Add PMU driver for the ARM DMC-620 memory controller")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Link: https://lore.kernel.org/r/20210312080421.277562-1-weiyongjun1@huawei.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/arm_dmc620_pmu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/perf/arm_dmc620_pmu.c b/drivers/perf/arm_dmc620_pmu.c
index 004930eb4bbb..b50b47f1a0d9 100644
--- a/drivers/perf/arm_dmc620_pmu.c
+++ b/drivers/perf/arm_dmc620_pmu.c
@@ -681,6 +681,7 @@ static int dmc620_pmu_device_probe(struct platform_device *pdev)
 	if (!name) {
 		dev_err(&pdev->dev,
 			  "Create name failed, PMU @%pa\n", &res->start);
+		ret = -ENOMEM;
 		goto out_teardown_dev;
 	}
 
-- 
2.30.1



