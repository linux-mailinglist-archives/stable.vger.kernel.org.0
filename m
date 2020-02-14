Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 821A515EE09
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:38:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390065AbgBNQFD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:05:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:54140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390061AbgBNQFC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:05:02 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53E0C24676;
        Fri, 14 Feb 2020 16:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696302;
        bh=X/Dq+PeQjECF1L6QQ6O2t+J7BdtB35HFF99zLyDSSpU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c5//FEUUdEOm4ocBUA6+3JG3Ykk1+gUKU4flkoM6ZfgV0ENp38547niQGg3JU3Y81
         HW+Hq1kw6ss6oz5b4BShKWwGkzbW9y9vo3RDfmwfqMM2T9fH5nUynA9fRtBjPeDoqT
         ChiQpjnGxgKLJSiFb6leJEI2J8ogmDA5Iz234oSI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 5.4 146/459] drm/amdgpu: Ensure ret is always initialized when using SOC15_WAIT_ON_RREG
Date:   Fri, 14 Feb 2020 10:56:36 -0500
Message-Id: <20200214160149.11681-146-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

[ Upstream commit a63141e31764f8daf3f29e8e2d450dcf9199d1c8 ]

Commit b0f3cd3191cd ("drm/amdgpu: remove unnecessary JPEG2.0 code from
VCN2.0") introduced a new clang warning in the vcn_v2_0_stop function:

../drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c:1082:2: warning: variable 'r'
is used uninitialized whenever 'while' loop exits because its condition
is false [-Wsometimes-uninitialized]
        SOC15_WAIT_ON_RREG(VCN, 0, mmUVD_STATUS, UVD_STATUS__IDLE, 0x7, r);
        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
../drivers/gpu/drm/amd/amdgpu/../amdgpu/soc15_common.h:55:10: note:
expanded from macro 'SOC15_WAIT_ON_RREG'
                while ((tmp_ & (mask)) != (expected_value)) {   \
                       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
../drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c:1083:6: note: uninitialized use
occurs here
        if (r)
            ^
../drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c:1082:2: note: remove the
condition if it is always true
        SOC15_WAIT_ON_RREG(VCN, 0, mmUVD_STATUS, UVD_STATUS__IDLE, 0x7, r);
        ^
../drivers/gpu/drm/amd/amdgpu/../amdgpu/soc15_common.h:55:10: note:
expanded from macro 'SOC15_WAIT_ON_RREG'
                while ((tmp_ & (mask)) != (expected_value)) {   \
                       ^
../drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c:1072:7: note: initialize the
variable 'r' to silence this warning
        int r;
             ^
              = 0
1 warning generated.

To prevent warnings like this from happening in the future, make the
SOC15_WAIT_ON_RREG macro initialize its ret variable before the while
loop that can time out. This macro's return value is always checked so
it should set ret in both the success and fail path.

Link: https://github.com/ClangBuiltLinux/linux/issues/776
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/soc15_common.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/soc15_common.h b/drivers/gpu/drm/amd/amdgpu/soc15_common.h
index 839f186e1182a..19e870c798967 100644
--- a/drivers/gpu/drm/amd/amdgpu/soc15_common.h
+++ b/drivers/gpu/drm/amd/amdgpu/soc15_common.h
@@ -52,6 +52,7 @@
 		uint32_t old_ = 0;	\
 		uint32_t tmp_ = RREG32(adev->reg_offset[ip##_HWIP][inst][reg##_BASE_IDX] + reg); \
 		uint32_t loop = adev->usec_timeout;		\
+		ret = 0;					\
 		while ((tmp_ & (mask)) != (expected_value)) {	\
 			if (old_ != tmp_) {			\
 				loop = adev->usec_timeout;	\
-- 
2.20.1

