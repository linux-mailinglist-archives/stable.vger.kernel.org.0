Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E32BE99B92
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404496AbfHVRZr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:25:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:49862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404488AbfHVRZp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:25:45 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E44FC2341E;
        Thu, 22 Aug 2019 17:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494745;
        bh=fgkm7WAJnjMm0e9zjgQqZSf3/wt/5O1q3IEJNndBPfE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tmbg3ZNHqawmIogiU6UY04D3j3H4A/az1J79zbySAq5jtuVj/koeb32izdOyQYHHJ
         GWEfAFVJMMQEitjdSwSDXKvgEyY9Uo34X83YoAHj2xvIh6Mrg59zQJF92VKKZ7sN9Q
         HGs7q25DfOLw2QQVF1kswFVBAwrfFzziLeGUIjrw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wang Xiayang <xywang.sjtu@sjtu.edu.cn>,
        Chunming Zhou <david1.zhou@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 39/85] drm/amdgpu: fix a potential information leaking bug
Date:   Thu, 22 Aug 2019 10:19:12 -0700
Message-Id: <20190822171733.010185705@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171731.012687054@linuxfoundation.org>
References: <20190822171731.012687054@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



