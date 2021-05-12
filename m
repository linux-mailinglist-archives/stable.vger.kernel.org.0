Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7228637C71A
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234325AbhELP6M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:58:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:34658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233998AbhELPxJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:53:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2590661A14;
        Wed, 12 May 2021 15:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833218;
        bh=/HFZBa4NDhyO9sJC0ZsrlCg/ZooKNMtoOTPTowbnQFc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qM7tSNqhMQ7XIHpTEE39lZnW4m/F6nTTA5B78k5S2723ytYopNHsxf/JXDL3oiei8
         dtHEA/MlYryL8ZpAUuwsNBW8OaoBivqViRM6lJxEGTpq+6odb7VEB8Idd0j4uL7hlF
         pqepW34DMzUHu9yifW6MYrvMwxtKT1jnjp8UIIvg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Boris Brezillon <boris.brezillon@collabora.com>,
        Steven Price <steven.price@arm.com>
Subject: [PATCH 5.11 064/601] drm/panfrost: Clear MMU irqs before handling the fault
Date:   Wed, 12 May 2021 16:42:21 +0200
Message-Id: <20210512144829.924013404@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Boris Brezillon <boris.brezillon@collabora.com>

commit 3aa0a80fc692c9959c261f4c5bfe9c23ddd90562 upstream.

When a fault is handled it will unblock the GPU which will continue
executing its shader and might fault almost immediately on a different
page. If we clear interrupts after handling the fault we might miss new
faults, so clear them before.

Cc: <stable@vger.kernel.org>
Fixes: 187d2929206e ("drm/panfrost: Add support for GPU heap allocations")
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210205111757.585248-2-boris.brezillon@collabora.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/panfrost/panfrost_mmu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/panfrost/panfrost_mmu.c
+++ b/drivers/gpu/drm/panfrost/panfrost_mmu.c
@@ -593,6 +593,8 @@ static irqreturn_t panfrost_mmu_irq_hand
 		access_type = (fault_status >> 8) & 0x3;
 		source_id = (fault_status >> 16);
 
+		mmu_write(pfdev, MMU_INT_CLEAR, mask);
+
 		/* Page fault only */
 		ret = -1;
 		if ((status & mask) == BIT(i) && (exception_type & 0xF8) == 0xC0)
@@ -616,8 +618,6 @@ static irqreturn_t panfrost_mmu_irq_hand
 				access_type, access_type_name(pfdev, fault_status),
 				source_id);
 
-		mmu_write(pfdev, MMU_INT_CLEAR, mask);
-
 		status &= ~mask;
 	}
 


