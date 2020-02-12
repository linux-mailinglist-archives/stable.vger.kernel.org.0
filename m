Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7109815B448
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 00:01:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729285AbgBLXBM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Feb 2020 18:01:12 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:44170 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729254AbgBLXBI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Feb 2020 18:01:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581548468;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7WLsIYS6APukqpz4dC2as0jWPB7g29dh0U9M8tvQiMs=;
        b=P22tE73ZtKiciZBii3PzFvmpSBUXiSNffz8dI+MOJ0quKLI61TO5vG5EoohvlsfdtpX4W4
        fwnxHeo5V1y48ZPYCKOvgZ3oA05UEc5cwjX7zSCWDNJDTBStr9theNEfB5l1uxtlyyDL8m
        WZuAIJ9RvztF3FNSWHQZc7pdX3u6WTk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-73-As5XGrl2OLWpVQwo5cF7Zw-1; Wed, 12 Feb 2020 18:00:58 -0500
X-MC-Unique: As5XGrl2OLWpVQwo5cF7Zw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4CC8D1084430;
        Wed, 12 Feb 2020 23:00:56 +0000 (UTC)
Received: from Ruby.bss.redhat.com (dhcp-10-20-1-196.bss.redhat.com [10.20.1.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0DE1C5C137;
        Wed, 12 Feb 2020 23:00:54 +0000 (UTC)
From:   Lyude Paul <lyude@redhat.com>
To:     nouveau@lists.freedesktop.org
Cc:     stable@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Sean Paul <seanpaul@chromium.org>,
        Mikita Lipski <mikita.lipski@amd.com>,
        Manasi Navare <manasi.d.navare@intel.com>,
        Takashi Iwai <tiwai@suse.de>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] drm/nouveau/kms/nv50-: Move 8BPC limit for MST into nv50_mstc_get_modes()
Date:   Wed, 12 Feb 2020 18:00:37 -0500
Message-Id: <20200212230043.170477-4-lyude@redhat.com>
In-Reply-To: <20200212230043.170477-1-lyude@redhat.com>
References: <20200212230043.170477-1-lyude@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This just limits the BPC for MST connectors to a maximum of 8 from
nv50_mstc_get_modes(), instead of doing so during
nv50_msto_atomic_check(). This doesn't introduce any functional changes
yet (other then userspace now lying about the max bpc, but we can't
support that yet anyway so meh). But, we'll need this in a moment so
that we can share mode validation between SST and MST which will fix
some real world issues.

Signed-off-by: Lyude Paul <lyude@redhat.com>
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/nouveau/dispnv50/disp.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/dispnv50/disp.c b/drivers/gpu/drm/no=
uveau/dispnv50/disp.c
index 32a1c4221f1e..766b8e80a8f5 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/disp.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/disp.c
@@ -903,15 +903,9 @@ nv50_msto_atomic_check(struct drm_encoder *encoder,
 	if (!state->duplicated) {
 		const int clock =3D crtc_state->adjusted_mode.clock;
=20
-		/*
-		 * XXX: Since we don't use HDR in userspace quite yet, limit
-		 * the bpc to 8 to save bandwidth on the topology. In the
-		 * future, we'll want to properly fix this by dynamically
-		 * selecting the highest possible bpc that would fit in the
-		 * topology
-		 */
-		asyh->or.bpc =3D min(connector->display_info.bpc, 8U);
-		asyh->dp.pbn =3D drm_dp_calc_pbn_mode(clock, asyh->or.bpc * 3, false);
+		asyh->or.bpc =3D connector->display_info.bpc;
+		asyh->dp.pbn =3D drm_dp_calc_pbn_mode(clock, asyh->or.bpc * 3,
+						    false);
 	}
=20
 	slots =3D drm_dp_atomic_find_vcpi_slots(state, &mstm->mgr, mstc->port,
@@ -1071,8 +1065,17 @@ nv50_mstc_get_modes(struct drm_connector *connecto=
r)
 	if (mstc->edid)
 		ret =3D drm_add_edid_modes(&mstc->connector, mstc->edid);
=20
-	if (!mstc->connector.display_info.bpc)
-		mstc->connector.display_info.bpc =3D 8;
+	/*
+	 * XXX: Since we don't use HDR in userspace quite yet, limit the bpc
+	 * to 8 to save bandwidth on the topology. In the future, we'll want
+	 * to properly fix this by dynamically selecting the highest possible
+	 * bpc that would fit in the topology
+	 */
+	if (connector->display_info.bpc)
+		connector->display_info.bpc =3D
+			clamp(connector->display_info.bpc, 6U, 8U);
+	else
+		connector->display_info.bpc =3D 8;
=20
 	if (mstc->native)
 		drm_mode_destroy(mstc->connector.dev, mstc->native);
--=20
2.24.1

