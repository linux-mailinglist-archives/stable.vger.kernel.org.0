Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0490037C323
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233095AbhELPRg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:17:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:50550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233929AbhELPPc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:15:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 862F961945;
        Wed, 12 May 2021 15:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831907;
        bh=JNzJkqclgj+qsZsTqLZTYNawv6r4r9lTzok9va8Pi1k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aE17wPHEHWXnRnuS6SMaox7ImhYyIDGXe9uLM9wiv9Qw+nyQPcjfxC0j9NLq/MKNm
         EvoZMIw38pghbSmnndFqtSGT4+0eXMoe2QKrGgZmwEpYJz6+QrV8Y8fgI519sllHro
         c15EkxV88wadHlCR+LMHHygbeD8CFZi6cWbuBIUA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Boris Brezillon <boris.brezillon@collabora.com>,
        Steven Price <steven.price@arm.com>
Subject: [PATCH 5.10 062/530] drm/panfrost: Clear MMU irqs before handling the fault
Date:   Wed, 12 May 2021 16:42:52 +0200
Message-Id: <20210512144821.789745915@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
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
@@ -600,6 +600,8 @@ static irqreturn_t panfrost_mmu_irq_hand
 		access_type = (fault_status >> 8) & 0x3;
 		source_id = (fault_status >> 16);
 
+		mmu_write(pfdev, MMU_INT_CLEAR, mask);
+
 		/* Page fault only */
 		ret = -1;
 		if ((status & mask) == BIT(i) && (exception_type & 0xF8) == 0xC0)
@@ -623,8 +625,6 @@ static irqreturn_t panfrost_mmu_irq_hand
 				access_type, access_type_name(pfdev, fault_status),
 				source_id);
 
-		mmu_write(pfdev, MMU_INT_CLEAR, mask);
-
 		status &= ~mask;
 	}
 


