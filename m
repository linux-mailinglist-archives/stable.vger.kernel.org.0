Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAF7B3834D9
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241809AbhEQPMw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:12:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:37272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242993AbhEQPKf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:10:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 46921616E9;
        Mon, 17 May 2021 14:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261846;
        bh=gYSpMSpcemkS+AZtk7k2jROkybl1/SgYrbZvQokyg7w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WTcFtb5nzLTV0f2yRUUJU2zf7aWWZm3e4bp7+Ej/tl87tAKRt3T1we62RstZmWh4z
         XlC2SXiGddJS0sSzaGXS2JBWwgGvjq5kyZl01UBlnaj2KlxQ0M73+MCv6DFvGcpJYb
         fOtxCgdK7BQFEDfMf9sskWofsb8dBu9mowZ4QVAE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jinzhou Su <Jinzhou.Su@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 075/289] drm/amdgpu: Add mem sync flag for IB allocated by SA
Date:   Mon, 17 May 2021 16:00:00 +0200
Message-Id: <20210517140307.712892198@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jinzhou Su <Jinzhou.Su@amd.com>

[ Upstream commit 5c88e3b86a88f14efa0a3ddd28641c6ff49fb9c4 ]

The buffer of SA bo will be used by many cases. So it's better
to invalidate the cache of indirect buffer allocated by SA before
commit the IB.

Signed-off-by: Jinzhou Su <Jinzhou.Su@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c
index 2f53fa0ae9a6..28f20f0b722f 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c
@@ -75,6 +75,8 @@ int amdgpu_ib_get(struct amdgpu_device *adev, struct amdgpu_vm *vm,
 		}
 
 		ib->ptr = amdgpu_sa_bo_cpu_addr(ib->sa_bo);
+		/* flush the cache before commit the IB */
+		ib->flags = AMDGPU_IB_FLAG_EMIT_MEM_SYNC;
 
 		if (!vm)
 			ib->gpu_addr = amdgpu_sa_bo_gpu_addr(ib->sa_bo);
-- 
2.30.2



