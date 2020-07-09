Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCD61219FAF
	for <lists+stable@lfdr.de>; Thu,  9 Jul 2020 14:09:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727813AbgGIMJL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jul 2020 08:09:11 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:23844 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727793AbgGIMJL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Jul 2020 08:09:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594296550;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cSBJnwtZxkuxYSzKBH9c9B94WHSOLk+uOszVIQWqTNs=;
        b=U7cu5m95rzxlv69+aMP4YChQp4t4r0XUpNF5NsedKNgyDt05UW+lsZ5c88lVSm5IyhZ6YC
        gJVgUV759XUvN0LVfvFV9F+wmam+sb57wNuzDhEQs7bCe5BBbabAATmNnTvOtleP87m7Gv
        haJ+DQr/Msvs4Me97FJ8ZWVlTpBQdcw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-282-ZtpswGCKOEyCfUbefg5ScQ-1; Thu, 09 Jul 2020 08:09:08 -0400
X-MC-Unique: ZtpswGCKOEyCfUbefg5ScQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 539E6107ACCA;
        Thu,  9 Jul 2020 12:09:07 +0000 (UTC)
Received: from x1.localdomain.com (ovpn-115-29.ams2.redhat.com [10.36.115.29])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0739F1053B28;
        Thu,  9 Jul 2020 12:09:03 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Hans de Goede <hdegoede@redhat.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH resend v2 2/8] virt: vbox: Fix guest capabilities mask check
Date:   Thu,  9 Jul 2020 14:08:52 +0200
Message-Id: <20200709120858.63928-3-hdegoede@redhat.com>
In-Reply-To: <20200709120858.63928-1-hdegoede@redhat.com>
References: <20200709120858.63928-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Check the passed in capabilities against VMMDEV_GUEST_CAPABILITIES_MASK
instead of against VMMDEV_EVENT_VALID_EVENT_MASK.
This tightens the allowed mask from 0x7ff to 0x7.

Fixes: 0ba002bc4393 ("virt: Add vboxguest driver for Virtual Box Guest integration")
Cc: stable@vger.kernel.org
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/virt/vboxguest/vboxguest_core.c | 2 +-
 drivers/virt/vboxguest/vmmdev.h         | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/virt/vboxguest/vboxguest_core.c b/drivers/virt/vboxguest/vboxguest_core.c
index 8fab04e76c14..18ebd7a6af98 100644
--- a/drivers/virt/vboxguest/vboxguest_core.c
+++ b/drivers/virt/vboxguest/vboxguest_core.c
@@ -1444,7 +1444,7 @@ static int vbg_ioctl_change_guest_capabilities(struct vbg_dev *gdev,
 	or_mask = caps->u.in.or_mask;
 	not_mask = caps->u.in.not_mask;
 
-	if ((or_mask | not_mask) & ~VMMDEV_EVENT_VALID_EVENT_MASK)
+	if ((or_mask | not_mask) & ~VMMDEV_GUEST_CAPABILITIES_MASK)
 		return -EINVAL;
 
 	ret = vbg_set_session_capabilities(gdev, session, or_mask, not_mask,
diff --git a/drivers/virt/vboxguest/vmmdev.h b/drivers/virt/vboxguest/vmmdev.h
index 6337b8d75d96..21f408120e3f 100644
--- a/drivers/virt/vboxguest/vmmdev.h
+++ b/drivers/virt/vboxguest/vmmdev.h
@@ -206,6 +206,8 @@ VMMDEV_ASSERT_SIZE(vmmdev_mask, 24 + 8);
  * not.
  */
 #define VMMDEV_GUEST_SUPPORTS_GRAPHICS                      BIT(2)
+/* The mask of valid capabilities, for sanity checking. */
+#define VMMDEV_GUEST_CAPABILITIES_MASK                      0x00000007U
 
 /** struct vmmdev_hypervisorinfo - Hypervisor info structure. */
 struct vmmdev_hypervisorinfo {
-- 
2.26.2

