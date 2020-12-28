Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 641CC2E3BF6
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:57:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406658AbgL1N4r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:56:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:58378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406605AbgL1N4n (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:56:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88C442072C;
        Mon, 28 Dec 2020 13:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163763;
        bh=rtXe47oXIk8fyQqWal2ZIsT7HCmvbt9xl6J7butPMqk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uB4SgUog8fzMzOQXdqukUL+cyTu6NkiUlXiiP2p58xBBBY8dHiVN2gT+5e5mBUpDw
         hca73s4DzV1IaoYmEcqtFT97fz4cYy1baeRGSZK+DdQCTmX5mxrIXHUb5IzOvU9H22
         lQtG/8DfKN7fZY0tac56c+2dX4whMngEhnHqukoM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Harry Wentland <harry.wentland@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Stylon Wang <stylon.wang@amd.com>
Subject: [PATCH 5.4 398/453] drm/amd/display: Fix memory leaks in S3 resume
Date:   Mon, 28 Dec 2020 13:50:34 +0100
Message-Id: <20201228124956.358473388@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stylon Wang <stylon.wang@amd.com>

commit a135a1b4c4db1f3b8cbed9676a40ede39feb3362 upstream.

EDID parsing in S3 resume pushes new display modes
to probed_modes list but doesn't consolidate to actual
mode list. This creates a race condition when
amdgpu_dm_connector_ddc_get_modes() re-initializes the
list head without walking the list and results in  memory leak.

Bug: https://bugzilla.kernel.org/show_bug.cgi?id=209987
Acked-by: Harry Wentland <harry.wentland@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Stylon Wang <stylon.wang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1434,7 +1434,8 @@ amdgpu_dm_update_connector_after_detect(
 
 			drm_connector_update_edid_property(connector,
 							   aconnector->edid);
-			drm_add_edid_modes(connector, aconnector->edid);
+			aconnector->num_modes = drm_add_edid_modes(connector, aconnector->edid);
+			drm_connector_list_update(connector);
 
 			if (aconnector->dc_link->aux_mode)
 				drm_dp_cec_set_edid(&aconnector->dm_dp_aux.aux,


