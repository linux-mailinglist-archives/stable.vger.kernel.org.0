Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E055CD5D4
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730305AbfJFRkQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:40:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:39804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730928AbfJFRkP (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:40:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC6C42053B;
        Sun,  6 Oct 2019 17:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383615;
        bh=A3qVF/t/XRmO8w7bZv4r5d8T1Cv1im7d4XBZLdIQcVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U2rBt73NvGGxBVujtVr3dQg4eHA2VlVktxjA9JrXJ0A4d1lPA3vpuqy0+LDTG2mV0
         IkyF4qVmhkS4raRFki3plxBXeIgEhYhwNtqlgAFeJmuXi2/iC6ixUT1+kumRwVGq3o
         b2c8sTBHKB0kFgkD2FgGjnWS2f83mPbMeuogPlX0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lewis Huang <Lewis.Huang@amd.com>,
        Jun Lei <Jun.Lei@amd.com>, Eric Yang <eric.yang2@amd.com>,
        Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 030/166] drm/amd/display: reprogram VM config when system resume
Date:   Sun,  6 Oct 2019 19:19:56 +0200
Message-Id: <20191006171215.544984636@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171212.850660298@linuxfoundation.org>
References: <20191006171212.850660298@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



