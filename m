Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C4E23C2E6E
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233741AbhGJC1I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:27:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:42616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233379AbhGJC0i (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:26:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E772D613EC;
        Sat, 10 Jul 2021 02:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883829;
        bh=bTYqlpNdoAoSEPSHIyiL4RKxHJprX5EKA4dt7923Zoo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RwfaOGyWyTvvPikeZVgvby4f37b6vTiqzDbybXfpUaQJ7WcMIFhc3NfYYVFQIeJO0
         2dA06YaW1tfyQ9b569YKQw346iiRSrvFJo142N+2Yarzq1QfQhnBJi1ZdqUF8O2uvg
         WwIXTPmhpnsfWNHWlVBvUzR5zin8W9YwOJnXbXT/tcTuXYtDBs9tc81ZlXuVPtVpEh
         kDKPjRTgobktxvf1/dXDLBVVQ/v2095rd8VhRF9mgzBgI1MiT3poDU7+u29hZoDZ48
         1SYm807OtXuKjfb3XGtv71bFaFquPhD/9jEPEAemDQMJAQxLUdDMNVlYhrOO395MbV
         hQpZOZVmuH/WQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Koby Elbaz <kelbaz@habana.ai>, Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.12 077/104] habanalabs/gaudi: set the correct rc in case of err
Date:   Fri,  9 Jul 2021 22:21:29 -0400
Message-Id: <20210710022156.3168825-77-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022156.3168825-1-sashal@kernel.org>
References: <20210710022156.3168825-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Koby Elbaz <kelbaz@habana.ai>

[ Upstream commit 1f7ef4bf41c7c2abad3d21b8c69db11fc3ebc4f5 ]

fix the following smatch warnings:
gaudi_internal_cb_pool_init() warn: missing error code 'rc'

Signed-off-by: Koby Elbaz <kelbaz@habana.ai>
Reviewed-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/gaudi/gaudi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/habanalabs/gaudi/gaudi.c b/drivers/misc/habanalabs/gaudi/gaudi.c
index 0c6092ebbc04..894056da22cf 100644
--- a/drivers/misc/habanalabs/gaudi/gaudi.c
+++ b/drivers/misc/habanalabs/gaudi/gaudi.c
@@ -8070,8 +8070,10 @@ static int gaudi_internal_cb_pool_init(struct hl_device *hdev,
 			HL_VA_RANGE_TYPE_HOST, HOST_SPACE_INTERNAL_CB_SZ,
 			HL_MMU_VA_ALIGNMENT_NOT_NEEDED);
 
-	if (!hdev->internal_cb_va_base)
+	if (!hdev->internal_cb_va_base) {
+		rc = -ENOMEM;
 		goto destroy_internal_cb_pool;
+	}
 
 	mutex_lock(&ctx->mmu_lock);
 	rc = hl_mmu_map_contiguous(ctx, hdev->internal_cb_va_base,
-- 
2.30.2

