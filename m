Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04F2F206061
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392400AbgFWUmP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:42:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:38736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392392AbgFWUmL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:42:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92CC82070E;
        Tue, 23 Jun 2020 20:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944931;
        bh=z35iJVWZkC2NAMYRYw/X+fGLQhQF2nEGbNhYXl4tEGc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x+pyBYvcfl975TG+6gslMgbztNa0nysFh8RLAIhAu8gPtKsMPpnh0gctCniFGzWj1
         UAjcyfGSKnoP8vtQQqRTntqAEO+eDbV4k6Or4gefsADCn/nEyfktHRzMB6KWZbmdYi
         8ClLblYTozK/LzBCGjkAn8wpgObP+VmjJ6t7o7qk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lyude Paul <lyude@redhat.com>,
        Sean Paul <sean@poorly.run>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 180/206] drm/dp_mst: Increase ACT retry timeout to 3s
Date:   Tue, 23 Jun 2020 21:58:28 +0200
Message-Id: <20200623195325.892939232@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195316.864547658@linuxfoundation.org>
References: <20200623195316.864547658@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lyude Paul <lyude@redhat.com>

[ Upstream commit 873a95e0d59ac06901ae261dda0b7165ffd002b8 ]

Currently we only poll for an ACT up to 30 times, with a busy-wait delay
of 100µs between each attempt - giving us a timeout of 2900µs. While
this might seem sensible, it would appear that in certain scenarios it
can take dramatically longer then that for us to receive an ACT. On one
of the EVGA MST hubs that I have available, I observed said hub
sometimes taking longer then a second before signalling the ACT. These
delays mostly seem to occur when previous sideband messages we've sent
are NAKd by the hub, however it wouldn't be particularly surprising if
it's possible to reproduce times like this simply by introducing branch
devices with large LCTs since payload allocations have to take effect on
every downstream device up to the payload's target.

So, instead of just retrying 30 times we poll for the ACT for up to 3ms,
and additionally use usleep_range() to avoid a very long and rude
busy-wait. Note that the previous retry count of 30 appears to have been
arbitrarily chosen, as I can't find any mention of a recommended timeout
or retry count for ACTs in the DisplayPort 2.0 specification. This also
goes for the range we were previously using for udelay(), although I
suspect that was just copied from the recommended delay for link
training on SST devices.

Changes since v1:
* Use readx_poll_timeout() instead of open-coding timeout loop - Sean
  Paul
Changes since v2:
* Increase poll interval to 200us - Sean Paul
* Print status in hex when we timeout waiting for ACT - Sean Paul

Signed-off-by: Lyude Paul <lyude@redhat.com>
Fixes: ad7f8a1f9ced ("drm/helper: add Displayport multi-stream helper (v0.6)")
Cc: Sean Paul <sean@poorly.run>
Cc: <stable@vger.kernel.org> # v3.17+
Reviewed-by: Sean Paul <sean@poorly.run>
Link: https://patchwork.freedesktop.org/patch/msgid/20200406221253.1307209-4-lyude@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_dp_mst_topology.c | 54 ++++++++++++++++-----------
 1 file changed, 32 insertions(+), 22 deletions(-)

diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c b/drivers/gpu/drm/drm_dp_mst_topology.c
index 70bffedfdcf5b..a0aafd9a37e60 100644
--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -29,6 +29,7 @@
 #include <linux/i2c.h>
 #include <drm/drm_dp_mst_helper.h>
 #include <drm/drmP.h>
+#include <linux/iopoll.h>
 
 #include <drm/drm_fixed.h>
 #include <drm/drm_atomic.h>
@@ -2828,6 +2829,17 @@ static int drm_dp_dpcd_write_payload(struct drm_dp_mst_topology_mgr *mgr,
 	return ret;
 }
 
+static int do_get_act_status(struct drm_dp_aux *aux)
+{
+	int ret;
+	u8 status;
+
+	ret = drm_dp_dpcd_readb(aux, DP_PAYLOAD_TABLE_UPDATE_STATUS, &status);
+	if (ret < 0)
+		return ret;
+
+	return status;
+}
 
 /**
  * drm_dp_check_act_status() - Check ACT handled status.
@@ -2837,30 +2849,28 @@ static int drm_dp_dpcd_write_payload(struct drm_dp_mst_topology_mgr *mgr,
  */
 int drm_dp_check_act_status(struct drm_dp_mst_topology_mgr *mgr)
 {
-	int count = 0, ret;
-	u8 status;
-
-	do {
-		ret = drm_dp_dpcd_readb(mgr->aux,
-					DP_PAYLOAD_TABLE_UPDATE_STATUS,
-					&status);
-		if (ret < 0) {
-			DRM_DEBUG_KMS("failed to read payload table status %d\n",
-				      ret);
-			return ret;
-		}
-
-		if (status & DP_PAYLOAD_ACT_HANDLED)
-			break;
-		count++;
-		udelay(100);
-	} while (count < 30);
-
-	if (!(status & DP_PAYLOAD_ACT_HANDLED)) {
-		DRM_DEBUG_KMS("failed to get ACT bit %d after %d retries\n",
-			      status, count);
+	/*
+	 * There doesn't seem to be any recommended retry count or timeout in
+	 * the MST specification. Since some hubs have been observed to take
+	 * over 1 second to update their payload allocations under certain
+	 * conditions, we use a rather large timeout value.
+	 */
+	const int timeout_ms = 3000;
+	int ret, status;
+
+	ret = readx_poll_timeout(do_get_act_status, mgr->aux, status,
+				 status & DP_PAYLOAD_ACT_HANDLED || status < 0,
+				 200, timeout_ms * USEC_PER_MSEC);
+	if (ret < 0 && status >= 0) {
+		DRM_DEBUG_KMS("Failed to get ACT after %dms, last status: %02x\n",
+			      timeout_ms, status);
 		return -EINVAL;
+	} else if (status < 0) {
+		DRM_DEBUG_KMS("Failed to read payload table status: %d\n",
+			      status);
+		return status;
 	}
+
 	return 0;
 }
 EXPORT_SYMBOL(drm_dp_check_act_status);
-- 
2.25.1



