Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8DDC3C14EB
	for <lists+stable@lfdr.de>; Thu,  8 Jul 2021 16:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231593AbhGHOQw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Jul 2021 10:16:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58186 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231152AbhGHOQw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Jul 2021 10:16:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625753650;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=TntTIb+1S1FuwVReDa+/7xgwmFfelIwb8SEWxcwP4uk=;
        b=Yl3owvWm/p+O2RvzIJfReQnCcjJ/GnyxMXicppkQtRSeBhC2ttMlUPACtsGnf4LE/U//UN
        qEGPu33MdDIEpuLUhyNpLAH1GVljY4URyl6i1GrDZKSGoPseHK7+jX70rc2rNxhlu68Y3Q
        a5QQKpApXA9nxabBC8Y5cANjXcJNNCk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-197-no09P7ZuMFGIzIP2Yguptw-1; Thu, 08 Jul 2021 10:14:08 -0400
X-MC-Unique: no09P7ZuMFGIzIP2Yguptw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 28B9E1084F54;
        Thu,  8 Jul 2021 14:14:07 +0000 (UTC)
Received: from x1.localdomain (ovpn-114-156.ams2.redhat.com [10.36.114.156])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EA9CC5D6D1;
        Thu,  8 Jul 2021 14:14:05 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Hans de Goede <hdegoede@redhat.com>, linux-media@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH for 5.10.y] media: uvcvideo: Support devices that report an OT as an entity source
Date:   Thu,  8 Jul 2021 16:14:04 +0200
Message-Id: <20210708141404.14826-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

[ Upstream commit 4ca052b4ea621d0002a5e5feace51f60ad5e6b23 ]

Some devices reference an output terminal as the source of extension
units. This is incorrect, as output terminals only have an input pin,
and thus can't be connected to any entity in the forward direction. The
resulting topology would cause issues when registering the media
controller graph. To avoid this problem, connect the extension unit to
the source of the output terminal instead.

While at it, and while no device has been reported to be affected by
this issue, also handle forward scans where two output terminals would
be connected together, and skip the terminals found through such an
invalid connection.

Cc: stable@vger.kernel.org # v5.10
Reported-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/media/usb/uvc/uvc_driver.c | 32 ++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 5ad528264135..282f3d2388cc 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -1588,6 +1588,31 @@ static int uvc_scan_chain_forward(struct uvc_video_chain *chain,
 				return -EINVAL;
 			}
 
+			/*
+			 * Some devices reference an output terminal as the
+			 * source of extension units. This is incorrect, as
+			 * output terminals only have an input pin, and thus
+			 * can't be connected to any entity in the forward
+			 * direction. The resulting topology would cause issues
+			 * when registering the media controller graph. To
+			 * avoid this problem, connect the extension unit to
+			 * the source of the output terminal instead.
+			 */
+			if (UVC_ENTITY_IS_OTERM(entity)) {
+				struct uvc_entity *source;
+
+				source = uvc_entity_by_id(chain->dev,
+							  entity->baSourceID[0]);
+				if (!source) {
+					uvc_trace(UVC_TRACE_DESCR,
+						"Can't connect extension unit %u in chain\n",
+						forward->id);
+					break;
+				}
+
+				forward->baSourceID[0] = source->id;
+			}
+
 			list_add_tail(&forward->chain, &chain->entities);
 			if (uvc_trace_param & UVC_TRACE_PROBE) {
 				if (!found)
@@ -1608,6 +1633,13 @@ static int uvc_scan_chain_forward(struct uvc_video_chain *chain,
 				return -EINVAL;
 			}
 
+			if (UVC_ENTITY_IS_OTERM(entity)) {
+				uvc_trace(UVC_TRACE_DESCR,
+					"Unsupported connection between output terminals %u and %u\n",
+					entity->id, forward->id);
+				break;
+			}
+
 			list_add_tail(&forward->chain, &chain->entities);
 			if (uvc_trace_param & UVC_TRACE_PROBE) {
 				if (!found)
-- 
2.31.1

