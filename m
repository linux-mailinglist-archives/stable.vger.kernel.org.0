Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15111426976
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 13:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241567AbhJHLh6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 07:37:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:59394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241599AbhJHLf5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 07:35:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7F9D6138F;
        Fri,  8 Oct 2021 11:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633692717;
        bh=3j7cRuwX8oE8k8wLA4cpV+B/YSxYbRpiZh1fi63kOl0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UJpA5Dfue3dDtk9HYtj+TOOHiGK2LEy2pQgM7s47XBA4X+n/9BJalWXyeXl0sk0nh
         mikJ07rtC6oRk7vhO7lEfnh5N+YmN2p8e2uqh8phHt0nzhUeWjDzPnbRO8MShsoEI/
         ae6/kizKyEMMDUiWsdwIMl5ewzzzA87bR+T0+UDE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Philip Yang <Philip.Yang@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 13/48] drm/amdkfd: handle svm migrate init error
Date:   Fri,  8 Oct 2021 13:27:49 +0200
Message-Id: <20211008112720.466324257@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211008112720.008415452@linuxfoundation.org>
References: <20211008112720.008415452@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Philip Yang <Philip.Yang@amd.com>

[ Upstream commit 7d6687200a939176847090bbde5cb79a82792a2f ]

If svm migration init failed to create pgmap for device memory, set
pgmap type to 0 to disable device SVM support capability.

Signed-off-by: Philip Yang <Philip.Yang@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
index dab290a4d19d..165e0ebb619d 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
@@ -894,6 +894,9 @@ int svm_migrate_init(struct amdgpu_device *adev)
 	r = devm_memremap_pages(adev->dev, pgmap);
 	if (IS_ERR(r)) {
 		pr_err("failed to register HMM device memory\n");
+
+		/* Disable SVM support capability */
+		pgmap->type = 0;
 		devm_release_mem_region(adev->dev, res->start,
 					res->end - res->start + 1);
 		return PTR_ERR(r);
-- 
2.33.0



