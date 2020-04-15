Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF1E61AB2B0
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 22:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S371255AbgDOUdE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 16:33:04 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:35627 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S371253AbgDOUdB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Apr 2020 16:33:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586982779;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3/8KUtsnW6PKzv+JyQxeDkng6h8D93TNwqRBT5VMBaA=;
        b=cipx6RAXOwaYKMh+PWonowC5u/tE3GTJZ53bnVoTEI8dRPQnA0laVzefwyK0uRdpl6QZjW
        iNNR9D5cO2rjrUoCG3mUU/6+8C7pDYNKdJ9dRL0psYLOw41oVXnPqzjfvIn/I5UMM8xcDc
        RN41FJr4uwK9hw3qQvpO8N8IHFzJKe0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-264-AYD5ubVRPHaPt6L3V-c56Q-1; Wed, 15 Apr 2020 16:32:52 -0400
X-MC-Unique: AYD5ubVRPHaPt6L3V-c56Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9E8BD801A01;
        Wed, 15 Apr 2020 20:32:50 +0000 (UTC)
Received: from Ruby.redhat.com (ovpn-119-161.rdu2.redhat.com [10.10.119.161])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5402A18A85;
        Wed, 15 Apr 2020 20:32:47 +0000 (UTC)
From:   Lyude Paul <lyude@redhat.com>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, Sean Paul <sean@poorly.run>,
        Wayne Lin <Wayne.Lin@amd.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drm/dp_mst: Fix clearing payload state on topology disable
Date:   Wed, 15 Apr 2020 16:32:37 -0400
Message-Id: <20200415203237.2064485-1-lyude@redhat.com>
In-Reply-To: <1586950297139145@kroah.com>
References: <1586950297139145@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Cc: Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com>
Cc: stable@vger.kernel.org # v4.4+
Signed-off-by: Lyude Paul <lyude@redhat.com>
Reviewed-by: Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200122194321.14953-=
1-lyude@redhat.com
---

Hey Greg! This should apply to 5.6, I'll check in just a little bit
whether or not I need to backport this to other kernel versions as well

 drivers/gpu/drm/drm_dp_mst_topology.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c b/drivers/gpu/drm/drm_=
dp_mst_topology.c
index ed0fea2ac322..50607f14fad2 100644
--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -3507,6 +3507,7 @@ int drm_dp_mst_topology_mgr_set_mst(struct drm_dp_m=
st_topology_mgr *mgr, bool ms
 	int i =3D 0;
 	struct drm_dp_mst_branch *mstb =3D NULL;
=20
+	mutex_lock(&mgr->payload_lock);
 	mutex_lock(&mgr->lock);
 	if (mst_state =3D=3D mgr->mst_state)
 		goto out_unlock;
@@ -3565,8 +3566,10 @@ int drm_dp_mst_topology_mgr_set_mst(struct drm_dp_=
mst_topology_mgr *mgr, bool ms
 		/* this can fail if the device is gone */
 		drm_dp_dpcd_writeb(mgr->aux, DP_MSTM_CTRL, 0);
 		ret =3D 0;
-		mutex_lock(&mgr->payload_lock);
-		memset(mgr->payloads, 0, mgr->max_payloads * sizeof(struct drm_dp_payl=
oad));
+		memset(mgr->payloads, 0,
+		       mgr->max_payloads * sizeof(mgr->payloads[0]));
+		memset(mgr->proposed_vcpis, 0,
+		       mgr->max_payloads * sizeof(mgr->proposed_vcpis[0]));
 		mgr->payload_mask =3D 0;
 		set_bit(0, &mgr->payload_mask);
 		for (i =3D 0; i < mgr->max_payloads; i++) {
@@ -3579,13 +3582,12 @@ int drm_dp_mst_topology_mgr_set_mst(struct drm_dp=
_mst_topology_mgr *mgr, bool ms
 			mgr->proposed_vcpis[i] =3D NULL;
 		}
 		mgr->vcpi_mask =3D 0;
-		mutex_unlock(&mgr->payload_lock);
-
 		mgr->payload_id_table_cleared =3D false;
 	}
=20
 out_unlock:
 	mutex_unlock(&mgr->lock);
+	mutex_unlock(&mgr->payload_lock);
 	if (mstb)
 		drm_dp_mst_topology_put_mstb(mstb);
 	return ret;
--=20
2.25.1

