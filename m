Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B35C37038A
	for <lists+stable@lfdr.de>; Sat,  1 May 2021 00:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230226AbhD3Wfk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Apr 2021 18:35:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57394 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231656AbhD3Wfj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Apr 2021 18:35:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619822090;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=pLPFkif6Bc1G5AuiGH/FaebyEZLmCnW8ksg8zeS6jOM=;
        b=Oa7FPiIf7knU5n0YohJOXs9YQgusRa0rTzDQGn5wJwQY497EdyGK2SueLtlELhr0la8vep
        p6WcJOWKwczNm2DNKuK5tDrZmCYH+Ih8fyiTZso0k9EqI3MOddUoq8NiziUQ79cAMARy/h
        hMvg+8Lg/6oUl7ArZLo3MQZ0KGo5nGw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-39-Vh_UcPDqPU2gws_TFRposg-1; Fri, 30 Apr 2021 18:34:46 -0400
X-MC-Unique: Vh_UcPDqPU2gws_TFRposg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8BD7B501F3;
        Fri, 30 Apr 2021 22:34:44 +0000 (UTC)
Received: from Whitewolf.redhat.com (ovpn-112-36.rdu2.redhat.com [10.10.112.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 00F415D755;
        Fri, 30 Apr 2021 22:34:42 +0000 (UTC)
From:   Lyude Paul <lyude@redhat.com>
To:     intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Cc:     =?UTF-8?q?J=C3=A9r=C3=B4me=20de=20Bretagne?= 
        <jerome.debretagne@gmail.com>, stable@vger.kernel.org,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, Sean Paul <sean@poorly.run>,
        Jani Nikula <jani.nikula@intel.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 1/2] drm/dp: Handle zeroed port counts in drm_dp_read_downstream_info()
Date:   Fri, 30 Apr 2021 18:34:27 -0400
Message-Id: <20210430223428.10514-1-lyude@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

While the DP specification isn't entirely clear on if this should be
allowed or not, some branch devices report having downstream ports present
while also reporting a downstream port count of 0. So to avoid breaking
those devices, we need to handle this in drm_dp_read_downstream_info().

So, to do this we assume there's no downstream port info when the
downstream port count is 0.

Signed-off-by: Lyude Paul <lyude@redhat.com>
Tested-by: Jérôme de Bretagne <jerome.debretagne@gmail.com>
Bugzilla: https://gitlab.freedesktop.org/drm/intel/-/issues/3416
Fixes: 3d3721ccb18a ("drm/i915/dp: Extract drm_dp_read_downstream_info()")
Cc: <stable@vger.kernel.org> # v5.10+
---
 drivers/gpu/drm/drm_dp_helper.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/drm_dp_helper.c b/drivers/gpu/drm/drm_dp_helper.c
index cb56d74e9d38..27c8c5bdf7d9 100644
--- a/drivers/gpu/drm/drm_dp_helper.c
+++ b/drivers/gpu/drm/drm_dp_helper.c
@@ -682,7 +682,14 @@ int drm_dp_read_downstream_info(struct drm_dp_aux *aux,
 	    !(dpcd[DP_DOWNSTREAMPORT_PRESENT] & DP_DWN_STRM_PORT_PRESENT))
 		return 0;
 
+	/* Some branches advertise having 0 downstream ports, despite also advertising they have a
+	 * downstream port present. The DP spec isn't clear on if this is allowed or not, but since
+	 * some branches do it we need to handle it regardless.
+	 */
 	len = drm_dp_downstream_port_count(dpcd);
+	if (!len)
+		return 0;
+
 	if (dpcd[DP_DOWNSTREAMPORT_PRESENT] & DP_DETAILED_CAP_INFO_AVAILABLE)
 		len *= 4;
 
-- 
2.30.2

