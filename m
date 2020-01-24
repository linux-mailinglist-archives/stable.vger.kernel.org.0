Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2904147F88
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:03:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387502AbgAXLDC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:03:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:36662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731809AbgAXLDA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:03:00 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BEB0B2071A;
        Fri, 24 Jan 2020 11:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579863779;
        bh=fy2M3xR3wpkWQhh+QyG69LM9fOJD6ppSxAtIJL0QPnY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YpqQy4aMg7cWVfy9qBkkqzDn2OZCECjzKihUt+qh2QK5NbSVt3AQXBoy+hpKvecXm
         Y/RryD1iqvUp8pLSMt9uNchdIaaNDXMkCEACxgBufVPZFCgMdGFpYYA7BU+q3TK06h
         XqxMcAYkDfYRNvVwywrX6JEOF/azc2BC7ZBZPX3E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lyude Paul <lyude@redhat.com>,
        Jerry Zuo <Jerry.Zuo@amd.com>,
        Harry Wentland <Harry.Wentland@amd.com>,
        Dave Airlie <airlied@redhat.com>,
        Sean Paul <seanpaul@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 073/639] drm/dp_mst: Skip validating ports during destruction, just ref
Date:   Fri, 24 Jan 2020 10:24:03 +0100
Message-Id: <20200124093056.539811118@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 4d77158453060..58fe3945494cf 100644
--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -1022,9 +1022,20 @@ static struct drm_dp_mst_port *drm_dp_mst_get_port_ref_locked(struct drm_dp_mst_
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



