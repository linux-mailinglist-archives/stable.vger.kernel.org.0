Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 502E213EF47
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:14:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395069AbgAPSOB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 13:14:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:49122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404891AbgAPRfC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:35:02 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14B88246D8;
        Thu, 16 Jan 2020 17:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196101;
        bh=UC001LbTVcSUiGfdFhBBYLJYxKzjHeFOJ8dBTV+YjLc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g4ggoxynddU/gcjm3w1S5xD0yI13WBtpTDKVNObbcCHW6gua4vrNlBTLEfPe5ofsm
         DwmAEmO0XiQXcnln10o6CysD9ePO0bfSt3K4i4WsBdbws3Y23im7G9JXeFWBVFe9Hv
         vAWa43fhXU8hQ+avCHi0CxfW8v9noqfP4x74C55k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lyude Paul <lyude@redhat.com>, Jerry Zuo <Jerry.Zuo@amd.com>,
        Harry Wentland <Harry.Wentland@amd.com>,
        Dave Airlie <airlied@redhat.com>,
        Sean Paul <seanpaul@chromium.org>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.9 012/251] drm/dp_mst: Skip validating ports during destruction, just ref
Date:   Thu, 16 Jan 2020 12:30:46 -0500
Message-Id: <20200116173445.21385-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116173445.21385-1-sashal@kernel.org>
References: <20200116173445.21385-1-sashal@kernel.org>
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
index e05dda92398c..17aedaaf364c 100644
--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -980,9 +980,20 @@ static struct drm_dp_mst_port *drm_dp_mst_get_port_ref_locked(struct drm_dp_mst_
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

