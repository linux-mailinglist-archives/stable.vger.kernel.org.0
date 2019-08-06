Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A135283C46
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 23:42:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728745AbfHFVfy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 17:35:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:53678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728652AbfHFVfy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Aug 2019 17:35:54 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64A09217D9;
        Tue,  6 Aug 2019 21:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565127353;
        bh=sLYG0LYrflSu3iY1UZXemJUKsxG0IIDikOYOm9YDNvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KMMmFy8XC/J/tEMHtzMrhMXmTnLGjJ03h8RYOSRoFlKexginBnoG9E/ZU+jIS1rEJ
         mR3eiKZCAnUhSk7ezmdkt8hHtKAEOInUayDhQaJ4kuEcvbfxqP1idoh888lRfvbTyv
         i0LyxVjlJByMAhfSniJW+s8eyxeVMe6Ah8vgUnMA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wang Xiayang <xywang.sjtu@sjtu.edu.cn>,
        Chunming Zhou <david1.zhou@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 16/32] drm/amdgpu: fix a potential information leaking bug
Date:   Tue,  6 Aug 2019 17:35:04 -0400
Message-Id: <20190806213522.19859-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190806213522.19859-1-sashal@kernel.org>
References: <20190806213522.19859-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index f5fb93795a69a..65cecfdd9b454 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
@@ -707,7 +707,7 @@ static ssize_t amdgpu_debugfs_gpr_read(struct file *f, char __user *buf,
 	thread = (*pos & GENMASK_ULL(59, 52)) >> 52;
 	bank = (*pos & GENMASK_ULL(61, 60)) >> 60;
 
-	data = kmalloc_array(1024, sizeof(*data), GFP_KERNEL);
+	data = kcalloc(1024, sizeof(*data), GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
 
-- 
2.20.1

