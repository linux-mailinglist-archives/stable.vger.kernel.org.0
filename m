Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B886537CDE3
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343626AbhELQ7L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:59:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:33526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243579AbhELQlf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:41:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C94EB6143D;
        Wed, 12 May 2021 16:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835505;
        bh=+KpyCjVckXd3UguHZZZM+4+uIjQGnKRCcct75gRcjXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WnlrjJweUJf0b6buofDJw2/BnIlyA7UIaOWF4q1zrR6XhHYVn7bld3z9fgxpLEPyA
         TJNDwZBqPgLFqGXoBESa5kZznD/nljiskLLsoq8jC8iDeszLyO7ldsEoYAWTZPqLZN
         W92ezyjcaaDTHuXMuple/F2ruEXuWpCc/k3e1cIg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Kuehling <Felix.Kuehling@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 370/677] drm/amdkfd: Fix recursive lock warnings
Date:   Wed, 12 May 2021 16:46:56 +0200
Message-Id: <20210512144849.615096803@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Kuehling <Felix.Kuehling@amd.com>

[ Upstream commit 7816e4a98ce3bc7c562807240b4f14171e177420 ]

memalloc_nofs_save/restore are no longer sufficient to prevent recursive
lock warnings when holding locks that can be taken in MMU notifiers. Use
memalloc_noreclaim_save/restore instead.

Fixes: f920e413ff9c ("mm: track mmu notifiers in fs_reclaim_acquire/release")
Signed-off-by: Felix Kuehling <Felix.Kuehling@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
index adbfd1d227a5..a566bbe26bdd 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -92,13 +92,13 @@ struct amdgpu_prt_cb {
 static inline void amdgpu_vm_eviction_lock(struct amdgpu_vm *vm)
 {
 	mutex_lock(&vm->eviction_lock);
-	vm->saved_flags = memalloc_nofs_save();
+	vm->saved_flags = memalloc_noreclaim_save();
 }
 
 static inline int amdgpu_vm_eviction_trylock(struct amdgpu_vm *vm)
 {
 	if (mutex_trylock(&vm->eviction_lock)) {
-		vm->saved_flags = memalloc_nofs_save();
+		vm->saved_flags = memalloc_noreclaim_save();
 		return 1;
 	}
 	return 0;
@@ -106,7 +106,7 @@ static inline int amdgpu_vm_eviction_trylock(struct amdgpu_vm *vm)
 
 static inline void amdgpu_vm_eviction_unlock(struct amdgpu_vm *vm)
 {
-	memalloc_nofs_restore(vm->saved_flags);
+	memalloc_noreclaim_restore(vm->saved_flags);
 	mutex_unlock(&vm->eviction_lock);
 }
 
-- 
2.30.2



