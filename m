Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17489378650
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234845AbhEJLFV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:05:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:55456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232900AbhEJK5r (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:57:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B58526195A;
        Mon, 10 May 2021 10:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643935;
        bh=Ra4qf382GcJ+sV/uxHERuAFgydpX23OJscrYbfJkSQg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VMD1UyrPn1djPVJYTPef5aoRbIDVQMNpxY5l2EfOvtkcuJD/rew2TYEiNCSGH8Y0X
         5RIeUml+2NpMXYra7xD2IBgbUaPH84TgXTMy/3Rdajr2O9zCe43bcHuvuPmq40P+dv
         V+mUxPJvyo+stIfVBn9aOGdsfPxev+EliULoOu2s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Tom Rix <trix@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 221/342] amdgpu: avoid incorrect %hu format string
Date:   Mon, 10 May 2021 12:20:11 +0200
Message-Id: <20210510102017.396722301@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 7d98d416c2cc1c1f7d9508e887de4630e521d797 ]

clang points out that the %hu format string does not match the type
of the variables here:

drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c:263:7: warning: format specifies type 'unsigned short' but the argument has type 'unsigned int' [-Wformat]
                                  version_major, version_minor);
                                  ^~~~~~~~~~~~~
include/drm/drm_print.h:498:19: note: expanded from macro 'DRM_ERROR'
        __drm_err(fmt, ##__VA_ARGS__)
                  ~~~    ^~~~~~~~~~~

Change it to a regular %u, the same way a previous patch did for
another instance of the same warning.

Reviewed-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Tom Rix <trix@redhat.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c
index 8b989670ed66..431ae134a163 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c
@@ -259,7 +259,7 @@ int amdgpu_uvd_sw_init(struct amdgpu_device *adev)
 		if ((adev->asic_type == CHIP_POLARIS10 ||
 		     adev->asic_type == CHIP_POLARIS11) &&
 		    (adev->uvd.fw_version < FW_1_66_16))
-			DRM_ERROR("POLARIS10/11 UVD firmware version %hu.%hu is too old.\n",
+			DRM_ERROR("POLARIS10/11 UVD firmware version %u.%u is too old.\n",
 				  version_major, version_minor);
 	} else {
 		unsigned int enc_major, enc_minor, dec_minor;
-- 
2.30.2



