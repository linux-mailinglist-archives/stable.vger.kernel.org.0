Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B378B6810D0
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:07:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237094AbjA3OHC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:07:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237102AbjA3OHB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:07:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA3B13B3FE
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:07:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 45A6D61026
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:07:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C1B6C433D2;
        Mon, 30 Jan 2023 14:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087619;
        bh=/Q68WvVQEMJAHQFG4dJgYFDyWNUfbbkq37cIYVX3zzw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LIp/uGZaeHz8U5B5y8iIZj5M5/oIU1i4enGMQSDs9unQnPvDiJHBpIoy0VbV2CJoO
         Y/DRF+iiNwbjhXZr8jX6yT7czQCN4a+Y+NDhOUVZdGgIIpyIG7a6nGV5QZCT4Sk4y5
         R3BLf3CWxFURG3fu3iVE1onCRICGZpkh52e2OKlo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wayne Lin <Wayne.Lin@amd.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Lyude Paul <lyude@redhat.com>, Didier Raboud <odyx@debian.org>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 239/313] drm/amdgpu/display/mst: update mst_mgr relevant variable when long HPD
Date:   Mon, 30 Jan 2023 14:51:14 +0100
Message-Id: <20230130134347.815444398@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wayne Lin <Wayne.Lin@amd.com>

commit f85c5e25fd28fe0bf6d6d0563cf83758a4e05c8f upstream.

[Why & How]
Now the vc_start_slot is controlled at drm side. When we
service a long HPD, we still need to run
dm_helpers_dp_mst_write_payload_allocation_table() to update
drm mst_mgr's relevant variable. Otherwise, on the next plug-in,
payload will get assigned with a wrong start slot.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/2171
Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
Signed-off-by: Harry Wentland <harry.wentland@amd.com>
Fixes: 4d07b0bc4034 ("drm/display/dp_mst: Move all payload info into the atomic state")
Cc: stable@vger.kernel.org # 6.1
Acked-by: Harry Wentland <harry.wentland@amd.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Tested-by: Didier Raboud <odyx@debian.org>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link.c b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
index 342e906ae26e..c88f044666fe 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
@@ -3995,10 +3995,13 @@ static enum dc_status deallocate_mst_payload(struct pipe_ctx *pipe_ctx)
 	struct fixed31_32 avg_time_slots_per_mtp = dc_fixpt_from_int(0);
 	int i;
 	bool mst_mode = (link->type == dc_connection_mst_branch);
+	/* adjust for drm changes*/
+	bool update_drm_mst_state = true;
 	const struct link_hwss *link_hwss = get_link_hwss(link, &pipe_ctx->link_res);
 	const struct dc_link_settings empty_link_settings = {0};
 	DC_LOGGER_INIT(link->ctx->logger);
 
+
 	/* deallocate_mst_payload is called before disable link. When mode or
 	 * disable/enable monitor, new stream is created which is not in link
 	 * stream[] yet. For this, payload is not allocated yet, so de-alloc
@@ -4014,7 +4017,7 @@ static enum dc_status deallocate_mst_payload(struct pipe_ctx *pipe_ctx)
 				&empty_link_settings,
 				avg_time_slots_per_mtp);
 
-	if (mst_mode) {
+	if (mst_mode || update_drm_mst_state) {
 		/* when link is in mst mode, reply on mst manager to remove
 		 * payload
 		 */
@@ -4077,11 +4080,18 @@ static enum dc_status deallocate_mst_payload(struct pipe_ctx *pipe_ctx)
 			stream->ctx,
 			stream);
 
+		if (!update_drm_mst_state)
+			dm_helpers_dp_mst_send_payload_allocation(
+				stream->ctx,
+				stream,
+				false);
+	}
+
+	if (update_drm_mst_state)
 		dm_helpers_dp_mst_send_payload_allocation(
 			stream->ctx,
 			stream,
 			false);
-	}
 
 	return DC_OK;
 }
-- 
2.39.1



