Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA00CA917C
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388919AbfIDSP5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:15:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:60680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390424AbfIDSPL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:15:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5E7422DBF;
        Wed,  4 Sep 2019 18:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620910;
        bh=91bzfqjuA0AykFYNiVsjGg8ity7Xp6cKp0uQxd9sGB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N98X+QH5nILcbdJTqf6S2xEBc1maiKFdCV/d+YQQKI5Q2EsB9baZvrpOJ6WnsvbvP
         ZiHDTEsZFiQEwgs9A3udWwjAlO9/1tGyZ7AuTYy3NyrsXCPu6y6Cj1+X+pfFS4Qlss
         8nby828UVy4aUz5x+RHIA5K/ut4OazjVndL1hL2I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lyude Paul <lyude@redhat.com>,
        sunpeng.li@amd.com, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sean Paul <sean@poorly.run>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 139/143] drm/i915: Do not create a new max_bpc prop for MST connectors
Date:   Wed,  4 Sep 2019 19:54:42 +0200
Message-Id: <20190904175319.881236425@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175314.206239922@linuxfoundation.org>
References: <20190904175314.206239922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 1b9bd09630d4db4827cc04d358a41a16a6bc2cb0 ]

We're not allowed to create new properties after device registration
so for MST connectors we need to either create the max_bpc property
earlier, or we reuse one we already have. Let's do the latter apporach
since the corresponding SST connector already has the prop and its
min/max are correct also for the MST connector.

The problem was highlighted by commit 4f5368b5541a ("drm/kms:
Catch mode_object lifetime errors") which results in the following
spew:
[ 1330.878941] WARNING: CPU: 2 PID: 1554 at drivers/gpu/drm/drm_mode_object.c:45 __drm_mode_object_add+0xa0/0xb0 [drm]
...
[ 1330.879008] Call Trace:
[ 1330.879023]  drm_property_create+0xba/0x180 [drm]
[ 1330.879036]  drm_property_create_range+0x15/0x30 [drm]
[ 1330.879048]  drm_connector_attach_max_bpc_property+0x62/0x80 [drm]
[ 1330.879086]  intel_dp_add_mst_connector+0x11f/0x140 [i915]
[ 1330.879094]  drm_dp_add_port.isra.20+0x20b/0x440 [drm_kms_helper]
...

Cc: stable@vger.kernel.org
Cc: Lyude Paul <lyude@redhat.com>
Cc: sunpeng.li@amd.com
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Sean Paul <sean@poorly.run>
Fixes: 5ca0ef8a56b8 ("drm/i915: Add max_bpc property for DP MST")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190820161657.9658-1-ville.syrjala@linux.intel.com
Reviewed-by: José Roberto de Souza <jose.souza@intel.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/intel_dp_mst.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/intel_dp_mst.c b/drivers/gpu/drm/i915/intel_dp_mst.c
index 8839eaea83715..d89120dcac67d 100644
--- a/drivers/gpu/drm/i915/intel_dp_mst.c
+++ b/drivers/gpu/drm/i915/intel_dp_mst.c
@@ -535,7 +535,15 @@ static struct drm_connector *intel_dp_add_mst_connector(struct drm_dp_mst_topolo
 
 	intel_attach_force_audio_property(connector);
 	intel_attach_broadcast_rgb_property(connector);
-	drm_connector_attach_max_bpc_property(connector, 6, 12);
+
+	/*
+	 * Reuse the prop from the SST connector because we're
+	 * not allowed to create new props after device registration.
+	 */
+	connector->max_bpc_property =
+		intel_dp->attached_connector->base.max_bpc_property;
+	if (connector->max_bpc_property)
+		drm_connector_attach_max_bpc_property(connector, 6, 12);
 
 	return connector;
 
-- 
2.20.1



