Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1247A1B3BF6
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbgDVKBB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:01:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:48748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726694AbgDVKA4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:00:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D788720735;
        Wed, 22 Apr 2020 10:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587549655;
        bh=dO0qlpZrROUVq45PrPUtrziJoBZYcrNZEhmnu2i3hh0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F0LoYoq+XLbLrNeKPcpQceDpsLiVx6M4W0swpuJihpwujcOWMB81WpZG6eIXAaJjY
         9zuhib+Y5y2b20+yhMfTTPAzYijNwhz9s1veL7E4fLXCtzWpIoWQo96X/yP//kjI/4
         HysY3t7VRx2/rMGVNlMS5b1J0vAo64VMeHbuyO4E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Paul <sean@poorly.run>,
        Wayne Lin <Wayne.Lin@amd.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, Lyude Paul <lyude@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 051/100] drm/dp_mst: Fix clearing payload state on topology disable
Date:   Wed, 22 Apr 2020 11:56:21 +0200
Message-Id: <20200422095031.997131903@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095022.476101261@linuxfoundation.org>
References: <20200422095022.476101261@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lyude Paul <lyude@redhat.com>

[ Upstream commit 8732fe46b20c951493bfc4dba0ad08efdf41de81 ]

The issues caused by:

commit 64e62bdf04ab ("drm/dp_mst: Remove VCPI while disabling topology
mgr")

Prompted me to take a closer look at how we clear the payload state in
general when disabling the topology, and it turns out there's actually
two subtle issues here.

The first is that we're not grabbing &mgr.payload_lock when clearing the
payloads in drm_dp_mst_topology_mgr_set_mst(). Seeing as the canonical
lock order is &mgr.payload_lock -> &mgr.lock (because we always want
&mgr.lock to be the inner-most lock so topology validation always
works), this makes perfect sense. It also means that -technically- there
could be racing between someone calling
drm_dp_mst_topology_mgr_set_mst() to disable the topology, along with a
modeset occurring that's modifying the payload state at the same time.

The second is the more obvious issue that Wayne Lin discovered, that
we're not clearing proposed_payloads when disabling the topology.

I actually can't see any obvious places where the racing caused by the
first issue would break something, and it could be that some of our
higher-level locks already prevent this by happenstance, but better safe
then sorry. So, let's make it so that drm_dp_mst_topology_mgr_set_mst()
first grabs &mgr.payload_lock followed by &mgr.lock so that we never
race when modifying the payload state. Then, we also clear
proposed_payloads to fix the original issue of enabling a new topology
with a dirty payload state. This doesn't clear any of the drm_dp_vcpi
structures, but those are getting destroyed along with the ports anyway.

Changes since v1:
* Use sizeof(mgr->payloads[0])/sizeof(mgr->proposed_vcpis[0]) instead -
  vsyrjala

Cc: Sean Paul <sean@poorly.run>
Cc: Wayne Lin <Wayne.Lin@amd.com>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: stable@vger.kernel.org # v4.4+
Signed-off-by: Lyude Paul <lyude@redhat.com>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200122194321.14953-1-lyude@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_dp_mst_topology.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c b/drivers/gpu/drm/drm_dp_mst_topology.c
index f5229b083f8ea..483bd48467312 100644
--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -2031,6 +2031,7 @@ int drm_dp_mst_topology_mgr_set_mst(struct drm_dp_mst_topology_mgr *mgr, bool ms
 	int ret = 0;
 	struct drm_dp_mst_branch *mstb = NULL;
 
+	mutex_lock(&mgr->payload_lock);
 	mutex_lock(&mgr->lock);
 	if (mst_state == mgr->mst_state)
 		goto out_unlock;
@@ -2093,7 +2094,10 @@ int drm_dp_mst_topology_mgr_set_mst(struct drm_dp_mst_topology_mgr *mgr, bool ms
 		/* this can fail if the device is gone */
 		drm_dp_dpcd_writeb(mgr->aux, DP_MSTM_CTRL, 0);
 		ret = 0;
-		memset(mgr->payloads, 0, mgr->max_payloads * sizeof(struct drm_dp_payload));
+		memset(mgr->payloads, 0,
+		       mgr->max_payloads * sizeof(mgr->payloads[0]));
+		memset(mgr->proposed_vcpis, 0,
+		       mgr->max_payloads * sizeof(mgr->proposed_vcpis[0]));
 		mgr->payload_mask = 0;
 		set_bit(0, &mgr->payload_mask);
 		mgr->vcpi_mask = 0;
@@ -2101,6 +2105,7 @@ int drm_dp_mst_topology_mgr_set_mst(struct drm_dp_mst_topology_mgr *mgr, bool ms
 
 out_unlock:
 	mutex_unlock(&mgr->lock);
+	mutex_unlock(&mgr->payload_lock);
 	if (mstb)
 		drm_dp_put_mst_branch_device(mstb);
 	return ret;
-- 
2.20.1



