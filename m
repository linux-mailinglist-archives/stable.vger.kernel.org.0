Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE229615D
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 15:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729999AbfHTNlT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 09:41:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:36174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730329AbfHTNlI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Aug 2019 09:41:08 -0400
Received: from sasha-vm.mshome.net (unknown [12.236.144.82])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C81A32339D;
        Tue, 20 Aug 2019 13:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566308468;
        bh=e/1P0V9l37AQ5JpRuCZIgnLRVgaOKyQoQNB8AnYfnW0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pN3Bc3BezSg+dCZWuaBUb/v9Vi8bzFb0dYX8vSZJFR6bWJ5zu5UI7RDvKqzNv3MPf
         x/XEIvmX005GmvrUSTLhxGpcWe+BGFHi8AB8opjFK3oDOhfOpWTVD1x4dCIrwMlbqc
         J8avMC4Wj4H8ha1NlTH10BYEDpK+/RMOV7uIbZbE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tomer Tayar <ttayar@habana.ai>,
        Oded Gabbay <oded.gabbay@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 30/44] habanalabs: fix DRAM usage accounting on context tear down
Date:   Tue, 20 Aug 2019 09:40:14 -0400
Message-Id: <20190820134028.10829-30-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190820134028.10829-1-sashal@kernel.org>
References: <20190820134028.10829-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tomer Tayar <ttayar@habana.ai>

[ Upstream commit c8113756ba27298d6e95403c087dc5881b419a99 ]

The patch fix the DRAM usage accounting by adding a missing update of
the DRAM memory consumption, when a context is being torn down without an
organized release of the allocated memory.

Signed-off-by: Tomer Tayar <ttayar@habana.ai>
Reviewed-by: Oded Gabbay <oded.gabbay@gmail.com>
Signed-off-by: Oded Gabbay <oded.gabbay@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/memory.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/misc/habanalabs/memory.c b/drivers/misc/habanalabs/memory.c
index 693877e37fd87..924a438ba9736 100644
--- a/drivers/misc/habanalabs/memory.c
+++ b/drivers/misc/habanalabs/memory.c
@@ -1629,6 +1629,8 @@ void hl_vm_ctx_fini(struct hl_ctx *ctx)
 			dev_dbg(hdev->dev,
 				"page list 0x%p of asid %d is still alive\n",
 				phys_pg_list, ctx->asid);
+			atomic64_sub(phys_pg_list->total_size,
+					&hdev->dram_used_mem);
 			free_phys_pg_pack(hdev, phys_pg_list);
 			idr_remove(&vm->phys_pg_pack_handles, i);
 		}
-- 
2.20.1

