Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77A1F452513
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:43:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344406AbhKPBqm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:46:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:36754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241901AbhKOSZn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:25:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D6F26342B;
        Mon, 15 Nov 2021 17:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998956;
        bh=c9e0JVzpYrCDaXhy2yfRx+e3NlUNzE9VIMxJ2XvqOZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R8xxJtJh9kmLAkLkvWSoGW/KABV8GlGE+BbbqnwPwaLDWEVBjD1uAiGjfAO/O1VyA
         rUGjkC8BE4dNhfieO142W5RMOAMKvvP/KDkPaFeN+WvhM7khUQuyG7N+0hfpCWl/hy
         20ATIKXB3hEm3HLeoS0dWMoopPPtUJWjqH/pBf8A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maximilian Luz <luzmaximilian@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 5.14 123/849] HID: surface-hid: Use correct event registry for managing HID events
Date:   Mon, 15 Nov 2021 17:53:26 +0100
Message-Id: <20211115165424.257619685@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maximilian Luz <luzmaximilian@gmail.com>

commit dc0fd0acb6e0e8025a0a43ada54513b216254fac upstream.

Until now, we have only ever seen the REG-category registry being used
on devices addressed with target ID 2. In fact, we have only ever seen
Surface Aggregator Module (SAM) HID devices with target ID 2. For those
devices, the registry also has to be addressed with target ID 2.

Some devices, like the new Surface Laptop Studio, however, address their
HID devices on target ID 1. As a result of this, any target ID 2
commands time out. This includes event management commands addressed to
the target ID 2 REG-category registry. For these devices, the registry
has to be addressed via target ID 1 instead.

We therefore assume that the target ID of the registry to be used
depends on the target ID of the respective device. Implement this
accordingly.

Note that we currently allow the surface HID driver to only load against
devices with target ID 2, so these timeouts are not happening (yet).
This is just a preparation step before we allow the driver to load
against all target IDs.

Cc: stable@vger.kernel.org # 5.14+
Signed-off-by: Maximilian Luz <luzmaximilian@gmail.com>
Acked-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Link: https://lore.kernel.org/r/20211021130904.862610-3-luzmaximilian@gmail.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/surface-hid/surface_hid.c         |    2 +-
 include/linux/surface_aggregator/controller.h |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/hid/surface-hid/surface_hid.c
+++ b/drivers/hid/surface-hid/surface_hid.c
@@ -209,7 +209,7 @@ static int surface_hid_probe(struct ssam
 
 	shid->notif.base.priority = 1;
 	shid->notif.base.fn = ssam_hid_event_fn;
-	shid->notif.event.reg = SSAM_EVENT_REGISTRY_REG;
+	shid->notif.event.reg = SSAM_EVENT_REGISTRY_REG(sdev->uid.target);
 	shid->notif.event.id.target_category = sdev->uid.category;
 	shid->notif.event.id.instance = sdev->uid.instance;
 	shid->notif.event.mask = SSAM_EVENT_MASK_STRICT;
--- a/include/linux/surface_aggregator/controller.h
+++ b/include/linux/surface_aggregator/controller.h
@@ -792,8 +792,8 @@ enum ssam_event_mask {
 #define SSAM_EVENT_REGISTRY_KIP	\
 	SSAM_EVENT_REGISTRY(SSAM_SSH_TC_KIP, 0x02, 0x27, 0x28)
 
-#define SSAM_EVENT_REGISTRY_REG \
-	SSAM_EVENT_REGISTRY(SSAM_SSH_TC_REG, 0x02, 0x01, 0x02)
+#define SSAM_EVENT_REGISTRY_REG(tid)\
+	SSAM_EVENT_REGISTRY(SSAM_SSH_TC_REG, tid, 0x01, 0x02)
 
 /**
  * enum ssam_event_notifier_flags - Flags for event notifiers.


