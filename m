Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36D1526F46A
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 05:14:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729814AbgIRDOU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 23:14:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:45804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726149AbgIRCBo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:01:44 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D006D2344C;
        Fri, 18 Sep 2020 02:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394497;
        bh=mqHT6RbFDr81GU1HO9Nq0bacZnanhKGb6BtrvhIrp9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IvLVT3Is1yc1uTUZ8/vrMTA7IRTAd6Ab2kOWqZI0YK5ba0ggEZTrJ08K5/Bcu3vNj
         f4gsVudJ/r4YCU/YiM1lCkC4fhjyl0N5gx5voOxl8cNi3eM6l2An1z4C4hABV+fPV1
         DojRC0NPKS4taOOklyCy47CozFcZBcC3ogHzNRig=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 022/330] drm/amd/display: Free gamma after calculating legacy transfer function
Date:   Thu, 17 Sep 2020 21:56:02 -0400
Message-Id: <20200918020110.2063155-22-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

[ Upstream commit 0e3a7c2ec93b15f43a2653e52e9608484391aeaf ]

[Why]
We're leaking memory by not freeing the gamma used to calculate the
transfer function for legacy gamma.

[How]
Release the gamma after we're done with it.

Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Reviewed-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_color.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_color.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_color.c
index b43bb7f90e4e9..2233d293a707a 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_color.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_color.c
@@ -210,6 +210,8 @@ static int __set_legacy_tf(struct dc_transfer_func *func,
 	res = mod_color_calculate_regamma_params(func, gamma, true, has_rom,
 						 NULL);
 
+	dc_gamma_release(&gamma);
+
 	return res ? 0 : -ENOMEM;
 }
 
-- 
2.25.1

