Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E327BCD17
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 18:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2632932AbfIXQnM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 12:43:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:59870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2632926AbfIXQnL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Sep 2019 12:43:11 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07E7C20872;
        Tue, 24 Sep 2019 16:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569343391;
        bh=A3qVF/t/XRmO8w7bZv4r5d8T1Cv1im7d4XBZLdIQcVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s1qlPb8A5g9IPDkZ+D0SHbun0JVJfQLcIUclUr+Fd0+4+IKXi7kO9zehPCNa2VqKa
         R56KiOhuybAqToNiLStlHGG2vt9ThHjHFs+oQmFdMK+SbFE86JjzcNktpTNLvDdWeU
         wvMnPPK1uZFl+6GThBCVDMQVZCdGosk8GXlbpzuw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lewis Huang <Lewis.Huang@amd.com>, Jun Lei <Jun.Lei@amd.com>,
        Eric Yang <eric.yang2@amd.com>, Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.3 32/87] drm/amd/display: reprogram VM config when system resume
Date:   Tue, 24 Sep 2019 12:40:48 -0400
Message-Id: <20190924164144.25591-32-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190924164144.25591-1-sashal@kernel.org>
References: <20190924164144.25591-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lewis Huang <Lewis.Huang@amd.com>

[ Upstream commit e5382701c3520b3ed66169a6e4aa6ce5df8c56e0 ]

[Why]
The vm config will be clear to 0 when system enter S4. It will
cause hubbub didn't know how to fetch data when system resume.
The flip always pending because earliest_inuse_address and
request_address are different.

[How]
Reprogram VM config when system resume

Signed-off-by: Lewis Huang <Lewis.Huang@amd.com>
Reviewed-by: Jun Lei <Jun.Lei@amd.com>
Acked-by: Eric Yang <eric.yang2@amd.com>
Acked-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index cbc480a333764..730f97ba8dbbe 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -2187,6 +2187,14 @@ void dc_set_power_state(
 		dc_resource_state_construct(dc, dc->current_state);
 
 		dc->hwss.init_hw(dc);
+
+#ifdef CONFIG_DRM_AMD_DC_DCN2_0
+		if (dc->hwss.init_sys_ctx != NULL &&
+			dc->vm_pa_config.valid) {
+			dc->hwss.init_sys_ctx(dc->hwseq, dc, &dc->vm_pa_config);
+		}
+#endif
+
 		break;
 	default:
 		ASSERT(dc->current_state->stream_count == 0);
-- 
2.20.1

