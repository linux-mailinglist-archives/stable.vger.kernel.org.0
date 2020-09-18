Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFAED26F47D
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 05:15:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726405AbgIRCBb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:01:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:45484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725886AbgIRCBW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:01:22 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B83F4221EC;
        Fri, 18 Sep 2020 02:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394481;
        bh=2ePOCGhTBbd+lf3klGu5cpPtvt56Zre95M+kXMDM/ng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vk6tsTUTU4FSL/cDE0LWp7CpoGNIvPAV+3RsPbt1xJtJoZs4txkI4bZwLcA+7GEh1
         lzhwT9FZhyXx2EnHZHgQLUwGh5rQaAhf6DBrATNTJFLffyUwJPImy/gLmdo/NUEPBm
         VnKuGsUCVG38cUlGvDUGGoBha6hwBUsRJsQoq4cc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jay Cornwall <jay.cornwall@amd.com>, Yong Zhao <Yong.Zhao@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 008/330] drm/amdkfd: Fix race in gfx10 context restore handler
Date:   Thu, 17 Sep 2020 21:55:48 -0400
Message-Id: <20200918020110.2063155-8-sashal@kernel.org>
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

From: Jay Cornwall <jay.cornwall@amd.com>

[ Upstream commit c18cc2bb9e064d3a613d8276f2cab3984926a779 ]

Missing synchronization with VGPR restore leads to intermittent
VGPR trashing in the user shader.

Signed-off-by: Jay Cornwall <jay.cornwall@amd.com>
Reviewed-by: Yong Zhao <Yong.Zhao@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/amdkfd/cwsr_trap_handler.h    | 139 +++++++++---------
 .../amd/amdkfd/cwsr_trap_handler_gfx10.asm    |   1 +
 2 files changed, 71 insertions(+), 69 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/cwsr_trap_handler.h b/drivers/gpu/drm/amd/amdkfd/cwsr_trap_handler.h
index 901fe35901656..d3400da6ab643 100644
--- a/drivers/gpu/drm/amd/amdkfd/cwsr_trap_handler.h
+++ b/drivers/gpu/drm/amd/amdkfd/cwsr_trap_handler.h
@@ -905,7 +905,7 @@ static const uint32_t cwsr_trap_gfx10_hex[] = {
 	0x7a5d0000, 0x807c817c,
 	0x807aff7a, 0x00000080,
 	0xbf0a717c, 0xbf85fff8,
-	0xbf820141, 0xbef4037e,
+	0xbf820142, 0xbef4037e,
 	0x8775ff7f, 0x0000ffff,
 	0x8875ff75, 0x00040000,
 	0xbef60380, 0xbef703ff,
@@ -967,7 +967,7 @@ static const uint32_t cwsr_trap_gfx10_hex[] = {
 	0x725d0000, 0xe0304080,
 	0x725d0100, 0xe0304100,
 	0x725d0200, 0xe0304180,
-	0x725d0300, 0xbf820031,
+	0x725d0300, 0xbf820032,
 	0xbef603ff, 0x01000000,
 	0xbef20378, 0x8078ff78,
 	0x00000400, 0xbefc0384,
@@ -992,83 +992,84 @@ static const uint32_t cwsr_trap_gfx10_hex[] = {
 	0x725d0000, 0xe0304100,
 	0x725d0100, 0xe0304200,
 	0x725d0200, 0xe0304300,
-	0x725d0300, 0xb9782a05,
-	0x80788178, 0x907c9973,
-	0x877c817c, 0xbf06817c,
-	0xbf850002, 0x8f788978,
-	0xbf820001, 0x8f788a78,
-	0xb9721e06, 0x8f728a72,
-	0x80787278, 0x8078ff78,
-	0x00000200, 0x80f8ff78,
-	0x00000050, 0xbef603ff,
-	0x01000000, 0xbefc03ff,
-	0x0000006c, 0x80f89078,
-	0xf429003a, 0xf0000000,
-	0xbf8cc07f, 0x80fc847c,
-	0xbf800000, 0xbe803100,
-	0xbe823102, 0x80f8a078,
-	0xf42d003a, 0xf0000000,
-	0xbf8cc07f, 0x80fc887c,
-	0xbf800000, 0xbe803100,
-	0xbe823102, 0xbe843104,
-	0xbe863106, 0x80f8c078,
-	0xf431003a, 0xf0000000,
-	0xbf8cc07f, 0x80fc907c,
-	0xbf800000, 0xbe803100,
-	0xbe823102, 0xbe843104,
-	0xbe863106, 0xbe883108,
-	0xbe8a310a, 0xbe8c310c,
-	0xbe8e310e, 0xbf06807c,
-	0xbf84fff0, 0xb9782a05,
-	0x80788178, 0x907c9973,
-	0x877c817c, 0xbf06817c,
-	0xbf850002, 0x8f788978,
-	0xbf820001, 0x8f788a78,
-	0xb9721e06, 0x8f728a72,
-	0x80787278, 0x8078ff78,
-	0x00000200, 0xbef603ff,
-	0x01000000, 0xf4211bfa,
+	0x725d0300, 0xbf8c3f70,
+	0xb9782a05, 0x80788178,
+	0x907c9973, 0x877c817c,
+	0xbf06817c, 0xbf850002,
+	0x8f788978, 0xbf820001,
+	0x8f788a78, 0xb9721e06,
+	0x8f728a72, 0x80787278,
+	0x8078ff78, 0x00000200,
+	0x80f8ff78, 0x00000050,
+	0xbef603ff, 0x01000000,
+	0xbefc03ff, 0x0000006c,
+	0x80f89078, 0xf429003a,
+	0xf0000000, 0xbf8cc07f,
+	0x80fc847c, 0xbf800000,
+	0xbe803100, 0xbe823102,
+	0x80f8a078, 0xf42d003a,
+	0xf0000000, 0xbf8cc07f,
+	0x80fc887c, 0xbf800000,
+	0xbe803100, 0xbe823102,
+	0xbe843104, 0xbe863106,
+	0x80f8c078, 0xf431003a,
+	0xf0000000, 0xbf8cc07f,
+	0x80fc907c, 0xbf800000,
+	0xbe803100, 0xbe823102,
+	0xbe843104, 0xbe863106,
+	0xbe883108, 0xbe8a310a,
+	0xbe8c310c, 0xbe8e310e,
+	0xbf06807c, 0xbf84fff0,
+	0xb9782a05, 0x80788178,
+	0x907c9973, 0x877c817c,
+	0xbf06817c, 0xbf850002,
+	0x8f788978, 0xbf820001,
+	0x8f788a78, 0xb9721e06,
+	0x8f728a72, 0x80787278,
+	0x8078ff78, 0x00000200,
+	0xbef603ff, 0x01000000,
+	0xf4211bfa, 0xf0000000,
+	0x80788478, 0xf4211b3a,
 	0xf0000000, 0x80788478,
-	0xf4211b3a, 0xf0000000,
-	0x80788478, 0xf4211b7a,
+	0xf4211b7a, 0xf0000000,
+	0x80788478, 0xf4211eba,
 	0xf0000000, 0x80788478,
-	0xf4211eba, 0xf0000000,
-	0x80788478, 0xf4211efa,
+	0xf4211efa, 0xf0000000,
+	0x80788478, 0xf4211c3a,
 	0xf0000000, 0x80788478,
-	0xf4211c3a, 0xf0000000,
-	0x80788478, 0xf4211c7a,
+	0xf4211c7a, 0xf0000000,
+	0x80788478, 0xf4211e7a,
 	0xf0000000, 0x80788478,
-	0xf4211e7a, 0xf0000000,
-	0x80788478, 0xf4211cfa,
+	0xf4211cfa, 0xf0000000,
+	0x80788478, 0xf4211bba,
 	0xf0000000, 0x80788478,
+	0xbf8cc07f, 0xb9eef814,
 	0xf4211bba, 0xf0000000,
 	0x80788478, 0xbf8cc07f,
-	0xb9eef814, 0xf4211bba,
-	0xf0000000, 0x80788478,
-	0xbf8cc07f, 0xb9eef815,
-	0xbef2036d, 0x876dff72,
-	0x0000ffff, 0xbefc036f,
-	0xbefe037a, 0xbeff037b,
-	0x876f71ff, 0x000003ff,
-	0xb9ef4803, 0xb9f9f816,
-	0x876f71ff, 0xfffff800,
-	0x906f8b6f, 0xb9efa2c3,
-	0xb9f3f801, 0x876fff72,
-	0xfc000000, 0x906f9a6f,
-	0x8f6f906f, 0xbef30380,
+	0xb9eef815, 0xbef2036d,
+	0x876dff72, 0x0000ffff,
+	0xbefc036f, 0xbefe037a,
+	0xbeff037b, 0x876f71ff,
+	0x000003ff, 0xb9ef4803,
+	0xb9f9f816, 0x876f71ff,
+	0xfffff800, 0x906f8b6f,
+	0xb9efa2c3, 0xb9f3f801,
+	0x876fff72, 0xfc000000,
+	0x906f9a6f, 0x8f6f906f,
+	0xbef30380, 0x88736f73,
+	0x876fff72, 0x02000000,
+	0x906f996f, 0x8f6f8f6f,
 	0x88736f73, 0x876fff72,
-	0x02000000, 0x906f996f,
-	0x8f6f8f6f, 0x88736f73,
-	0x876fff72, 0x01000000,
-	0x906f986f, 0x8f6f996f,
-	0x88736f73, 0x876fff70,
-	0x00800000, 0x906f976f,
-	0xb9f3f807, 0x87fe7e7e,
-	0x87ea6a6a, 0xb9f0f802,
-	0xbf8a0000, 0xbe80226c,
-	0xbf810000, 0xbf9f0000,
+	0x01000000, 0x906f986f,
+	0x8f6f996f, 0x88736f73,
+	0x876fff70, 0x00800000,
+	0x906f976f, 0xb9f3f807,
+	0x87fe7e7e, 0x87ea6a6a,
+	0xb9f0f802, 0xbf8a0000,
+	0xbe80226c, 0xbf810000,
 	0xbf9f0000, 0xbf9f0000,
 	0xbf9f0000, 0xbf9f0000,
+	0xbf9f0000, 0x00000000,
 };
 static const uint32_t cwsr_trap_arcturus_hex[] = {
 	0xbf820001, 0xbf8202c4,
diff --git a/drivers/gpu/drm/amd/amdkfd/cwsr_trap_handler_gfx10.asm b/drivers/gpu/drm/amd/amdkfd/cwsr_trap_handler_gfx10.asm
index cdaa523ce6bee..4433bda2ce25e 100644
--- a/drivers/gpu/drm/amd/amdkfd/cwsr_trap_handler_gfx10.asm
+++ b/drivers/gpu/drm/amd/amdkfd/cwsr_trap_handler_gfx10.asm
@@ -758,6 +758,7 @@ L_RESTORE_V0:
 	buffer_load_dword	v1, v0, s_restore_buf_rsrc0, s_restore_mem_offset_save slc:1 glc:1 offset:256
 	buffer_load_dword	v2, v0, s_restore_buf_rsrc0, s_restore_mem_offset_save slc:1 glc:1 offset:256*2
 	buffer_load_dword	v3, v0, s_restore_buf_rsrc0, s_restore_mem_offset_save slc:1 glc:1 offset:256*3
+	s_waitcnt	vmcnt(0)
 
 	/* restore SGPRs */
 	//will be 2+8+16*6
-- 
2.25.1

