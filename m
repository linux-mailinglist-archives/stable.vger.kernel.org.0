Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50554257D6C
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 17:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728879AbgHaPhF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 11:37:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:40028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728660AbgHaPaa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 Aug 2020 11:30:30 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7FD32207EA;
        Mon, 31 Aug 2020 15:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598887830;
        bh=XeKscrXj7WbziYvkv0A54es1/smVegRQF/4zdzIrzso=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bctM+zbeIT2GqpIpva1JM4S8FHi2zoMdSjAYgsaN9AwFijvVS2ZQSBPmejsoQQCgt
         hXYwkqe98ZBjxpNc3L9rhwaGCPQUbVn9Wz++hNOcwSvW1c9I4VtcPyUXfR3FBXnKPF
         gzt0JLksnp3cCiyWGx9sEEnNOj6q5MpCW+/nrZDI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Samson Tam <Samson.Tam@amd.com>,
        Joshua Aberback <Joshua.Aberback@amd.com>,
        Eryk Brol <eryk.brol@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.8 37/42] drm/amd/display: Fix passive dongle mistaken as active dongle in EDID emulation
Date:   Mon, 31 Aug 2020 11:29:29 -0400
Message-Id: <20200831152934.1023912-37-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200831152934.1023912-1-sashal@kernel.org>
References: <20200831152934.1023912-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Samson Tam <Samson.Tam@amd.com>

[ Upstream commit efbde23a3b0164cef27fd394e7d548f46af5b51d ]

[Why]
dongle_type is set during dongle connection but for passive dongles,
dongle_type is not set. If user starts with an active dongle and
then switches to a passive dongle, it will still report as an active
dongle. Trying to emulate the wrong connecter type results in display
not lighting up.

[How]
Set dpcd_caps.dongle_type for passive dongles in detect_dp().

Signed-off-by: Samson Tam <Samson.Tam@amd.com>
Reviewed-by: Joshua Aberback <Joshua.Aberback@amd.com>
Acked-by: Eryk Brol <eryk.brol@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link.c b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
index bdddb46727b1f..885beb0bcc199 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
@@ -767,6 +767,7 @@ static bool detect_dp(struct dc_link *link,
 		sink_caps->signal = dp_passive_dongle_detection(link->ddc,
 								sink_caps,
 								audio_support);
+		link->dpcd_caps.dongle_type = sink_caps->dongle_type;
 	}
 
 	return true;
-- 
2.25.1

