Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6A861A00B3
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 00:13:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbgDFWNT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Apr 2020 18:13:19 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:29121 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726426AbgDFWNM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Apr 2020 18:13:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586211191;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=61pSeHFI0mHGhKeOKlyyVpQ4t+B+NWcRA1rpl6V74kU=;
        b=a7phz9WEblOA8qg85SLx6SbP8x+SxUCXjKvnKclE+a1LFdPZwWXWaW6zNBV8I2WEtd+tCI
        c8DQD3k3YPQ/Gm+Zr61t7wBsw5M0VjBKxFfQJWmi69jJP7T2OOAH0a1SlOxDZn/MDe/JD3
        86Nomi8fHF3cBR/iweAy4ihD4Ez+wEw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-257-ygKCmBA-PjC_Bdt7SrkVcw-1; Mon, 06 Apr 2020 18:13:08 -0400
X-MC-Unique: ygKCmBA-PjC_Bdt7SrkVcw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 61FEE18AB2CC;
        Mon,  6 Apr 2020 22:13:06 +0000 (UTC)
Received: from Ruby.redhat.com (ovpn-117-12.rdu2.redhat.com [10.10.117.12])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2FB4E608E1;
        Mon,  6 Apr 2020 22:13:05 +0000 (UTC)
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
Subject: [PATCH v2 2/4] drm/dp_mst: Reformat drm_dp_check_act_status() a bit
Date:   Mon,  6 Apr 2020 18:12:51 -0400
Message-Id: <20200406221253.1307209-3-lyude@redhat.com>
In-Reply-To: <20200406221253.1307209-1-lyude@redhat.com>
References: <20200406221253.1307209-1-lyude@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Just add a bit more line wrapping, get rid of some extraneous
whitespace, remove an unneeded goto label, and move around some variable
declarations. No functional changes here.

Signed-off-by: Lyude Paul <lyude@redhat.com>
[this isn't a fix, but it's needed for the fix that comes after this]
Fixes: ad7f8a1f9ced ("drm/helper: add Displayport multi-stream helper (v0=
.6)")
Cc: Sean Paul <sean@poorly.run>
Cc: <stable@vger.kernel.org> # v3.17+
---
 drivers/gpu/drm/drm_dp_mst_topology.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c b/drivers/gpu/drm/drm_=
dp_mst_topology.c
index 828ca63cc576..c83adbdfc1cd 100644
--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -4473,33 +4473,31 @@ static int drm_dp_dpcd_write_payload(struct drm_d=
p_mst_topology_mgr *mgr,
  */
 int drm_dp_check_act_status(struct drm_dp_mst_topology_mgr *mgr)
 {
+	int count =3D 0, ret;
 	u8 status;
-	int ret;
-	int count =3D 0;
=20
 	do {
-		ret =3D drm_dp_dpcd_readb(mgr->aux, DP_PAYLOAD_TABLE_UPDATE_STATUS, &s=
tatus);
-
+		ret =3D drm_dp_dpcd_readb(mgr->aux,
+					DP_PAYLOAD_TABLE_UPDATE_STATUS,
+					&status);
 		if (ret < 0) {
-			DRM_DEBUG_KMS("failed to read payload table status %d\n", ret);
-			goto fail;
+			DRM_DEBUG_KMS("failed to read payload table status %d\n",
+				      ret);
+			return ret;
 		}
=20
 		if (status & DP_PAYLOAD_ACT_HANDLED)
 			break;
 		count++;
 		udelay(100);
-
 	} while (count < 30);
=20
 	if (!(status & DP_PAYLOAD_ACT_HANDLED)) {
-		DRM_DEBUG_KMS("failed to get ACT bit %d after %d retries\n", status, c=
ount);
-		ret =3D -EINVAL;
-		goto fail;
+		DRM_DEBUG_KMS("failed to get ACT bit %d after %d retries\n",
+			      status, count);
+		return -EINVAL;
 	}
 	return 0;
-fail:
-	return ret;
 }
 EXPORT_SYMBOL(drm_dp_check_act_status);
=20
--=20
2.25.1

