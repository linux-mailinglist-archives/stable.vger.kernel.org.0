Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46B212469FD
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:28:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730021AbgHQP2n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:28:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:44016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729542AbgHQP2f (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:28:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B32923AFE;
        Mon, 17 Aug 2020 15:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678115;
        bh=xdoyQXyF72FtUFPSXhWHvSJWOV8YBtDyng3jIj+DsCE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YIMe0Kz1HhRzwaYzk2e6AaCc4IRMiy1rVHLhJRu3oTSgievMvAb91DO9TiN2RzDG+
         U7zXg3xoS+n+16YAzo3Ut963rs/SfIGzC6pbClKnY1yxhaAynvvSpCRhaNpYel8k68
         n/UxmmAhzVc9nKTTenBo1ceqphFF+WEP7y3OJzm8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen Tao <chentao107@huawei.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 193/464] drm/amdgpu/debugfs: fix memory leak when amdgpu_virt_enable_access_debugfs failed
Date:   Mon, 17 Aug 2020 17:12:26 +0200
Message-Id: <20200817143843.068083865@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen Tao <chentao107@huawei.com>

[ Upstream commit 888e32d71115e26b57bdcbc717c68e9c5026bac3 ]

Fix memory leak in amdgpu_debugfs_gpr_read not freeing data when
amdgpu_virt_enable_access_debugfs failed.

Fixes: 95a2f917387a2 ("drm/amdgpu: restrict debugfs register access under SR-IOV")
Signed-off-by: Chen Tao <chentao107@huawei.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
index 386b979e08522..f87b225437fc3 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
@@ -977,7 +977,7 @@ static ssize_t amdgpu_debugfs_gpr_read(struct file *f, char __user *buf,
 
 	r = amdgpu_virt_enable_access_debugfs(adev);
 	if (r < 0)
-		return r;
+		goto err;
 
 	/* switch to the specific se/sh/cu */
 	mutex_lock(&adev->grbm_idx_mutex);
-- 
2.25.1



