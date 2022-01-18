Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4339F491571
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:28:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245499AbiARC2M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:28:12 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43186 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245589AbiARC0J (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:26:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2690260C95;
        Tue, 18 Jan 2022 02:26:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2CABC36AE3;
        Tue, 18 Jan 2022 02:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472768;
        bh=yqSwJVXMzPmSYPIZURiBbJ026IA9VE5I3L1uFRkpvjU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lDBz/6MvTvAoJF2vOspQ0CZY325ZVQaeEpqUewId82kG27GRrpcq7l2O0qPH93t/k
         SWvHLvKABmDNNI391ghVeCuD3PnLCKU0sT2sEMNBq7/neSgynYbFybxINlswu8VYmG
         YhBlbXn//cPNE+CNxXDVKLpFYNsQlAi2JFcbXkkBrHhklnv48MXgbenhfglCukELmQ
         JXcCNGBN08AbqrDrCTAsY5HNxbZdHsqbJ1mnb9CC7JbM9aamX+bsHRmWdM5GznSJSB
         ZYIdFvP3h7lh6pUbVjqiFZNG7ZvUBo1hrpLPbttxc754X5sfKrQCDcT/Qre6YZi2At
         DCfKs+s6fN6xA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Isabella Basso <isabbasso@riseup.net>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        Hawking.Zhang@amd.com, john.clements@amd.com, luben.tuikov@amd.com,
        Dennis.Li@amd.com, Stanley.Yang@amd.com, mukul.joshi@amd.com,
        nirmoy.das@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.16 131/217] drm/amdgpu: fix amdgpu_ras_mca_query_error_status scope
Date:   Mon, 17 Jan 2022 21:18:14 -0500
Message-Id: <20220118021940.1942199-131-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Isabella Basso <isabbasso@riseup.net>

[ Upstream commit 929bb8e200412da36aca4b61209ec26283f9c184 ]

This commit fixes the compile-time warning below:

 warning: no previous prototype for ‘amdgpu_ras_mca_query_error_status’
 [-Wmissing-prototypes]

Changes since v1:
- As suggested by Alexander Deucher:
  1. Make function static instead of adding prototype.

Signed-off-by: Isabella Basso <isabbasso@riseup.net>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
index 08133de21fdd6..26b7a4a0b44b7 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
@@ -867,9 +867,9 @@ static int amdgpu_ras_enable_all_features(struct amdgpu_device *adev,
 /* feature ctl end */
 
 
-void amdgpu_ras_mca_query_error_status(struct amdgpu_device *adev,
-				       struct ras_common_if *ras_block,
-				       struct ras_err_data  *err_data)
+static void amdgpu_ras_mca_query_error_status(struct amdgpu_device *adev,
+					      struct ras_common_if *ras_block,
+					      struct ras_err_data  *err_data)
 {
 	switch (ras_block->sub_block_index) {
 	case AMDGPU_RAS_MCA_BLOCK__MP0:
-- 
2.34.1

