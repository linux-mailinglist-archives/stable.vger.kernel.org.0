Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 861E32F5A9
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728579AbfE3EtL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:49:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:50232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728425AbfE3DLO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:11:14 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81CE4244E6;
        Thu, 30 May 2019 03:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185873;
        bh=jYzDwC7GtsN77ay9dC5WCV3Ym8aKwuHHWzw2Lx0m6vE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l/8Erduz98v7x7b2Tkz5o95UJarGsIBbGIiGsHRst0rP+kizmTK04GQO1B/lK3EXh
         HGuwqfItHB9VpGGKthXK7RMmKxuyXddXVXKuIMq10Tl28AsNsYNxuVfsi5YtqWtE90
         EK9AmgDgGQX1X2GpeMl0v/Zf4IaVcCk/lCjwPP6k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sun peng Li <Sunpeng.Li@amd.com>,
        Harry Wentland <Harry.Wentland@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 217/405] drm/amd/display: Initialize stream_update with memset
Date:   Wed, 29 May 2019 20:03:35 -0700
Message-Id: <20190530030552.064780213@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 2aa632c5ffbedb2ee0e68857683466ea788f17eb ]

The brace initialization used here generates warnings on some
compilers. For example, on GCC 4.9:

[...] In function ‘dm_determine_update_type_for_commit’:
[...] error: missing braces around initializer [-Werror=missing-braces]
   struct dc_stream_update stream_update = { 0 };
          ^

Use memset to make this more portable.

v2: Specify the compiler / diagnostic in the commit message (Paul)

Cc: Sun peng Li <Sunpeng.Li@amd.com>
Cc: Harry Wentland <Harry.Wentland@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Reviewed-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 3082b55b1e774..66f19d1864b17 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -5858,7 +5858,9 @@ dm_determine_update_type_for_commit(struct dc *dc,
 	}
 
 	for_each_oldnew_crtc_in_state(state, crtc, old_crtc_state, new_crtc_state, i) {
-		struct dc_stream_update stream_update = { 0 };
+		struct dc_stream_update stream_update;
+
+		memset(&stream_update, 0, sizeof(stream_update));
 
 		new_dm_crtc_state = to_dm_crtc_state(new_crtc_state);
 		old_dm_crtc_state = to_dm_crtc_state(old_crtc_state);
-- 
2.20.1



