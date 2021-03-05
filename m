Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91F7C32DF40
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 02:53:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbhCEBw7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 20:52:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56352 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229564AbhCEBw7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Mar 2021 20:52:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614909178;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=1PouAGyaEAojf3ovTLFX1yOmiU99mhHbemhpq78aaTo=;
        b=fTiapm5qm/coo+vtDgKpiclSo6I5ELEFVdKDmCUKOKwMuQf+xdKRw7XGf76Vmct8PPyQGi
        IPsNSu7RnIZrXG8YL/7p4YcvdkW/VDaTSLr21FtxNmnVLo/CxQYuAzlOv0SZbNwEpM6zzY
        tg+7RG76c53HrvThOkL5Ok+C++krqEw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-21-aoH0ADXoPxG-HWKJhQM3Yw-1; Thu, 04 Mar 2021 20:52:56 -0500
X-MC-Unique: aoH0ADXoPxG-HWKJhQM3Yw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 56E2F1842142;
        Fri,  5 Mar 2021 01:52:54 +0000 (UTC)
Received: from Whitewolf.lyude.net (ovpn-113-27.rdu2.redhat.com [10.10.113.27])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9FCD52BFEB;
        Fri,  5 Mar 2021 01:52:52 +0000 (UTC)
From:   Lyude Paul <lyude@redhat.com>
To:     nouveau@lists.freedesktop.org
Cc:     stable@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Airlie <airlied@redhat.com>,
        Pankaj Bharadiya <pankaj.laxminarayan.bharadiya@intel.com>,
        James Jones <jajones@nvidia.com>,
        dri-devel@lists.freedesktop.org (open list:DRM DRIVER FOR NVIDIA
        GEFORCE/QUADRO GPUS), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] drm/nouveau/kms/nve4-nv108: Limit cursors to 128x128
Date:   Thu,  4 Mar 2021 20:52:41 -0500
Message-Id: <20210305015242.740590-1-lyude@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

While Kepler does technically support 256x256 cursors, it turns out that
Kepler actually has some additional requirements for scanout surfaces that
we're not enforcing correctly, which aren't present on Maxwell and later.
Cursor surfaces must always use small pages (4K), and overlay surfaces must
always use large pages (128K).

Fixing this correctly though will take a bit more work: as we'll need to
add some code in prepare_fb() to move cursor FBs in large pages to small
pages, and vice-versa for overlay FBs. So until we have the time to do
that, just limit cursor surfaces to 128x128 - a size small enough to always
default to small pages.

This means small ovlys are still broken on Kepler, but it is extremely
unlikely anyone cares about those anyway :).

Signed-off-by: Lyude Paul <lyude@redhat.com>
Fixes: d3b2f0f7921c ("drm/nouveau/kms/nv50-: Report max cursor size to userspace")
Cc: <stable@vger.kernel.org> # v5.11+
---
 drivers/gpu/drm/nouveau/dispnv50/disp.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/dispnv50/disp.c b/drivers/gpu/drm/nouveau/dispnv50/disp.c
index 196612addfd6..1c9c0cdf85db 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/disp.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/disp.c
@@ -2693,9 +2693,20 @@ nv50_display_create(struct drm_device *dev)
 	else
 		nouveau_display(dev)->format_modifiers = disp50xx_modifiers;
 
-	if (disp->disp->object.oclass >= GK104_DISP) {
+	/* FIXME: 256x256 cursors are supported on Kepler, however unlike Maxwell and later
+	 * generations Kepler requires that we use small pages (4K) for cursor scanout surfaces. The
+	 * proper fix for this is to teach nouveau to migrate fbs being used for the cursor plane to
+	 * small page allocations in prepare_fb(). When this is implemented, we should also force
+	 * large pages (128K) for ovly fbs in order to fix Kepler ovlys.
+	 * But until then, just limit cursors to 128x128 - which is small enough to avoid ever using
+	 * large pages.
+	 */
+	if (disp->disp->object.oclass >= GM107_DISP) {
 		dev->mode_config.cursor_width = 256;
 		dev->mode_config.cursor_height = 256;
+	} else if (disp->disp->object.oclass >= GK104_DISP) {
+		dev->mode_config.cursor_width = 128;
+		dev->mode_config.cursor_height = 128;
 	} else {
 		dev->mode_config.cursor_width = 64;
 		dev->mode_config.cursor_height = 64;
-- 
2.29.2

