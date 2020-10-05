Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9D17283847
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 16:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbgJEOp2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 10:45:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:52038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726627AbgJEOpN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 10:45:13 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE0512085B;
        Mon,  5 Oct 2020 14:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601909112;
        bh=y0U/F0YjnhoSfqzuWVCQ2N/yVFHQjp6Lc7MXTaRvUP4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GqYzLUGXAqmSOpGUWFayVgPPPPqTQEHTTVul661e7T9Y5gVUx9rX+uHhw9PZ9QApK
         /Fdw2BWG/bIyRXKxdnigHREWB2B7IiFF5I5wZaW1q/Z2V6iguN+JtyXkcI2HccIhRZ
         Ezo/TzVG5EoJQpvPQUVB9QUVc/nCqiQDK5qePMKk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Flora Cui <flora.cui@amd.com>, Feifei Xu <Feifei.Xu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.8 09/12] drm/amd/display: fix return value check for hdcp_work
Date:   Mon,  5 Oct 2020 10:44:57 -0400
Message-Id: <20201005144501.2527477-9-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201005144501.2527477-1-sashal@kernel.org>
References: <20201005144501.2527477-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Flora Cui <flora.cui@amd.com>

[ Upstream commit 898c7302f4de1d91065e80fc46552b3ec70894ff ]

max_caps might be 0, thus hdcp_work might be ZERO_SIZE_PTR

Signed-off-by: Flora Cui <flora.cui@amd.com>
Reviewed-by: Feifei Xu <Feifei.Xu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c
index 949d10ef83040..6dd1f3f8d9903 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c
@@ -568,7 +568,7 @@ struct hdcp_workqueue *hdcp_create_workqueue(struct amdgpu_device *adev, struct
 	int i = 0;
 
 	hdcp_work = kcalloc(max_caps, sizeof(*hdcp_work), GFP_KERNEL);
-	if (hdcp_work == NULL)
+	if (ZERO_OR_NULL_PTR(hdcp_work))
 		return NULL;
 
 	hdcp_work->srm = kcalloc(PSP_HDCP_SRM_FIRST_GEN_MAX_SIZE, sizeof(*hdcp_work->srm), GFP_KERNEL);
-- 
2.25.1

