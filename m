Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9E8D49A3E8
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:04:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2369146AbiAYABF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:01:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1847016AbiAXXSP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:18:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07035C0604EB;
        Mon, 24 Jan 2022 13:25:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C2B10B81218;
        Mon, 24 Jan 2022 21:25:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F12A0C340E4;
        Mon, 24 Jan 2022 21:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059542;
        bh=yqSwJVXMzPmSYPIZURiBbJ026IA9VE5I3L1uFRkpvjU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NMJjnUd1tyn+EP3QLsF7pVs97o2cexlQt3C85OLh4KNb2ObbRpIw6L7RMbK+oqbGC
         4AeGa72zy4eNlXJSGcNFepc3ssBLpMmX4hpQNL4XvMImDbNcrTDcjQ0AIlmnctjTLp
         TvBk7uVNZI6YXYRVPyXbA8yi/Ev1IgVtgIAK1drw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Isabella Basso <isabbasso@riseup.net>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0649/1039] drm/amdgpu: fix amdgpu_ras_mca_query_error_status scope
Date:   Mon, 24 Jan 2022 19:40:38 +0100
Message-Id: <20220124184147.173655735@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



