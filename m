Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A065313C42
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 19:05:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235367AbhBHSEe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 13:04:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:47380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235163AbhBHSAp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 13:00:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 94C9964EC7;
        Mon,  8 Feb 2021 17:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612807118;
        bh=QG+IXIvC27Sf/5lk1f9hJH/eFsjq66BiJ8/ljnlbw+s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iigNBqweQ2kDBpGMvj7p4mzcuwZrrTYo6YQT9nDGHF31jh1b/f6DL3qlCuKutpfU7
         Ll6/ltJrtCH5lGndE4UG9NFJe0WmSOSqPwqAEl3q7r9TMPReBh159L5RQvh7gywz6o
         Sjd73wiZBNzwCP4OJ9LMrEKOvHQcGkpUrYZBaW37hK9KEt0+YMBwyAM3wv7zms1XoO
         FN2EnpzbJ/4o3KKsh20BsGy++4pVzeRlxaj5Po1vkWW+nH78nEfyuZwqfTvL3dNayo
         RD5GVgCzW1vacpwQITnI6adfrkQOWZ6NpRyeqbCDtqJ4oiI+qh9pmRn/2dfm7qv9fG
         kIAw54A35Al8g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Victor Lu <victorchengchi.lu@amd.com>,
        Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
        Anson Jacob <Anson.Jacob@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 23/36] drm/amd/display: Fix dc_sink kref count in emulated_link_detect
Date:   Mon,  8 Feb 2021 12:57:53 -0500
Message-Id: <20210208175806.2091668-23-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210208175806.2091668-1-sashal@kernel.org>
References: <20210208175806.2091668-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Victor Lu <victorchengchi.lu@amd.com>

[ Upstream commit 3ddc818d9bb877c64f5c649beab97af86c403702 ]

[why]
prev_sink is not used anywhere else in the function and the reference to
it from dc_link is replaced with a new dc_sink.

[how]
Change dc_sink_retain(prev_sink) to dc_sink_release(prev_sink).

Signed-off-by: Victor Lu <victorchengchi.lu@amd.com>
Reviewed-by: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
Acked-by: Anson Jacob <Anson.Jacob@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 0f7749e9424d4..f1fea71a7073c 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1792,8 +1792,8 @@ static void emulated_link_detect(struct dc_link *link)
 	link->type = dc_connection_none;
 	prev_sink = link->local_sink;
 
-	if (prev_sink != NULL)
-		dc_sink_retain(prev_sink);
+	if (prev_sink)
+		dc_sink_release(prev_sink);
 
 	switch (link->connector_signal) {
 	case SIGNAL_TYPE_HDMI_TYPE_A: {
-- 
2.27.0

