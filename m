Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9603D41230B
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347975AbhITSUt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:20:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:40564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351130AbhITSSZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:18:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C8AC6632A4;
        Mon, 20 Sep 2021 17:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158582;
        bh=8zDodHJLPgbqBeip+e9adDHm4bqMx8kaLgkABP1/fi4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=108iwMJ1EmRn4nAo7lyl17S6LVDBlVKnqdWrynekSWKIbDiQvGYOB2bHP2BLk6Tc/
         axpMYLiZqh2LYki+KaPYqZI8sXQ03JWuyBsraaWU+D70qBmylT3g7XNvzPH/gTzDb4
         jr92/XAXStJNsaoyurIEQ+gdgFsX486yd80hrk9U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Rob Herring <robh@kernel.org>,
        Chris Morgan <macromorgan@hotmail.com>,
        Steven Price <steven.price@arm.com>
Subject: [PATCH 5.4 190/260] drm/panfrost: Use u64 for size in lock_region
Date:   Mon, 20 Sep 2021 18:43:28 +0200
Message-Id: <20210920163937.574266894@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>

commit a77b58825d7221d4a45c47881c35a47ba003aa73 upstream.

Mali virtual addresses are 48-bit. Use a u64 instead of size_t to ensure
we can express the "lock everything" condition as ~0ULL without
overflow. This code was silently broken on any platform where a size_t
is less than 48-bits; in particular, it was broken on 32-bit armv7
platforms which remain in use with panfrost. (Mainly RK3288)

Signed-off-by: Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>
Suggested-by: Rob Herring <robh@kernel.org>
Tested-by: Chris Morgan <macromorgan@hotmail.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Fixes: f3ba91228e8e ("drm/panfrost: Add initial panfrost driver")
Cc: <stable@vger.kernel.org>
Signed-off-by: Steven Price <steven.price@arm.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210824173028.7528-3-alyssa.rosenzweig@collabora.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/panfrost/panfrost_mmu.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/panfrost/panfrost_mmu.c
+++ b/drivers/gpu/drm/panfrost/panfrost_mmu.c
@@ -52,7 +52,7 @@ static int write_cmd(struct panfrost_dev
 }
 
 static void lock_region(struct panfrost_device *pfdev, u32 as_nr,
-			u64 iova, size_t size)
+			u64 iova, u64 size)
 {
 	u8 region_width;
 	u64 region = iova & PAGE_MASK;
@@ -72,7 +72,7 @@ static void lock_region(struct panfrost_
 
 
 static int mmu_hw_do_operation_locked(struct panfrost_device *pfdev, int as_nr,
-				      u64 iova, size_t size, u32 op)
+				      u64 iova, u64 size, u32 op)
 {
 	if (as_nr < 0)
 		return 0;
@@ -89,7 +89,7 @@ static int mmu_hw_do_operation_locked(st
 
 static int mmu_hw_do_operation(struct panfrost_device *pfdev,
 			       struct panfrost_mmu *mmu,
-			       u64 iova, size_t size, u32 op)
+			       u64 iova, u64 size, u32 op)
 {
 	int ret;
 
@@ -106,7 +106,7 @@ static void panfrost_mmu_enable(struct p
 	u64 transtab = cfg->arm_mali_lpae_cfg.transtab;
 	u64 memattr = cfg->arm_mali_lpae_cfg.memattr;
 
-	mmu_hw_do_operation_locked(pfdev, as_nr, 0, ~0UL, AS_COMMAND_FLUSH_MEM);
+	mmu_hw_do_operation_locked(pfdev, as_nr, 0, ~0ULL, AS_COMMAND_FLUSH_MEM);
 
 	mmu_write(pfdev, AS_TRANSTAB_LO(as_nr), transtab & 0xffffffffUL);
 	mmu_write(pfdev, AS_TRANSTAB_HI(as_nr), transtab >> 32);
@@ -122,7 +122,7 @@ static void panfrost_mmu_enable(struct p
 
 static void panfrost_mmu_disable(struct panfrost_device *pfdev, u32 as_nr)
 {
-	mmu_hw_do_operation_locked(pfdev, as_nr, 0, ~0UL, AS_COMMAND_FLUSH_MEM);
+	mmu_hw_do_operation_locked(pfdev, as_nr, 0, ~0ULL, AS_COMMAND_FLUSH_MEM);
 
 	mmu_write(pfdev, AS_TRANSTAB_LO(as_nr), 0);
 	mmu_write(pfdev, AS_TRANSTAB_HI(as_nr), 0);
@@ -222,7 +222,7 @@ static size_t get_pgsize(u64 addr, size_
 
 static void panfrost_mmu_flush_range(struct panfrost_device *pfdev,
 				     struct panfrost_mmu *mmu,
-				     u64 iova, size_t size)
+				     u64 iova, u64 size)
 {
 	if (mmu->as < 0)
 		return;


