Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 380312119A7
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 03:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728185AbgGBBXF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jul 2020 21:23:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:53346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728174AbgGBBXD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Jul 2020 21:23:03 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8AAAA20874;
        Thu,  2 Jul 2020 01:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593652982;
        bh=H6E1ErTHKdU8VDL/lt494z9m+g1stL2ziOwVXwpMVPw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RsBmcNxWvcFx8Qd0eTxU8HcHpfbmrYWP3whfaXxMqJJgJ/fIVfN4kC5Vr8OjHGNI7
         8v5eCp5xz1u9XkDTBf34C1IvnEhRySFyBksWYTJf9cLV1A6IK+qGgDjNdKARoB0bnx
         C6g3FlX7XZ9dxdLqx5fQ05/xOz5esjdVUEQCnXh8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org
Subject: [PATCH AUTOSEL 5.7 06/53] drm/ttm: Fix dma_fence refcnt leak in ttm_bo_vm_fault_reserved
Date:   Wed,  1 Jul 2020 21:21:15 -0400
Message-Id: <20200702012202.2700645-6-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200702012202.2700645-1-sashal@kernel.org>
References: <20200702012202.2700645-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiyu Yang <xiyuyang19@fudan.edu.cn>

[ Upstream commit 37cc4b95d13f311c04aa8e9daacca3905ad45ca7 ]

ttm_bo_vm_fault_reserved() invokes dma_fence_get(), which returns a
reference of the specified dma_fence object to "moving" with increased
refcnt.

When ttm_bo_vm_fault_reserved() returns, local variable "moving" becomes
invalid, so the refcount should be decreased to keep refcount balanced.

The reference counting issue happens in several exception handling paths
of ttm_bo_vm_fault_reserved(). When those error scenarios occur such as
"err" equals to -EBUSY, the function forgets to decrease the refcnt
increased by dma_fence_get(), causing a refcnt leak.

Fix this issue by calling dma_fence_put() when no_wait_gpu flag is
equals to true.

Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Link: https://patchwork.freedesktop.org/patch/370219/
Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/ttm/ttm_bo_vm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/ttm/ttm_bo_vm.c b/drivers/gpu/drm/ttm/ttm_bo_vm.c
index 0ad30b1129821..72100b84c7a90 100644
--- a/drivers/gpu/drm/ttm/ttm_bo_vm.c
+++ b/drivers/gpu/drm/ttm/ttm_bo_vm.c
@@ -300,8 +300,10 @@ vm_fault_t ttm_bo_vm_fault_reserved(struct vm_fault *vmf,
 			break;
 		case -EBUSY:
 		case -ERESTARTSYS:
+			dma_fence_put(moving);
 			return VM_FAULT_NOPAGE;
 		default:
+			dma_fence_put(moving);
 			return VM_FAULT_SIGBUS;
 		}
 
-- 
2.25.1

