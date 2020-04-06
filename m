Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9FA61A00B5
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 00:13:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbgDFWNW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Apr 2020 18:13:22 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:32561 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726406AbgDFWNM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Apr 2020 18:13:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586211191;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fPISPkWsCVo8mE1k6RSQJPo30SQpcpTaMBLN8nWnBgc=;
        b=Jn2m7dWyDbPWz12MDIyS6kGF2EzNHuVLYlJGoGoJ2lYGDYy5QGYSKzjaBX1BaMUlm3rUYA
        lKHqDuByOBtVAlD9j/u76icKCIAYdEXS27Yp+detYxyFOeRsUxa0BxkgNcHHDwANDXEANl
        YFVvx5GnwsEzqcz5MgkRU6jIC/+OK18=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-327-ATt92gKxP8SKBfuZZ185hw-1; Mon, 06 Apr 2020 18:13:09 -0400
X-MC-Unique: ATt92gKxP8SKBfuZZ185hw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 29FE1800D6C;
        Mon,  6 Apr 2020 22:13:08 +0000 (UTC)
Received: from Ruby.redhat.com (ovpn-117-12.rdu2.redhat.com [10.10.117.12])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B04499D359;
        Mon,  6 Apr 2020 22:13:06 +0000 (UTC)
From:   Lyude Paul <lyude@redhat.com>
To:     dri-devel@lists.freedesktop.org
Cc:     Sean Paul <sean@poorly.run>, stable@vger.kernel.org,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Todd Previte <tprevite@gmail.com>,
        Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/4] drm/dp_mst: Increase ACT retry timeout to 3s
Date:   Mon,  6 Apr 2020 18:12:52 -0400
Message-Id: <20200406221253.1307209-4-lyude@redhat.com>
In-Reply-To: <20200406221253.1307209-1-lyude@redhat.com>
References: <20200406221253.1307209-1-lyude@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Currently we only poll for an ACT up to 30 times, with a busy-wait delay
of 100=C2=B5s between each attempt - giving us a timeout of 2900=C2=B5s. =
While
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

Signed-off-by: Lyude Paul <lyude@redhat.com>
Fixes: ad7f8a1f9ced ("drm/helper: add Displayport multi-stream helper (v0=
.6)")
Cc: Sean Paul <sean@poorly.run>
Cc: <stable@vger.kernel.org> # v3.17+
---
 drivers/gpu/drm/drm_dp_mst_topology.c | 57 ++++++++++++++++-----------
 1 file changed, 34 insertions(+), 23 deletions(-)

diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c b/drivers/gpu/drm/drm_=
dp_mst_topology.c
index c83adbdfc1cd..ce61964baa7c 100644
--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -27,6 +27,7 @@
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/seq_file.h>
+#include <linux/iopoll.h>
=20
 #if IS_ENABLED(CONFIG_DRM_DEBUG_DP_MST_TOPOLOGY_REFS)
 #include <linux/stacktrace.h>
@@ -4460,43 +4461,53 @@ static int drm_dp_dpcd_write_payload(struct drm_d=
p_mst_topology_mgr *mgr,
 	return ret;
 }
=20
+static int do_get_act_status(struct drm_dp_aux *aux)
+{
+	int ret;
+	u8 status;
+
+	ret =3D drm_dp_dpcd_readb(aux, DP_PAYLOAD_TABLE_UPDATE_STATUS, &status)=
;
+	if (ret < 0)
+		return ret;
+
+	return status;
+}
=20
 /**
  * drm_dp_check_act_status() - Polls for ACT handled status.
  * @mgr: manager to use
  *
  * Tries waiting for the MST hub to finish updating it's payload table b=
y
- * polling for the ACT handled bit.
+ * polling for the ACT handled bit for up to 3 seconds (yes-some hubs re=
ally
+ * take that long).
  *
  * Returns:
  * 0 if the ACT was handled in time, negative error code on failure.
  */
 int drm_dp_check_act_status(struct drm_dp_mst_topology_mgr *mgr)
 {
-	int count =3D 0, ret;
-	u8 status;
-
-	do {
-		ret =3D drm_dp_dpcd_readb(mgr->aux,
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
+	const int timeout_ms =3D 3000;
+	int ret, status;
+
+	ret =3D readx_poll_timeout(do_get_act_status, mgr->aux, status,
+				 status & DP_PAYLOAD_ACT_HANDLED || status < 0,
+				 100, timeout_ms * USEC_PER_MSEC);
+	if (ret < 0 && status >=3D 0) {
+		DRM_DEBUG_KMS("Failed to get ACT bit %d after %dms\n",
+			      status, timeout_ms);
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
--=20
2.25.1

