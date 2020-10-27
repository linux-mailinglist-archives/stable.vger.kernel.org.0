Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6908229AF83
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:13:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1755324AbgJ0OJ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:09:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:58596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1735637AbgJ0OJX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:09:23 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8ED822202;
        Tue, 27 Oct 2020 14:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603807763;
        bh=iyP0gQBHcNYb8zjOSjoeuVpWcvdMV1cP4U7E/BOAFaQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K1uysUJtGgESAcbAPhTsI+NS9AzBxdEaCqfdGvDEAEtn5s87tEpBkkw3apYAB6+VC
         DzFLzIgnhEDAmTfp93TCBWxyuetHUC1fbML5wmcx45D5lLP0BjkvqpPoEnsbZAV4it
         BMaWtvA5y1TczbDPVbYOmxtXIsIQLYlGDwVpMsdU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 031/191] media: uvcvideo: Set media controller entity functions
Date:   Tue, 27 Oct 2020 14:48:06 +0100
Message-Id: <20201027134911.234430302@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134909.701581493@linuxfoundation.org>
References: <20201027134909.701581493@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

[ Upstream commit d6834b4b58d110814aaf3469e7fd87d34ae5ae81 ]

The media controller core prints a warning when an entity is registered
without a function being set. This affects the uvcvideo driver, as the
warning was added without first addressing the issue in existing
drivers. The problem is harmless, but unnecessarily worries users. Fix
it by mapping UVC entity types to MC entity functions as accurately as
possible using the existing functions.

Fixes: b50bde4e476d ("[media] v4l2-subdev: use MEDIA_ENT_T_UNKNOWN for new subdevs")
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_entity.c | 35 ++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/drivers/media/usb/uvc/uvc_entity.c b/drivers/media/usb/uvc/uvc_entity.c
index 554063c07d7a2..f2457953f27c6 100644
--- a/drivers/media/usb/uvc/uvc_entity.c
+++ b/drivers/media/usb/uvc/uvc_entity.c
@@ -78,10 +78,45 @@ static int uvc_mc_init_entity(struct uvc_video_chain *chain,
 	int ret;
 
 	if (UVC_ENTITY_TYPE(entity) != UVC_TT_STREAMING) {
+		u32 function;
+
 		v4l2_subdev_init(&entity->subdev, &uvc_subdev_ops);
 		strlcpy(entity->subdev.name, entity->name,
 			sizeof(entity->subdev.name));
 
+		switch (UVC_ENTITY_TYPE(entity)) {
+		case UVC_VC_SELECTOR_UNIT:
+			function = MEDIA_ENT_F_VID_MUX;
+			break;
+		case UVC_VC_PROCESSING_UNIT:
+		case UVC_VC_EXTENSION_UNIT:
+			/* For lack of a better option. */
+			function = MEDIA_ENT_F_PROC_VIDEO_PIXEL_FORMATTER;
+			break;
+		case UVC_COMPOSITE_CONNECTOR:
+		case UVC_COMPONENT_CONNECTOR:
+			function = MEDIA_ENT_F_CONN_COMPOSITE;
+			break;
+		case UVC_SVIDEO_CONNECTOR:
+			function = MEDIA_ENT_F_CONN_SVIDEO;
+			break;
+		case UVC_ITT_CAMERA:
+			function = MEDIA_ENT_F_CAM_SENSOR;
+			break;
+		case UVC_TT_VENDOR_SPECIFIC:
+		case UVC_ITT_VENDOR_SPECIFIC:
+		case UVC_ITT_MEDIA_TRANSPORT_INPUT:
+		case UVC_OTT_VENDOR_SPECIFIC:
+		case UVC_OTT_DISPLAY:
+		case UVC_OTT_MEDIA_TRANSPORT_OUTPUT:
+		case UVC_EXTERNAL_VENDOR_SPECIFIC:
+		default:
+			function = MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN;
+			break;
+		}
+
+		entity->subdev.entity.function = function;
+
 		ret = media_entity_pads_init(&entity->subdev.entity,
 					entity->num_pads, entity->pads);
 
-- 
2.25.1



