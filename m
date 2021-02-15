Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A804231BCB9
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:36:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231428AbhBOPeR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:34:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:46646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231261AbhBOPcf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:32:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B1C964EA3;
        Mon, 15 Feb 2021 15:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613403003;
        bh=ytTvy+TUJ1gYbQDkwVCC94Pl9abxCe86fHci+vo4P8Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sxFzQ+UQY1pEhVAGvAp0OgEyH+ntBf8LyXi70m2ljEgqfk0zF6wz8Skc0oXCKGwxc
         N3jbstFUo3uiEyN4pUZghqeV3YggeVgY3LLyTkqnkLBTbLfxI/77cSc4lRy+dys6Gz
         fDq1S1hhpbW18EgEJ6QszNLEYrL1mRRt4thdxsLU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Victor Lu <victorchengchi.lu@amd.com>,
        Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
        Anson Jacob <Anson.Jacob@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 16/60] drm/amd/display: Fix dc_sink kref count in emulated_link_detect
Date:   Mon, 15 Feb 2021 16:27:04 +0100
Message-Id: <20210215152715.896134983@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152715.401453874@linuxfoundation.org>
References: <20210215152715.401453874@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index de06ee7d2ad46..3671b3e8f69d8 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1093,8 +1093,8 @@ static void emulated_link_detect(struct dc_link *link)
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



