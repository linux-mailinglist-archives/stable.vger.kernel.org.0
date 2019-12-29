Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E32612C551
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:41:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729852AbfL2RfZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:35:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:39664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729844AbfL2RfW (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:35:22 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0757207FF;
        Sun, 29 Dec 2019 17:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640922;
        bh=Y6wb9MOB1753wuANnE5dVfECKr08hB8NZ2DUOcT0f/Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xPLjUmyrncwM9lcckyw736ncLl5ilFBJPvRlMe5uPxoTLvZBS8MwkhL75XO/V+gf1
         PFEx+lPeWC8ksZVTBl+uaxhyqcSZRnaGlQLNNzmiOh3oMvi36sqkILX7X6OOQls75t
         PEB0+rxF2ASyCMt8HaYNaJiaUCZH5nvvtcEzsEVo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Colin Ian King <colin.king@canonical.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 194/219] drm/amdgpu: fix uninitialized variable pasid_mapping_needed
Date:   Sun, 29 Dec 2019 18:19:56 +0100
Message-Id: <20191229162539.154678416@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162508.458551679@linuxfoundation.org>
References: <20191229162508.458551679@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 17cf678a33c6196a3df4531fe5aec91384c9eeb5 ]

The boolean variable pasid_mapping_needed is not initialized and
there are code paths that do not assign it any value before it is
is read later.  Fix this by initializing pasid_mapping_needed to
false.

Addresses-Coverity: ("Uninitialized scalar variable")
Fixes: 6817bf283b2b ("drm/amdgpu: grab the id mgr lock while accessing passid_mapping")
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
index 69fb90d9c485..f67c332b16a4 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -701,7 +701,7 @@ int amdgpu_vm_flush(struct amdgpu_ring *ring, struct amdgpu_job *job, bool need_
 		id->oa_size != job->oa_size);
 	bool vm_flush_needed = job->vm_needs_flush;
 	struct dma_fence *fence = NULL;
-	bool pasid_mapping_needed;
+	bool pasid_mapping_needed = false;
 	unsigned patch_offset = 0;
 	int r;
 
-- 
2.20.1



