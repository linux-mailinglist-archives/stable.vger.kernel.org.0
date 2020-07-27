Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ABB022EF21
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730369AbgG0ONj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:13:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:38726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730393AbgG0ONi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:13:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18FB92073E;
        Mon, 27 Jul 2020 14:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859217;
        bh=n20vUVyaRvsUd/t9DuMuWWnuh8R37KmCQ7mLLzqKSB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xuxsxxtjuejGOAxLQTdtiCFiz8z6m+rIX0WILgnEdUHC9gzfVH+Mz8YPHhjenkyrZ
         +Q9nOcivAQ6JX22JgAPYpVb42uCcCjkCe2m7id91DiWY8NBQe0Hi8SR+JOjKnDgdvs
         +NvQPUHvXJmNhdRIhpI/9qwMPaX7fNJth1I3fHjc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jerry (Fangzhi) Zuo" <Jerry.Zuo@amd.com>,
        Hersen Wu <hersenxs.wu@amd.com>,
        Aurabindo Pillai <aurabindo.pillai@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 023/138] drm/amd/display: Check DMCU Exists Before Loading
Date:   Mon, 27 Jul 2020 16:03:38 +0200
Message-Id: <20200727134926.508432798@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134925.228313570@linuxfoundation.org>
References: <20200727134925.228313570@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jerry (Fangzhi) Zuo <Jerry.Zuo@amd.com>

[ Upstream commit 17bdb4a82fe5014c8aa5b2103c80c5729744a096 ]

Signed-off-by: Jerry (Fangzhi) Zuo <Jerry.Zuo@amd.com>
Reviewed-by: Hersen Wu <hersenxs.wu@amd.com>
Acked-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 4fad0b603b3ab..c7d8edf450d3c 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -928,9 +928,14 @@ static int dm_late_init(void *handle)
 	struct dmcu_iram_parameters params;
 	unsigned int linear_lut[16];
 	int i;
-	struct dmcu *dmcu = adev->dm.dc->res_pool->dmcu;
+	struct dmcu *dmcu = NULL;
 	bool ret;
 
+	if (!adev->dm.fw_dmcu)
+		return detect_mst_link_for_all_connectors(adev->ddev);
+
+	dmcu = adev->dm.dc->res_pool->dmcu;
+
 	for (i = 0; i < 16; i++)
 		linear_lut[i] = 0xFFFF * i / 15;
 
-- 
2.25.1



