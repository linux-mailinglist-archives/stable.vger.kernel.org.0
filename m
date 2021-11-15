Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 954DA4514A1
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:09:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345577AbhKOULO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 15:11:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:45220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344868AbhKOTZi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7EDB3636CE;
        Mon, 15 Nov 2021 19:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003156;
        bh=o8Ot4eci35NbDWFcwDugCgjSCRDuSajmX0NmyIJdENg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sy6obWBR4UoYXakPnH8ALhkRy2wC3fk2fKnK2b0y+zfQKxye8O7S4Eqf+Znt4M4Kw
         9XBhAX2lreGoeIRjVp0EPwTnYiFxsc/scGRpMI/lhAZB4iBzbshwzWV6HnAtgTbUFj
         W0Ux9+YUSG+HYFay+C9JJheLqoPqZC6AIpiTXVdc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 831/917] drm/amdgpu: fix uvd crash on Polaris12 during driver unloading
Date:   Mon, 15 Nov 2021 18:05:26 +0100
Message-Id: <20211115165457.228497430@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evan Quan <evan.quan@amd.com>

[ Upstream commit 4fc30ea780e0a5c1c019bc2e44f8523e1eed9051 ]

There was a change(below) target for such issue:
d82e2c249c8f ("drm/amdgpu: Fix crash on device remove/driver unload")
But the fix for VI ASICs was missing there. This is a supplement for
that.

Fixes: d82e2c249c8f ("drm/amdgpu: Fix crash on device remove/driver unload")

Signed-off-by: Evan Quan <evan.quan@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/uvd_v6_0.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/uvd_v6_0.c b/drivers/gpu/drm/amd/amdgpu/uvd_v6_0.c
index bc571833632ea..72f8762907681 100644
--- a/drivers/gpu/drm/amd/amdgpu/uvd_v6_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/uvd_v6_0.c
@@ -543,6 +543,19 @@ static int uvd_v6_0_hw_fini(void *handle)
 {
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
 
+	cancel_delayed_work_sync(&adev->uvd.idle_work);
+
+	if (RREG32(mmUVD_STATUS) != 0)
+		uvd_v6_0_stop(adev);
+
+	return 0;
+}
+
+static int uvd_v6_0_suspend(void *handle)
+{
+	int r;
+	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
+
 	/*
 	 * Proper cleanups before halting the HW engine:
 	 *   - cancel the delayed idle work
@@ -567,17 +580,6 @@ static int uvd_v6_0_hw_fini(void *handle)
 						       AMD_CG_STATE_GATE);
 	}
 
-	if (RREG32(mmUVD_STATUS) != 0)
-		uvd_v6_0_stop(adev);
-
-	return 0;
-}
-
-static int uvd_v6_0_suspend(void *handle)
-{
-	int r;
-	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
-
 	r = uvd_v6_0_hw_fini(adev);
 	if (r)
 		return r;
-- 
2.33.0



