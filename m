Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D32E417459
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346279AbhIXNFD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:05:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:33118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346177AbhIXNDB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 09:03:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDD8161378;
        Fri, 24 Sep 2021 12:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632488096;
        bh=jVCPuOo7/RvvFyuQRc2h4nEhQuGVZQvPPxT5ZpCDdQY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IL1DebVpppv3EsA4N0clJGnYKPCGXQPHHHjHZJV0QjiMOOQR1qmdXwai56P7glF+r
         tkcrTLzhZMh8yOG6iWbjSpT9n9HSNNq2vV14CQg4Zxm45jf08ncG9pUnNScss6CgQv
         tQq1HVcFmyDau4+bEOEpScEA+rj4+JCUQGBQ15Lo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Philip Yang <Philip.Yang@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 083/100] drm/amdgpu: fix fdinfo race with process exit
Date:   Fri, 24 Sep 2021 14:44:32 +0200
Message-Id: <20210924124344.247941751@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124341.214446495@linuxfoundation.org>
References: <20210924124341.214446495@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Philip Yang <Philip.Yang@amd.com>

[ Upstream commit d7eff46c214c036606dd3cd305bd5a128aecfe8c ]

Get process vm root BO ref in case process is exiting and root BO is
freed, to avoid NULL pointer dereference backtrace:

BUG: unable to handle kernel NULL pointer dereference at
0000000000000000
Call Trace:
amdgpu_show_fdinfo+0xfe/0x2a0 [amdgpu]
seq_show+0x12c/0x180
seq_read+0x153/0x410
vfs_read+0x91/0x140[ 3427.206183]  ksys_read+0x4f/0xb0
do_syscall_64+0x5b/0x1a0
entry_SYSCALL_64_after_hwframe+0x65/0xca

Signed-off-by: Philip Yang <Philip.Yang@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_fdinfo.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_fdinfo.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_fdinfo.c
index d94c5419ec25..5a6857c44bb6 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_fdinfo.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_fdinfo.c
@@ -59,6 +59,7 @@ void amdgpu_show_fdinfo(struct seq_file *m, struct file *f)
 	uint64_t vram_mem = 0, gtt_mem = 0, cpu_mem = 0;
 	struct drm_file *file = f->private_data;
 	struct amdgpu_device *adev = drm_to_adev(file->minor->dev);
+	struct amdgpu_bo *root;
 	int ret;
 
 	ret = amdgpu_file_to_fpriv(f, &fpriv);
@@ -69,13 +70,19 @@ void amdgpu_show_fdinfo(struct seq_file *m, struct file *f)
 	dev = PCI_SLOT(adev->pdev->devfn);
 	fn = PCI_FUNC(adev->pdev->devfn);
 
-	ret = amdgpu_bo_reserve(fpriv->vm.root.bo, false);
+	root = amdgpu_bo_ref(fpriv->vm.root.bo);
+	if (!root)
+		return;
+
+	ret = amdgpu_bo_reserve(root, false);
 	if (ret) {
 		DRM_ERROR("Fail to reserve bo\n");
 		return;
 	}
 	amdgpu_vm_get_memory(&fpriv->vm, &vram_mem, &gtt_mem, &cpu_mem);
-	amdgpu_bo_unreserve(fpriv->vm.root.bo);
+	amdgpu_bo_unreserve(root);
+	amdgpu_bo_unref(&root);
+
 	seq_printf(m, "pdev:\t%04x:%02x:%02x.%d\npasid:\t%u\n", domain, bus,
 			dev, fn, fpriv->vm.pasid);
 	seq_printf(m, "vram mem:\t%llu kB\n", vram_mem/1024UL);
-- 
2.33.0



