Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A418532F5D6
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 23:22:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbhCEWWG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 17:22:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56160 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229851AbhCEWWG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Mar 2021 17:22:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614982925;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=aPyMsdHMnfaSpLLwitdtmkV1UTfjg0RUBiyEq1fqjlk=;
        b=Ba60+t8/izwTxEjvGilUw7Av7LHpL9irPpPCnRn99AC3+KivhgDrqjqzlytFAYv5NNGFku
        oTp/IueEsiEmoL0W22LWejpkb3ROZ2d/mvCGiolyBRxk/5e+oICTLcAoAt/yFe7waGnA3l
        k7F/sa0VYJHEJFTqP1l+EmuUZfqfpMc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-177-PeNlqFzlPsSfWOOkoEvYJg-1; Fri, 05 Mar 2021 17:22:04 -0500
X-MC-Unique: PeNlqFzlPsSfWOOkoEvYJg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 238B3801814;
        Fri,  5 Mar 2021 22:22:02 +0000 (UTC)
Received: from Whitewolf.lyude.net (ovpn-117-70.rdu2.redhat.com [10.10.117.70])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E58B31A353;
        Fri,  5 Mar 2021 22:21:59 +0000 (UTC)
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
Subject: [PATCH v2] drm/nouveau/kms/nve4-nv108: Don't advertise 256x256 cursor support yet
Date:   Fri,  5 Mar 2021 17:21:33 -0500
Message-Id: <20210305222135.1269175-1-lyude@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

While Kepler does technically support 256x256 cursors, it turns out that
in order for us to use these correctly we need to make sure that the cursor
plane uses a ctxdma that is set to use small (4K)/large (128K) pages -
whichever is applicable to the given cursor surface.

Right now however, we share the main kmsVramCtxDma that is used for all but
the ovly plane which defaults to small pages - resulting in artifacts when
we use 256x256 cursor surfaces. So until we teach nouveau to use a separate
ctxdma for the cursor, let's just stop advertising 256x256 cursors by
default - which should fix the issues that users were seeing.

Coincidentally - this is also why small ovlys don't work on Kepler: the
ctxdma we use for ovlys is set to large pages.

Changes since v2:
* Fix comments and patch description

Signed-off-by: Lyude Paul <lyude@redhat.com>
Fixes: d3b2f0f7921c ("drm/nouveau/kms/nv50-: Report max cursor size to userspace")
Cc: <stable@vger.kernel.org> # v5.11+
---
 drivers/gpu/drm/nouveau/dispnv50/disp.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/dispnv50/disp.c b/drivers/gpu/drm/nouveau/dispnv50/disp.c
index 196612addfd6..d92cf9e17ac3 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/disp.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/disp.c
@@ -2693,9 +2693,19 @@ nv50_display_create(struct drm_device *dev)
 	else
 		nouveau_display(dev)->format_modifiers = disp50xx_modifiers;
 
-	if (disp->disp->object.oclass >= GK104_DISP) {
+	/* FIXME: 256x256 cursors are supported on Kepler, however unlike Maxwell and later
+	 * generations Kepler requires that we specify the page type, small (4K) or large (128K),
+	 * correctly for the ctxdma being used on curs/ovly. We currently share a ctxdma across all
+	 * display planes (except ovly) that defaults to small pages, which results in artifacting
+	 * on 256x256 cursors. Until we teach nouveau to create an appropriate ctxdma for the cursor
+	 * fb in use, simply avoid advertising support for 256x256 cursors.
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

