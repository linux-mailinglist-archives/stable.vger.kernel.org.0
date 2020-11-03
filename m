Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79B172A53E1
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:06:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387735AbgKCVFg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:05:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:44178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387843AbgKCVFg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:05:36 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE6D220658;
        Tue,  3 Nov 2020 21:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437535;
        bh=mXoUreHI0aNvEZzLZxyar8NXESuNJVxNrDSnXB+hF/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=091Gy3cnRCJAy7T3ajbkEpqWksBfb58qQCgWnuoLB86Mn3XgfuCtbkCeJfCT8h+/p
         xhDDos7nh5GHICNCl71SFvesp2PrDm0BapfUuhNbQKnfQMtvFFG1CtpnnLecit77ey
         1X+Bpkx9s/vGtVo3roDjuXhxlb8GqFUKxIYNCiHg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 4.19 117/191] media: uvcvideo: Fix uvc_ctrl_fixup_xu_info() not having any effect
Date:   Tue,  3 Nov 2020 21:36:49 +0100
Message-Id: <20201103203244.321392388@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203232.656475008@linuxfoundation.org>
References: <20201103203232.656475008@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit 93df48d37c3f03886d84831992926333e7810640 upstream.

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
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/usb/uvc/uvc_ctrl.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -2038,13 +2038,6 @@ static int uvc_ctrl_add_info(struct uvc_
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
@@ -2267,6 +2260,13 @@ static void uvc_ctrl_init_ctrl(struct uv
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


