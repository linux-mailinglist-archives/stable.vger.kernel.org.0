Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B24B23A0371
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237456AbhFHTRA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:17:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:38996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238414AbhFHTO4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:14:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E610061467;
        Tue,  8 Jun 2021 18:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623178226;
        bh=/TP5nYJ4HyxCrCMaY6p0KHNwF6cbf8MV53uNimr1lCg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lFjddGJAHrj/L5E4UoUot5V7APMn8iKB3tmYWx3ZpI3JHzvcVeZ/DF2YXYKxeBCFT
         9N+Zn09gg/xWd3ZcYiAiWSXPh6OnClitvrNSgKoIQrldokdzMIvTqA7xqJEJmfzjUS
         R42GWEknoiLDxwcVGBDc140gQXb3OhHRRp5kEVrk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Zhu <James.Zhu@amd.com>,
        Leo Liu <leo.liu@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 089/161] drm/amdgpu/vcn3: add cancel_delayed_work_sync before power gate
Date:   Tue,  8 Jun 2021 20:26:59 +0200
Message-Id: <20210608175948.444152748@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Zhu <James.Zhu@amd.com>

[ Upstream commit 4a62542ae064e3b645d6bbf2295a6c05136956c6 ]

Add cancel_delayed_work_sync before set power gating state
to avoid race condition issue when power gating.

Signed-off-by: James Zhu <James.Zhu@amd.com>
Reviewed-by: Leo Liu <leo.liu@amd.com>
Acked-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c b/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
index ebbc04ff5da0..90138469648a 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
@@ -367,15 +367,14 @@ done:
 static int vcn_v3_0_hw_fini(void *handle)
 {
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
-	struct amdgpu_ring *ring;
 	int i;
 
+	cancel_delayed_work_sync(&adev->vcn.idle_work);
+
 	for (i = 0; i < adev->vcn.num_vcn_inst; ++i) {
 		if (adev->vcn.harvest_config & (1 << i))
 			continue;
 
-		ring = &adev->vcn.inst[i].ring_dec;
-
 		if (!amdgpu_sriov_vf(adev)) {
 			if ((adev->pg_flags & AMD_PG_SUPPORT_VCN_DPG) ||
 					(adev->vcn.cur_state != AMD_PG_STATE_GATE &&
-- 
2.30.2



