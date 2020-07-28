Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DFFA230890
	for <lists+stable@lfdr.de>; Tue, 28 Jul 2020 13:22:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728996AbgG1LWU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jul 2020 07:22:20 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:21655 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728985AbgG1LWT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jul 2020 07:22:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595935338;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=OM8kQeBlgXTVmT6/iyptsReY/9gmQ0oUbCzvizJ2goY=;
        b=ZayuLxTgsSNAqxeNv9+d/7lJPXv8pp+zGd+f9eoeEdfcCAGXnHAQvlXKhKebMVByAVTiqn
        bLKxVr6sLLpBteV95afxEYOOMEJ3BVMZDHcqRNU6uJCkWqH7znOJ5LYSlNySII/VR7giBB
        RyX18NXN5awhfby7eTowStJILpfEZh0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-331-e2hbXsfsMSaatcGi02Zpjg-1; Tue, 28 Jul 2020 07:22:16 -0400
X-MC-Unique: e2hbXsfsMSaatcGi02Zpjg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3702D801A03;
        Tue, 28 Jul 2020 11:22:15 +0000 (UTC)
Received: from x1.localdomain.com (ovpn-114-116.ams2.redhat.com [10.36.114.116])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 24F2E7BD60;
        Tue, 28 Jul 2020 11:22:10 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Hans de Goede <hdegoede@redhat.com>, linux-media@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH v2 1/2] media: uvcvideo: Fix uvc_ctrl_fixup_xu_info() not having any effect
Date:   Tue, 28 Jul 2020 13:22:08 +0200
Message-Id: <20200728112209.26207-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

uvc_ctrl_add_info() calls uvc_ctrl_get_flags() which will override
the fixed-up flags set by uvc_ctrl_fixup_xu_info().

uvc_ctrl_init_xu_ctrl() already calls uvc_ctrl_get_flags() before
calling uvc_ctrl_add_info(), so the uvc_ctrl_get_flags() call in
uvc_ctrl_add_info() is not necessary for xu ctrls.

This commit moves the uvc_ctrl_get_flags() call for normal controls
from uvc_ctrl_add_info() to uvc_ctrl_init_ctrl(), so that we no longer
call uvc_ctrl_get_flags() twice for xu controls and so that we no longer
override the fixed-up flags set by uvc_ctrl_fixup_xu_info().

This fixes the xu motor controls not working properly on a Logitech
046d:08cc, and presumably also on the other Logitech models which have
a quirk for this in the uvc_ctrl_fixup_xu_info() function.

Cc: stable@vger.kernel.org
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
Changes in v2:
- Move the uvc_ctrl_get_flags() call for normal controls to uvc_ctrl_init_ctrl()
---
 drivers/media/usb/uvc/uvc_ctrl.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
index e399b9fad757..b78aba991212 100644
--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -2024,13 +2024,6 @@ static int uvc_ctrl_add_info(struct uvc_device *dev, struct uvc_control *ctrl,
 		goto done;
 	}
 
-	/*
-	 * Retrieve control flags from the device. Ignore errors and work with
-	 * default flag values from the uvc_ctrl array when the device doesn't
-	 * properly implement GET_INFO on standard controls.
-	 */
-	uvc_ctrl_get_flags(dev, ctrl, &ctrl->info);
-
 	ctrl->initialized = 1;
 
 	uvc_trace(UVC_TRACE_CONTROL, "Added control %pUl/%u to device %s "
@@ -2253,6 +2246,13 @@ static void uvc_ctrl_init_ctrl(struct uvc_device *dev, struct uvc_control *ctrl)
 		if (uvc_entity_match_guid(ctrl->entity, info->entity) &&
 		    ctrl->index == info->index) {
 			uvc_ctrl_add_info(dev, ctrl, info);
+			/*
+			 * Retrieve control flags from the device. Ignore errors
+			 * and work with default flag values from the uvc_ctrl
+			 * array when the device doesn't properly implement
+			 * GET_INFO on standard controls.
+			 */
+			uvc_ctrl_get_flags(dev, ctrl, &ctrl->info);
 			break;
 		 }
 	}
-- 
2.26.2

