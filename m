Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5021415C51E
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:54:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728664AbgBMP0E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:26:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:43376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728631AbgBMP0E (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:26:04 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 33A3B246A3;
        Thu, 13 Feb 2020 15:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607563;
        bh=gjjDWGRooBc5UqVMIQJAX12Qn9s0CDwI6cpcchgX04k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tRR/eXC1bQ8sUuAM6z0NxYVA1AmTs3PqNgyquV7zylYE6TG3B6b0ZxTC0Abgczn0o
         YGhq3fdkR8JaggZQrAWFTcxCRHO3RXj3nxj2Yup1EBHg4MwfSxWU7UqMLtD0V82/cB
         oNCaCG2BHfuInOxyduS70r5haCuWtvLlHnZVTRlc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wayne Lin <Wayne.Lin@amd.com>,
        Lyude Paul <lyude@redhat.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 127/173] drm/dp_mst: Remove VCPI while disabling topology mgr
Date:   Thu, 13 Feb 2020 07:20:30 -0800
Message-Id: <20200213152004.290260546@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151931.677980430@linuxfoundation.org>
References: <20200213151931.677980430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wayne Lin <Wayne.Lin@amd.com>

[ Upstream commit 64e62bdf04ab8529f45ed0a85122c703035dec3a ]

[Why]

This patch is trying to address the issue observed when hotplug DP
daisy chain monitors.

e.g.
src-mstb-mstb-sst -> src (unplug) mstb-mstb-sst -> src-mstb-mstb-sst
(plug in again)

Once unplug a DP MST capable device, driver will call
drm_dp_mst_topology_mgr_set_mst() to disable MST. In this function,
it cleans data of topology manager while disabling mst_state. However,
it doesn't clean up the proposed_vcpis of topology manager.
If proposed_vcpi is not reset, once plug in MST daisy chain monitors
later, code will fail at checking port validation while trying to
allocate payloads.

When MST capable device is plugged in again and try to allocate
payloads by calling drm_dp_update_payload_part1(), this
function will iterate over all proposed virtual channels to see if
any proposed VCPI's num_slots is greater than 0. If any proposed
VCPI's num_slots is greater than 0 and the port which the
specific virtual channel directed to is not in the topology, code then
fails at the port validation. Since there are stale VCPI allocations
from the previous topology enablement in proposed_vcpi[], code will fail
at port validation and reurn EINVAL.

[How]

Clean up the data of stale proposed_vcpi[] and reset mgr->proposed_vcpis
to NULL while disabling mst in drm_dp_mst_topology_mgr_set_mst().

Changes since v1:
*Add on more details in commit message to describe the issue which the
patch is trying to fix

Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
[added cc to stable]
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20191205090043.7580-1-Wayne.Lin@amd.com
Cc: <stable@vger.kernel.org> # v3.17+
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_dp_mst_topology.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c b/drivers/gpu/drm/drm_dp_mst_topology.c
index 9d94c306c8ca1..f427a5dc66685 100644
--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -2046,6 +2046,7 @@ static bool drm_dp_get_vc_payload_bw(int dp_link_bw,
 int drm_dp_mst_topology_mgr_set_mst(struct drm_dp_mst_topology_mgr *mgr, bool mst_state)
 {
 	int ret = 0;
+	int i = 0;
 	struct drm_dp_mst_branch *mstb = NULL;
 
 	mutex_lock(&mgr->lock);
@@ -2106,10 +2107,21 @@ int drm_dp_mst_topology_mgr_set_mst(struct drm_dp_mst_topology_mgr *mgr, bool ms
 		/* this can fail if the device is gone */
 		drm_dp_dpcd_writeb(mgr->aux, DP_MSTM_CTRL, 0);
 		ret = 0;
+		mutex_lock(&mgr->payload_lock);
 		memset(mgr->payloads, 0, mgr->max_payloads * sizeof(struct drm_dp_payload));
 		mgr->payload_mask = 0;
 		set_bit(0, &mgr->payload_mask);
+		for (i = 0; i < mgr->max_payloads; i++) {
+			struct drm_dp_vcpi *vcpi = mgr->proposed_vcpis[i];
+
+			if (vcpi) {
+				vcpi->vcpi = 0;
+				vcpi->num_slots = 0;
+			}
+			mgr->proposed_vcpis[i] = NULL;
+		}
 		mgr->vcpi_mask = 0;
+		mutex_unlock(&mgr->payload_lock);
 	}
 
 out_unlock:
-- 
2.20.1



