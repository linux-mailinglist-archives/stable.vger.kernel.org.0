Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 716B313ECDC
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:59:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393856AbgAPRnE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:43:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:32932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393854AbgAPRnD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:43:03 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AEB0B24695;
        Thu, 16 Jan 2020 17:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196583;
        bh=yIxhLpc4/8MptiFRK8fD88gnwx9ZyQChQN3xYV4/iOA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HRYegrT7NDEUhYTfjkFGibtMv1uupUMU/wrXI4LTgcax3Y6FkieG+/StCnCt7216X
         J4+x4rhV9kpbl75DEZnpX63pblK47jAP5I4yi07XbH9/urpCgmymhBZxAvOSFeuDPu
         +yku1MLqW7B639o5PMVPEGmiyoPXZ9A7U62fC0Po=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lyude Paul <lyude@redhat.com>, Jerry Zuo <Jerry.Zuo@amd.com>,
        Harry Wentland <Harry.Wentland@amd.com>,
        Dave Airlie <airlied@redhat.com>,
        Sean Paul <seanpaul@chromium.org>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.4 008/174] drm/dp_mst: Skip validating ports during destruction, just ref
Date:   Thu, 16 Jan 2020 12:40:05 -0500
Message-Id: <20200116174251.24326-8-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116174251.24326-1-sashal@kernel.org>
References: <20200116174251.24326-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lyude Paul <lyude@redhat.com>

[ Upstream commit c54c7374ff44de5e609506aca7c0deae4703b6d1 ]

Jerry Zuo pointed out a rather obscure hotplugging issue that it seems I
accidentally introduced into DRM two years ago.

Pretend we have a topology like this:

|- DP-1: mst_primary
   |- DP-4: active display
   |- DP-5: disconnected
   |- DP-6: active hub
      |- DP-7: active display
      |- DP-8: disconnected
      |- DP-9: disconnected

If we unplug DP-6, the topology starting at DP-7 will be destroyed but
it's payloads will live on in DP-1's VCPI allocations and thus require
removal. However, this removal currently fails because
drm_dp_update_payload_part1() will (rightly so) try to validate the port
before accessing it, fail then abort. If we keep going, eventually we
run the MST hub out of bandwidth and all new allocations will start to
fail (or in my case; all new displays just start flickering a ton).

We could just teach drm_dp_update_payload_part1() not to drop the port
ref in this case, but then we also need to teach
drm_dp_destroy_payload_step1() to do the same thing, then hope no one
ever adds anything to the that requires a validated port reference in
drm_dp_destroy_connector_work(). Kind of sketchy.

So let's go with a more clever solution: any port that
drm_dp_destroy_connector_work() interacts with is guaranteed to still
exist in memory until we say so. While said port might not be valid we
don't really care: that's the whole reason we're destroying it in the
first place! So, teach drm_dp_get_validated_port_ref() to use the all
mighty current_work() function to avoid attempting to validate ports
from the context of mgr->destroy_connector_work. I can't see any
situation where this wouldn't be safe, and this avoids having to play
whack-a-mole in the future of trying to work around port validation.

Signed-off-by: Lyude Paul <lyude@redhat.com>
Fixes: 263efde31f97 ("drm/dp/mst: Get validated port ref in drm_dp_update_payload_part1()")
Reported-by: Jerry Zuo <Jerry.Zuo@amd.com>
Cc: Jerry Zuo <Jerry.Zuo@amd.com>
Cc: Harry Wentland <Harry.Wentland@amd.com>
Cc: <stable@vger.kernel.org> # v4.6+
Reviewed-by: Dave Airlie <airlied@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20181113224613.28809-1-lyude@redhat.com
Signed-off-by: Sean Paul <seanpaul@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_dp_mst_topology.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c b/drivers/gpu/drm/drm_dp_mst_topology.c
index 2cb924ffd5a3..4d0f77f0edad 100644
--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -975,9 +975,20 @@ static struct drm_dp_mst_port *drm_dp_mst_get_port_ref_locked(struct drm_dp_mst_
 static struct drm_dp_mst_port *drm_dp_get_validated_port_ref(struct drm_dp_mst_topology_mgr *mgr, struct drm_dp_mst_port *port)
 {
 	struct drm_dp_mst_port *rport = NULL;
+
 	mutex_lock(&mgr->lock);
-	if (mgr->mst_primary)
-		rport = drm_dp_mst_get_port_ref_locked(mgr->mst_primary, port);
+	/*
+	 * Port may or may not be 'valid' but we don't care about that when
+	 * destroying the port and we are guaranteed that the port pointer
+	 * will be valid until we've finished
+	 */
+	if (current_work() == &mgr->destroy_connector_work) {
+		kref_get(&port->kref);
+		rport = port;
+	} else if (mgr->mst_primary) {
+		rport = drm_dp_mst_get_port_ref_locked(mgr->mst_primary,
+						       port);
+	}
 	mutex_unlock(&mgr->lock);
 	return rport;
 }
-- 
2.20.1

