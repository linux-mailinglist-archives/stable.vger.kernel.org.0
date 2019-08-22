Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70CD999AA2
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732940AbfHVROl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:14:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:58780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390540AbfHVRIv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:08:51 -0400
Received: from sasha-vm.mshome.net (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3018D233FD;
        Thu, 22 Aug 2019 17:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566493730;
        bh=5ZvQzk9R5TI5bGpVv5L8Rn41Krgjr3O3/iejLxZa8a0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u9LJUX1nOlZDzvvaLjWBLa7COjFlVHJWgsiswP37Se8O5M3NP0/7B3rydRqJojLli
         RO1Z48p3xXn0+cjtsaGreIxDmkoKoTesph3BarCdT2AsoCTj/Tj2GZS/q+U1a5p6Oc
         zfvTmoCmV2BsLpGNxKAi/NcvsIwUNBB11vzHRinA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wang Xiayang <xywang.sjtu@sjtu.edu.cn>,
        Chunming Zhou <david1.zhou@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 066/135] drm/amdgpu: fix a potential information leaking bug
Date:   Thu, 22 Aug 2019 13:07:02 -0400
Message-Id: <20190822170811.13303-67-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190822170811.13303-1-sashal@kernel.org>
References: <20190822170811.13303-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.2.10-rc1
X-KernelTest-Deadline: 2019-08-24T17:07+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Xiayang <xywang.sjtu@sjtu.edu.cn>

[ Upstream commit 929e571c04c285861e0bb049a396a2bdaea63282 ]

Coccinelle reports a path that the array "data" is never initialized.
The path skips the checks in the conditional branches when either
of callback functions, read_wave_vgprs and read_wave_sgprs, is not
registered. Later, the uninitialized "data" array is read
in the while-loop below and passed to put_user().

Fix the path by allocating the array with kcalloc().

The patch is simplier than adding a fall-back branch that explicitly
calls memset(data, 0, ...). Also it does not need the multiplication
1024*sizeof(*data) as the size parameter for memset() though there is
no risk of integer overflow.

Signed-off-by: Wang Xiayang <xywang.sjtu@sjtu.edu.cn>
Reviewed-by: Chunming Zhou <david1.zhou@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
index 8930d66f22040..91bfb24f963e5 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
@@ -703,7 +703,7 @@ static ssize_t amdgpu_debugfs_gpr_read(struct file *f, char __user *buf,
 	thread = (*pos & GENMASK_ULL(59, 52)) >> 52;
 	bank = (*pos & GENMASK_ULL(61, 60)) >> 60;
 
-	data = kmalloc_array(1024, sizeof(*data), GFP_KERNEL);
+	data = kcalloc(1024, sizeof(*data), GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
 
-- 
2.20.1

