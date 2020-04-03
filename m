Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C286719DEFA
	for <lists+stable@lfdr.de>; Fri,  3 Apr 2020 22:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727879AbgDCUIQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Apr 2020 16:08:16 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:37806 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727958AbgDCUIP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Apr 2020 16:08:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585944495;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OEsV9eSdWDRaAMBOSt6FSG+jWV6hZRXoz4QAhzcz7j8=;
        b=UC15zoumqeheBRSG17/++Ih+n/eOTbZSxRCmPi/7BucD0AQnyzMSaZ3pxxPvw0Jh8ebhf/
        726xZBTg0R1kBG2fGZG78Vk7Jf1Iu8DjDXS7iT69zWU1/YLrGhXsPDnF0tCyIqW3IMqhhQ
        +3c8MwiTXmC6bWzxEguwImn8SjveuMI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-25-zuo8q5npPduGTdfIw3fzfg-1; Fri, 03 Apr 2020 16:08:13 -0400
X-MC-Unique: zuo8q5npPduGTdfIw3fzfg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E0909100550D;
        Fri,  3 Apr 2020 20:08:11 +0000 (UTC)
Received: from Ruby.redhat.com (ovpn-117-203.rdu2.redhat.com [10.10.117.203])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 09D515C541;
        Fri,  3 Apr 2020 20:08:09 +0000 (UTC)
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
Subject: [PATCH 3/4] drm/dp_mst: Increase ACT retry timeout to 3s
Date:   Fri,  3 Apr 2020 16:07:55 -0400
Message-Id: <20200403200757.886443-4-lyude@redhat.com>
In-Reply-To: <20200403200757.886443-1-lyude@redhat.com>
References: <20200403200757.886443-1-lyude@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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

Signed-off-by: Lyude Paul <lyude@redhat.com>
Fixes: ad7f8a1f9ced ("drm/helper: add Displayport multi-stream helper (v0=
.6)")
Cc: Sean Paul <sean@poorly.run>
Cc: <stable@vger.kernel.org> # v3.17+
---
 drivers/gpu/drm/drm_dp_mst_topology.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c b/drivers/gpu/drm/drm_=
dp_mst_topology.c
index 7aaf184a2e5f..f313407374ed 100644
--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -4466,17 +4466,30 @@ static int drm_dp_dpcd_write_payload(struct drm_d=
p_mst_topology_mgr *mgr,
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
+	/*
+	 * There doesn't seem to be any recommended retry count or timeout in
+	 * the MST specification. Since some hubs have been observed to take
+	 * over 1 second to update their payload allocations under certain
+	 * conditions, we use a rather large timeout value.
+	 */
+	const int timeout_ms =3D 3000;
+	unsigned long timeout =3D jiffies + msecs_to_jiffies(timeout_ms);
+	int ret;
+	bool retrying =3D false;
 	u8 status;
=20
 	do {
+		if (retrying)
+			usleep_range(100, 1000);
+
 		ret =3D drm_dp_dpcd_readb(mgr->aux,
 					DP_PAYLOAD_TABLE_UPDATE_STATUS,
 					&status);
@@ -4488,13 +4501,12 @@ int drm_dp_check_act_status(struct drm_dp_mst_top=
ology_mgr *mgr)
=20
 		if (status & DP_PAYLOAD_ACT_HANDLED)
 			break;
-		count++;
-		udelay(100);
-	} while (count < 30);
+		retrying =3D true;
+	} while (jiffies < timeout);
=20
 	if (!(status & DP_PAYLOAD_ACT_HANDLED)) {
-		DRM_DEBUG_KMS("failed to get ACT bit %d after %d retries\n",
-			      status, count);
+		DRM_DEBUG_KMS("failed to get ACT bit %d after %dms\n",
+			      status, timeout_ms);
 		return -EINVAL;
 	}
 	return 0;
--=20
2.25.1

