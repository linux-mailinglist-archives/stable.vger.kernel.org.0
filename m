Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F27359507D
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231869AbiHPEm2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:42:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232428AbiHPElN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:41:13 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9436ED4D;
        Mon, 15 Aug 2022 13:32:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 06060CE12C5;
        Mon, 15 Aug 2022 20:32:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C772BC433D6;
        Mon, 15 Aug 2022 20:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595549;
        bh=xqfJ9NdAkPaq4jMxZ9BS+VzU3qb/PbaYW6pplMlD1p0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vT+qjInGKM9ALcWLhObEzZ6SurvkZ7ylf7HfwtMg2NfGiYDm/h6DCYz/uken7j3Xi
         N9onZUKpjHVKTB3scOeWL0rMLuCmMYcFyPHMonzSfHzYvc9da7We3uHk63fnvHl+/V
         MoW/5DaLSjDou7oyx4Kiqha/IbvstIxCG5F4TcBo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0792/1157] habanalabs: fix double unlock on error in map_device_va()
Date:   Mon, 15 Aug 2022 20:02:28 +0200
Message-Id: <20220815180511.156800178@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit a43a9f67774adbd575d10ec88824016fbe034777 ]

If hl_mmu_prefetch_cache_range() fails then this code calls
mutex_unlock(&ctx->mmu_lock) when it's no longer holding the mutex.

Fixes: 9e495e24003e ("habanalabs: do MMU prefetch as deferred work")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/common/memory.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/habanalabs/common/memory.c b/drivers/misc/habanalabs/common/memory.c
index 663dd7e589d4..d5e6500f8a1f 100644
--- a/drivers/misc/habanalabs/common/memory.c
+++ b/drivers/misc/habanalabs/common/memory.c
@@ -1245,16 +1245,16 @@ static int map_device_va(struct hl_ctx *ctx, struct hl_mem_in *args, u64 *device
 	rc = map_phys_pg_pack(ctx, ret_vaddr, phys_pg_pack);
 	if (rc) {
 		dev_err(hdev->dev, "mapping page pack failed for handle %u\n", handle);
+		mutex_unlock(&ctx->mmu_lock);
 		goto map_err;
 	}
 
 	rc = hl_mmu_invalidate_cache_range(hdev, false, *vm_type | MMU_OP_SKIP_LOW_CACHE_INV,
 				ctx->asid, ret_vaddr, phys_pg_pack->total_size);
+	mutex_unlock(&ctx->mmu_lock);
 	if (rc)
 		goto map_err;
 
-	mutex_unlock(&ctx->mmu_lock);
-
 	/*
 	 * prefetch is done upon user's request. it is performed in WQ as and so can
 	 * be outside the MMU lock. the operation itself is already protected by the mmu lock
@@ -1283,8 +1283,6 @@ static int map_device_va(struct hl_ctx *ctx, struct hl_mem_in *args, u64 *device
 	return rc;
 
 map_err:
-	mutex_unlock(&ctx->mmu_lock);
-
 	if (add_va_block(hdev, va_range, ret_vaddr,
 				ret_vaddr + phys_pg_pack->total_size - 1))
 		dev_warn(hdev->dev,
-- 
2.35.1



