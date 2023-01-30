Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 941C06810BD
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:06:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237076AbjA3OGQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:06:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237087AbjA3OGN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:06:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48E613B3FC
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:06:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E5032B80C9B
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:06:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F4ADC433EF;
        Mon, 30 Jan 2023 14:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087569;
        bh=H0Sy5modqtHNlqSQqS/P3ouBfyqA3VdUvVxORAxQ5nY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fX6UostAWp3y1sxE3IXkPYh+Nfid3CNhxYHmvlffamQMeQ6d/km10V0HllS+ocgBs
         0cv1XA5wbY3rSQlefR0L3n6uMc8TmAzxob1MKJ1+5L3ZEDyjXiJW2wGJbRbbiP2WIM
         0iHLG2nmR9t2EKEj9NqoWh0raGLyFjwj5dIC22DM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wayne Lin <Wayne.Lin@amd.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Lyude Paul <lyude@redhat.com>, Didier Raboud <odyx@debian.org>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 234/313] drm/display/dp_mst: Correct the kref of port.
Date:   Mon, 30 Jan 2023 14:51:09 +0100
Message-Id: <20230130134347.601453014@linuxfoundation.org>
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

commit d8bf2df715bb8ac964f91fe8bf67c37c5d916463 upstream.

[why & how]
We still need to refer to port while removing payload at commit_tail.
we should keep the kref till then to release.

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
 drivers/gpu/drm/display/drm_dp_mst_topology.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/display/drm_dp_mst_topology.c b/drivers/gpu/drm/display/drm_dp_mst_topology.c
index 51a46689cda7..4ca37261584a 100644
--- a/drivers/gpu/drm/display/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/display/drm_dp_mst_topology.c
@@ -3372,6 +3372,9 @@ void drm_dp_remove_payload(struct drm_dp_mst_topology_mgr *mgr,
 
 	mgr->payload_count--;
 	mgr->next_start_slot -= payload->time_slots;
+
+	if (payload->delete)
+		drm_dp_mst_put_port_malloc(payload->port);
 }
 EXPORT_SYMBOL(drm_dp_remove_payload);
 
@@ -4327,7 +4330,6 @@ int drm_dp_atomic_release_time_slots(struct drm_atomic_state *state,
 
 	drm_dbg_atomic(mgr->dev, "[MST PORT:%p] TU %d -> 0\n", port, payload->time_slots);
 	if (!payload->delete) {
-		drm_dp_mst_put_port_malloc(port);
 		payload->pbn = 0;
 		payload->delete = true;
 		topology_state->payload_mask &= ~BIT(payload->vcpi - 1);
-- 
2.39.1



