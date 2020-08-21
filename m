Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC2A624DE26
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 19:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728924AbgHUR0f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 13:26:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:46632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727115AbgHUQO6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Aug 2020 12:14:58 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A76DF208DB;
        Fri, 21 Aug 2020 16:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598026498;
        bh=I6GAMxGs19nNEZFk2dtb6Q6gWKmT1Q9GK98PIdZDL8M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t71XmGTMWorAKMlvU2DkvbhH3zGa8j/ULNb+2+xNDl4goFuIqBNOOJLVxj1y2Ky8n
         5VStx+JcSyMsNXPJBsMmuLbm+KUKgHvg34XCbpQdhCTNHex9IgMqkV0AC19zIvOauT
         qeAeOgLs4Dgj8DZKvQmZTrDe/Mnuizr6hjmAtHOQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alex Deucher <alexander.deucher@amd.com>,
        Rajneesh Bhardwaj <rajneesh.bhardwaj@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.8 28/62] drm/amdkfd: fix ref count leak when pm_runtime_get_sync fails
Date:   Fri, 21 Aug 2020 12:13:49 -0400
Message-Id: <20200821161423.347071-28-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200821161423.347071-1-sashal@kernel.org>
References: <20200821161423.347071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 1c1ada37af6ee6fb9cfc8da6a56cc83208cd8d6f ]

The call to pm_runtime_get_sync increments the counter even in case of
failure, leading to incorrect ref count.
In case of failure, decrement the ref count before returning.

Reviewed-by: Rajneesh Bhardwaj <rajneesh.bhardwaj@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_process.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_process.c b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
index 0e0c42e9f6a31..6520a920cad4a 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
@@ -1003,8 +1003,10 @@ struct kfd_process_device *kfd_bind_process_to_device(struct kfd_dev *dev,
 	 */
 	if (!pdd->runtime_inuse) {
 		err = pm_runtime_get_sync(dev->ddev->dev);
-		if (err < 0)
+		if (err < 0) {
+			pm_runtime_put_autosuspend(dev->ddev->dev);
 			return ERR_PTR(err);
+		}
 	}
 
 	err = kfd_iommu_bind_process_to_device(pdd);
-- 
2.25.1

