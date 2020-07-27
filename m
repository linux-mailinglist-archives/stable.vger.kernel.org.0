Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BAAF22EFFA
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730990AbgG0OUw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:20:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:49286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731616AbgG0OUv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:20:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BD962070B;
        Mon, 27 Jul 2020 14:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859651;
        bh=hieHIYOhvmEWOXDY2W3R6y6/9MZURkm3sq/GeG6V4qU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aOJbcQvPMN4extNowZ5rjnRESmCLc8+qwBGDqJyXEDCAAYZYMeuhG5dBj8Po3MtfP
         Err51WpFXq5ODqQsvVaDYNL7voAHmOyflD2gePttk+XsWVHdmOTJZomzw7NOzcyxeA
         cjrndvb4bd/J7El7IroqYk/YmZIopD1b3Ykpd9Pk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jerry (Fangzhi) Zuo" <Jerry.Zuo@amd.com>,
        Hersen Wu <hersenxs.wu@amd.com>,
        Aurabindo Pillai <aurabindo.pillai@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 022/179] drm/amd/display: Check DMCU Exists Before Loading
Date:   Mon, 27 Jul 2020 16:03:17 +0200
Message-Id: <20200727134933.751392896@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134932.659499757@linuxfoundation.org>
References: <20200727134932.659499757@linuxfoundation.org>
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
index d06fa63801799..7da2a22dbde7e 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1342,9 +1342,14 @@ static int dm_late_init(void *handle)
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



