Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51F4931BD2E
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:43:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230521AbhBOPlh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:41:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:49602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231621AbhBOPiG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:38:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 35D9564EEE;
        Mon, 15 Feb 2021 15:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613403244;
        bh=cxKqO7/u5wHEciAat0FsEJjw9iDvaNGyv4dBpPqcfIs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VpVeLQOJnyZ+Da7WJXhie9XnXmwMDsNcjW71JTDrmgpkt4i5Fh4qrSlErZ5pHn9H/
         zS6dXurBk7wCm7FTbjh9VFBo/LwQ+wO7OtmYEcC2yIj8N+DVoOEUVyuxyAPcSKTAZt
         S4/6r82oANSNuaWck7qg1pWpdx1XmHfWTAoAlRtc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Victor Lu <victorchengchi.lu@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Anson Jacob <Anson.Jacob@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 036/104] drm/amd/display: Decrement refcount of dc_sink before reassignment
Date:   Mon, 15 Feb 2021 16:26:49 +0100
Message-Id: <20210215152720.650614905@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152719.459796636@linuxfoundation.org>
References: <20210215152719.459796636@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Victor Lu <victorchengchi.lu@amd.com>

[ Upstream commit 8e92bb0fa75bca9a57e4aba2e36f67d8016a3053 ]

[why]
An old dc_sink state is causing a memory leak because it is missing a
dc_sink_release before a new dc_sink is assigned back to
aconnector->dc_sink.

[how]
Decrement the dc_sink refcount before reassigning it to a new dc_sink.

Signed-off-by: Victor Lu <victorchengchi.lu@amd.com>
Reviewed-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Acked-by: Anson Jacob <Anson.Jacob@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 321df20fcdb99..fdca76fc598c0 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -2261,8 +2261,10 @@ void amdgpu_dm_update_connector_after_detect(
 		 * TODO: check if we still need the S3 mode update workaround.
 		 * If yes, put it here.
 		 */
-		if (aconnector->dc_sink)
+		if (aconnector->dc_sink) {
 			amdgpu_dm_update_freesync_caps(connector, NULL);
+			dc_sink_release(aconnector->dc_sink);
+		}
 
 		aconnector->dc_sink = sink;
 		dc_sink_retain(aconnector->dc_sink);
-- 
2.27.0



