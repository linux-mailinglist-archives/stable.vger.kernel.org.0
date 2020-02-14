Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03ADA15F1BE
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 19:08:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731726AbgBNPzQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 10:55:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:36142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731721AbgBNPzP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:55:15 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B07024681;
        Fri, 14 Feb 2020 15:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695715;
        bh=5jtGsCSjRRpD360ikcBkCoYPXgSmQEYS0wrNFktcNKQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZGFlOTcYvjDHSCq507f4c7DTSSJd/y1VNNugyc8z3Afbsu2yfPLCFbbCYSqZxghXM
         RNifatln/Z108Y54tSdI3ER3PKK/uycyjKpPJx0wPLGBB9K1Qvw24MdGfvfkFs6w3A
         rWyb95LnEOM5qcnxss8P/JdD6tDSgy564ZwdclBc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Felix Kuehling <Felix.Kuehling@amd.com>,
        shaoyunl <shaoyun.liu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.5 293/542] drm/amdkfd: Fix permissions of hang_hws
Date:   Fri, 14 Feb 2020 10:44:45 -0500
Message-Id: <20200214154854.6746-293-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Kuehling <Felix.Kuehling@amd.com>

[ Upstream commit 2bdac179e217a0c0b548a8c60524977586621b19 ]

Reading from /sys/kernel/debug/kfd/hang_hws would cause a kernel
oops because we didn't implement a read callback. Set the permission
to write-only to prevent that.

Signed-off-by: Felix Kuehling <Felix.Kuehling@amd.com>
Reviewed-by: shaoyunl  <shaoyun.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_debugfs.c b/drivers/gpu/drm/amd/amdkfd/kfd_debugfs.c
index 15c523027285c..511712c2e382d 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_debugfs.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_debugfs.c
@@ -93,7 +93,7 @@ void kfd_debugfs_init(void)
 			    kfd_debugfs_hqds_by_device, &kfd_debugfs_fops);
 	debugfs_create_file("rls", S_IFREG | 0444, debugfs_root,
 			    kfd_debugfs_rls_by_device, &kfd_debugfs_fops);
-	debugfs_create_file("hang_hws", S_IFREG | 0644, debugfs_root,
+	debugfs_create_file("hang_hws", S_IFREG | 0200, debugfs_root,
 			    NULL, &kfd_debugfs_hang_hws_fops);
 }
 
-- 
2.20.1

