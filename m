Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F39BC4124DF
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353405AbhITSix (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:38:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:53086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1380310AbhITSgY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:36:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8149661ABF;
        Mon, 20 Sep 2021 17:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158966;
        bh=dJnGI+Fwo3WcJ1J/hbpXq6jVSQ53sXUs1BAejSqkMDI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sM0Hst99L0g2glQ5SD2YqXgAkk8ZKapr8Tw23wqUkJwtIAPk6SS3hUAYVt13CJYnk
         MQqP2PIMKqbg9wsFmJgP06nxme2IeQJ0Va0h+lFJ3gDIRwZntmlz/GkyFBCx2yBHMa
         Bpsb9M8F/rDWdQKriHzQFl5cojx7rjBk/3/q+/Cw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nirmoy Das <nirmoy.das@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Shashank Sharma <shashank.sharma@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.14 015/168] drm/amdgpu: use IS_ERR for debugfs APIs
Date:   Mon, 20 Sep 2021 18:42:33 +0200
Message-Id: <20210920163922.149344220@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nirmoy Das <nirmoy.das@amd.com>

commit b04ce53eac2fc326290817a6f64a440b5bffd2e3 upstream.

debugfs APIs returns encoded error so use
IS_ERR for checking return value.

v2: return PTR_ERR(ent)

Signed-off-by: Nirmoy Das <nirmoy.das@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Reviewed-By: Shashank Sharma <shashank.sharma@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c |   10 ++++------
 drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c    |    4 ++--
 2 files changed, 6 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
@@ -1544,20 +1544,18 @@ int amdgpu_debugfs_init(struct amdgpu_de
 	struct dentry *ent;
 	int r, i;
 
-
-
 	ent = debugfs_create_file("amdgpu_preempt_ib", 0600, root, adev,
 				  &fops_ib_preempt);
-	if (!ent) {
+	if (IS_ERR(ent)) {
 		DRM_ERROR("unable to create amdgpu_preempt_ib debugsfs file\n");
-		return -EIO;
+		return PTR_ERR(ent);
 	}
 
 	ent = debugfs_create_file("amdgpu_force_sclk", 0200, root, adev,
 				  &fops_sclk_set);
-	if (!ent) {
+	if (IS_ERR(ent)) {
 		DRM_ERROR("unable to create amdgpu_set_sclk debugsfs file\n");
-		return -EIO;
+		return PTR_ERR(ent);
 	}
 
 	/* Register debugfs entries for amdgpu_ttm */
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c
@@ -428,8 +428,8 @@ int amdgpu_debugfs_ring_init(struct amdg
 	ent = debugfs_create_file(name,
 				  S_IFREG | S_IRUGO, root,
 				  ring, &amdgpu_debugfs_ring_fops);
-	if (!ent)
-		return -ENOMEM;
+	if (IS_ERR(ent))
+		return PTR_ERR(ent);
 
 	i_size_write(ent->d_inode, ring->ring_size + 12);
 	ring->ent = ent;


