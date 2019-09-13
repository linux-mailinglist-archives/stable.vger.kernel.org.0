Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1FB3B27FE
	for <lists+stable@lfdr.de>; Sat, 14 Sep 2019 00:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403805AbfIMWFP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 18:05:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38266 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390545AbfIMWFO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 18:05:14 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1DC113CA19;
        Fri, 13 Sep 2019 22:05:14 +0000 (UTC)
Received: from malachite.bss.redhat.com (dhcp-10-20-1-34.bss.redhat.com [10.20.1.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1DC02600C6;
        Fri, 13 Sep 2019 22:05:10 +0000 (UTC)
From:   Lyude Paul <lyude@redhat.com>
To:     nouveau@lists.freedesktop.org
Cc:     stable@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Sam Ravnborg <sam@ravnborg.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Ilia Mirkin <imirkin@alum.mit.edu>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] drm/nouveau: dispnv50: Don't create MSTMs for eDP connectors
Date:   Fri, 13 Sep 2019 18:03:50 -0400
Message-Id: <20190913220355.6883-1-lyude@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Fri, 13 Sep 2019 22:05:14 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On the ThinkPad P71, we have one eDP connector exposed along with 5 DP
connectors, resulting in a total of 11 TMDS encoders. Since the GPU on
this system is also capable of MST, we create an additional 4 fake MST
encoders for each DP port. Unfortunately, we also do this for the eDP
port as well, resulting in:

  1 eDP port: +1 TMDS encoder
              +4 DPMST encoders
  5 DP ports: +2 TMDS encoders
              +4 DPMST encoders
	      *5 ports
	      == 35 encoders

Which breaks things, since DRM has a hard coded limit of 32 encoders.
So, fix this by not creating MSTMs for any eDP connectors. This brings
us down to 31 encoders, although we can do better.

This fixes driver probing for nouveau on the ThinkPad P71.

Signed-off-by: Lyude Paul <lyude@redhat.com>
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/nouveau/dispnv50/disp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/dispnv50/disp.c b/drivers/gpu/drm/nouveau/dispnv50/disp.c
index 307584107d77..b46be8a091e9 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/disp.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/disp.c
@@ -1603,7 +1603,8 @@ nv50_sor_create(struct drm_connector *connector, struct dcb_output *dcbe)
 			nv_encoder->aux = aux;
 		}
 
-		if ((data = nvbios_dp_table(bios, &ver, &hdr, &cnt, &len)) &&
+		if (nv_connector->type != DCB_CONNECTOR_eDP &&
+		    (data = nvbios_dp_table(bios, &ver, &hdr, &cnt, &len)) &&
 		    ver >= 0x40 && (nvbios_rd08(bios, data + 0x08) & 0x04)) {
 			ret = nv50_mstm_new(nv_encoder, &nv_connector->aux, 16,
 					    nv_connector->base.base.id,
-- 
2.21.0

