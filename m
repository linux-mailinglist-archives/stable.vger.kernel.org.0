Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEF743BC013
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 17:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232808AbhGEPeQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 11:34:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:58844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232354AbhGEPda (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 11:33:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B93FD619A2;
        Mon,  5 Jul 2021 15:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625499045;
        bh=LqpN0VER40y/UmN+zSWgGA2PWKnR8rCjiWmFowHDx2c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qq3QV/rQcMuQpCLk6HPoam4RP/ROEzwWFy1zJHlxAPxMaxjDABAQ0JSnm6DAh+v+N
         mPqXwfs8Yl2Jb8UbwhNDLU4FLXETnfJQB1WsrqN0iZDIQD7q3GclvGAeKeO9ij0phy
         vG13CYfuOt5QrJ3tKDyDyFSuBEFNo6+RHwLNrNqe6UUM+PDhuAA/1dyrqgKFwz5IZG
         YP5xpTJC6T+V1G58E8badWAtsF7Bk8dBrv9v9+3RyyGzMeVrV5zSMEbjWPxX/BqLd9
         uA1mB/3pl8VkvhSnTg9/13Bdjn1VdMzmGh4MaIo+SzEsvxHpx8uMeURG9OA5H5HzP1
         S28GRLWSUs1Bw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     YueHaibing <yuehaibing@huawei.com>, Wei Liu <wei.liu@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-hyperv@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 04/26] hv_utils: Fix passing zero to 'PTR_ERR' warning
Date:   Mon,  5 Jul 2021 11:30:17 -0400
Message-Id: <20210705153039.1521781-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705153039.1521781-1-sashal@kernel.org>
References: <20210705153039.1521781-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit c6a8625fa4c6b0a97860d053271660ccedc3d1b3 ]

Sparse warn this:

drivers/hv/hv_util.c:753 hv_timesync_init() warn:
 passing zero to 'PTR_ERR'

Use PTR_ERR_OR_ZERO instead of PTR_ERR to fix this.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Link: https://lore.kernel.org/r/20210514070116.16800-1-yuehaibing@huawei.com
[ wei: change %ld to %d ]
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/hv_util.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hv/hv_util.c b/drivers/hv/hv_util.c
index e32681ee7b9f..1671f6f9ea80 100644
--- a/drivers/hv/hv_util.c
+++ b/drivers/hv/hv_util.c
@@ -537,8 +537,8 @@ static int hv_timesync_init(struct hv_util_service *srv)
 	 */
 	hv_ptp_clock = ptp_clock_register(&ptp_hyperv_info, NULL);
 	if (IS_ERR_OR_NULL(hv_ptp_clock)) {
-		pr_err("cannot register PTP clock: %ld\n",
-		       PTR_ERR(hv_ptp_clock));
+		pr_err("cannot register PTP clock: %d\n",
+		       PTR_ERR_OR_ZERO(hv_ptp_clock));
 		hv_ptp_clock = NULL;
 	}
 
-- 
2.30.2

