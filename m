Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDC062F538
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728179AbfE3EpV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:45:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:52678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728717AbfE3DLw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:11:52 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 107B124503;
        Thu, 30 May 2019 03:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185912;
        bh=kSDMB93qouo8XN377zhespyfUO9e7dXJqdZ0dU7pCV4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B747tFAMcIwJszqD6SM7cZR/qKAIS07in9JS3YaqV6MXDxfZJMvChZuCXaUeW71ar
         l6j4M/jgn6PfIf97F91uQzf5OnHdnyMYcDE46lAwdew8D0Q5mFGjrNAaNXz7px1i3K
         qdSnF178Nq+zi+Z1eTX5WTk/T2XJ236kPspVHfV4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oded Gabbay <oded.gabbay@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 284/405] habanalabs: prevent CPU soft lockup on Palladium
Date:   Wed, 29 May 2019 20:04:42 -0700
Message-Id: <20190530030555.249995994@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit e850b89f50d2c1439f58d547b888ee6e43312dea ]

Unmapping ptes in the device MMU on Palladium can take a long time, which
can cause a kernel BUG of CPU soft lockup.

This patch minimize the chances for this bug by sleeping a little between
unmapping ptes.

Signed-off-by: Oded Gabbay <oded.gabbay@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/memory.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/habanalabs/memory.c b/drivers/misc/habanalabs/memory.c
index ce1fda40a8b81..fadaf557603f5 100644
--- a/drivers/misc/habanalabs/memory.c
+++ b/drivers/misc/habanalabs/memory.c
@@ -1046,10 +1046,17 @@ static int unmap_device_va(struct hl_ctx *ctx, u64 vaddr)
 
 	mutex_lock(&ctx->mmu_lock);
 
-	for (i = 0 ; i < phys_pg_pack->npages ; i++, next_vaddr += page_size)
+	for (i = 0 ; i < phys_pg_pack->npages ; i++, next_vaddr += page_size) {
 		if (hl_mmu_unmap(ctx, next_vaddr, page_size))
 			dev_warn_ratelimited(hdev->dev,
-				"unmap failed for vaddr: 0x%llx\n", next_vaddr);
+			"unmap failed for vaddr: 0x%llx\n", next_vaddr);
+
+		/* unmapping on Palladium can be really long, so avoid a CPU
+		 * soft lockup bug by sleeping a little between unmapping pages
+		 */
+		if (hdev->pldm)
+			usleep_range(500, 1000);
+	}
 
 	hdev->asic_funcs->mmu_invalidate_cache(hdev, true);
 
-- 
2.20.1



