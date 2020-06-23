Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E34E2063F3
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393366AbgFWVNf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:13:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:50598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390340AbgFWUaU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:30:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CCF4B20702;
        Tue, 23 Jun 2020 20:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944220;
        bh=N13XLNE2bgkIaTR6aWBY+/rvUzWnrqiUg9e4uFLz6Nk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uo+ePY6Jpd+e9Mk+JWyOxT5LHKS2UIdDa2eIjosfl4i8UmVY516HGTDmHSTCa3q4k
         MJjGjYbzylTuoaA8TFVOdVLQsdM8ZcAwN4C7QWITAN0GgvWQ70h7dGw2tSh6qp54tL
         mi4lnNS+71Q7NmBlAeze088chEAPcCK4dKPEYC7s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Hersen Wu <hersenxs.wu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 219/314] drm/amd/display: Revalidate bandwidth before commiting DC updates
Date:   Tue, 23 Jun 2020 21:56:54 +0200
Message-Id: <20200623195349.382104294@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195338.770401005@linuxfoundation.org>
References: <20200623195338.770401005@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

[ Upstream commit a24eaa5c51255b344d5a321f1eeb3205f2775498 ]

[Why]
Whenever we switch between tiled formats without also switching pixel
formats or doing anything else that recreates the DC plane state we
can run into underflow or hangs since we're not updating the
DML parameters before committing to the hardware.

[How]
If the update type is FULL then call validate_bandwidth again to update
the DML parmeters before committing the state.

This is basically just a workaround and protective measure against
update types being added DC where we could run into this issue in
the future.

We can only fully validate the state in advance before applying it to
the hardware if we recreate all the plane and stream states since
we can't modify what's currently in use.

The next step is to update DM to ensure that we're creating the plane
and stream states for whatever could potentially be a full update in
DC to pre-emptively recreate the state for DC global validation.

The workaround can stay until this has been fixed in DM.

Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Reviewed-by: Hersen Wu <hersenxs.wu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 2028dc017f7a0..b95a58aa82d91 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -2230,6 +2230,12 @@ void dc_commit_updates_for_stream(struct dc *dc,
 
 	copy_stream_update_to_stream(dc, context, stream, stream_update);
 
+	if (!dc->res_pool->funcs->validate_bandwidth(dc, context, false)) {
+		DC_ERROR("Mode validation failed for stream update!\n");
+		dc_release_state(context);
+		return;
+	}
+
 	commit_planes_for_stream(
 				dc,
 				srf_updates,
-- 
2.25.1



