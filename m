Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6F8C3CA632
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:44:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238189AbhGOSqh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:46:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:47996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238016AbhGOSqd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:46:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2515C613CA;
        Thu, 15 Jul 2021 18:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626374619;
        bh=nl0DIImT8XlHzu5yGB3APvkIojxXpccarwhQqQydqms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LycOKTYbGT5lA3+ER9I6XvadGC2ophKLP4ZtP4iVv4m18HbroNCwsjxSHkX1IxgPT
         ORS9miX2J27XDAgIG1B4C7LfSyzYmqwM9zXH4lb8AWX6/U70sG1g8h6sPo73lOn9qU
         cAkrmeBaLpa8gNlkW9BTWd80JvgqGXRpSJU+BzpQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vladimir Stempen <vladimir.stempen@amd.com>,
        Wenjing Liu <Wenjing.Liu@amd.com>,
        Stylon Wang <stylon.wang@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 033/122] drm/amd/display: Release MST resources on switch from MST to SST
Date:   Thu, 15 Jul 2021 20:38:00 +0200
Message-Id: <20210715182457.334338449@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182448.393443551@linuxfoundation.org>
References: <20210715182448.393443551@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Stempen <vladimir.stempen@amd.com>

[ Upstream commit 3f8518b60c10aa96f3efa38a967a0b4eb9211ac0 ]

[why]
When OS overrides training link training parameters
for MST device to SST mode, MST resources are not
released and leak of the resource may result crash and
incorrect MST discovery during following hot plugs.

[how]
Retaining sink object to be reused by SST link and
releasing MST  resources.

Signed-off-by: Vladimir Stempen <vladimir.stempen@amd.com>
Reviewed-by: Wenjing Liu <Wenjing.Liu@amd.com>
Acked-by: Stylon Wang <stylon.wang@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
index c18f39271b03..4bc95e9075e9 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
@@ -1284,6 +1284,8 @@ static void set_dp_mst_mode(struct dc_link *link, bool mst_enable)
 		link->type = dc_connection_single;
 		link->local_sink = link->remote_sinks[0];
 		link->local_sink->sink_signal = SIGNAL_TYPE_DISPLAY_PORT;
+		dc_sink_retain(link->local_sink);
+		dm_helpers_dp_mst_stop_top_mgr(link->ctx, link);
 	} else if (mst_enable == true &&
 			link->type == dc_connection_single &&
 			link->remote_sinks[0] != NULL) {
-- 
2.30.2



