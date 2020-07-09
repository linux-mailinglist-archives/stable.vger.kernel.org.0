Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83EE1219FA2
	for <lists+stable@lfdr.de>; Thu,  9 Jul 2020 14:09:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727807AbgGIMJL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jul 2020 08:09:11 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:38855 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727123AbgGIMJK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Jul 2020 08:09:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594296548;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4HvcnIOSqXDo+LsHrrrorXN42Sd6iTBEW4v8IUbkJdU=;
        b=b7d8rKLJqstYCF+BR0XYb8QvvTYTqsh7XZw7D1H7eN5InpoUY/o1eCpr9dVogy7wi6E1xV
        OMx0wN/PlnPOyUBAGNgTZfrDK7TzevpJb/d+147DDLq4Ky9Bixp2WH8flagGIfEjZVU59V
        5K/72ZJJ5CZS/5f71gcfy/whUC73uqQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-315-WxX9iofcMdSNSg3TRJWWcQ-1; Thu, 09 Jul 2020 08:09:04 -0400
X-MC-Unique: WxX9iofcMdSNSg3TRJWWcQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A718E10059DE;
        Thu,  9 Jul 2020 12:09:03 +0000 (UTC)
Received: from x1.localdomain.com (ovpn-115-29.ams2.redhat.com [10.36.115.29])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BE4D81053B28;
        Thu,  9 Jul 2020 12:09:01 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Hans de Goede <hdegoede@redhat.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH resend v2 1/8] virt: vbox: Fix VBGL_IOCTL_VMMDEV_REQUEST_BIG and _LOG req numbers to match upstream
Date:   Thu,  9 Jul 2020 14:08:51 +0200
Message-Id: <20200709120858.63928-2-hdegoede@redhat.com>
In-Reply-To: <20200709120858.63928-1-hdegoede@redhat.com>
References: <20200709120858.63928-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Until this commit the mainline kernel version (this version) of the
vboxguest module contained a bug where it defined
VBGL_IOCTL_VMMDEV_REQUEST_BIG and VBGL_IOCTL_LOG using
_IOC(_IOC_READ | _IOC_WRITE, 'V', ...) instead of
_IO(V, ...) as the out of tree VirtualBox upstream version does.

Since the VirtualBox userspace bits are always built against VirtualBox
upstream's headers, this means that so far the mainline kernel version
of the vboxguest module has been failing these 2 ioctls with -ENOTTY.
I guess that VBGL_IOCTL_VMMDEV_REQUEST_BIG is never used causing us to
not hit that one and sofar the vboxguest driver has failed to actually
log any log messages passed it through VBGL_IOCTL_LOG.

This commit changes the VBGL_IOCTL_VMMDEV_REQUEST_BIG and VBGL_IOCTL_LOG
defines to match the out of tree VirtualBox upstream vboxguest version,
while keeping compatibility with the old wrong request defines so as
to not break the kernel ABI in case someone has been using the old
request defines.

Fixes: f6ddd094f579 ("virt: Add vboxguest driver for Virtual Box Guest integration UAPI")
Cc: stable@vger.kernel.org
Acked-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/virt/vboxguest/vboxguest_core.c  |  4 +++-
 drivers/virt/vboxguest/vboxguest_core.h  | 15 +++++++++++++++
 drivers/virt/vboxguest/vboxguest_linux.c |  3 ++-
 include/uapi/linux/vboxguest.h           |  4 ++--
 4 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/drivers/virt/vboxguest/vboxguest_core.c b/drivers/virt/vboxguest/vboxguest_core.c
index b690a8a4bf9e..8fab04e76c14 100644
--- a/drivers/virt/vboxguest/vboxguest_core.c
+++ b/drivers/virt/vboxguest/vboxguest_core.c
@@ -1520,7 +1520,8 @@ int vbg_core_ioctl(struct vbg_session *session, unsigned int req, void *data)
 
 	/* For VMMDEV_REQUEST hdr->type != VBG_IOCTL_HDR_TYPE_DEFAULT */
 	if (req_no_size == VBG_IOCTL_VMMDEV_REQUEST(0) ||
-	    req == VBG_IOCTL_VMMDEV_REQUEST_BIG)
+	    req == VBG_IOCTL_VMMDEV_REQUEST_BIG ||
+	    req == VBG_IOCTL_VMMDEV_REQUEST_BIG_ALT)
 		return vbg_ioctl_vmmrequest(gdev, session, data);
 
 	if (hdr->type != VBG_IOCTL_HDR_TYPE_DEFAULT)
@@ -1558,6 +1559,7 @@ int vbg_core_ioctl(struct vbg_session *session, unsigned int req, void *data)
 	case VBG_IOCTL_HGCM_CALL(0):
 		return vbg_ioctl_hgcm_call(gdev, session, f32bit, data);
 	case VBG_IOCTL_LOG(0):
+	case VBG_IOCTL_LOG_ALT(0):
 		return vbg_ioctl_log(data);
 	}
 
diff --git a/drivers/virt/vboxguest/vboxguest_core.h b/drivers/virt/vboxguest/vboxguest_core.h
index 4188c12b839f..77c3a9c8255d 100644
--- a/drivers/virt/vboxguest/vboxguest_core.h
+++ b/drivers/virt/vboxguest/vboxguest_core.h
@@ -15,6 +15,21 @@
 #include <linux/vboxguest.h>
 #include "vmmdev.h"
 
+/*
+ * The mainline kernel version (this version) of the vboxguest module
+ * contained a bug where it defined VBGL_IOCTL_VMMDEV_REQUEST_BIG and
+ * VBGL_IOCTL_LOG using _IOC(_IOC_READ | _IOC_WRITE, 'V', ...) instead
+ * of _IO(V, ...) as the out of tree VirtualBox upstream version does.
+ *
+ * These _ALT definitions keep compatibility with the wrong defines the
+ * mainline kernel version used for a while.
+ * Note the VirtualBox userspace bits have always been built against
+ * VirtualBox upstream's headers, so this is likely not necessary. But
+ * we must never break our ABI so we keep these around to be 100% sure.
+ */
+#define VBG_IOCTL_VMMDEV_REQUEST_BIG_ALT _IOC(_IOC_READ | _IOC_WRITE, 'V', 3, 0)
+#define VBG_IOCTL_LOG_ALT(s)             _IOC(_IOC_READ | _IOC_WRITE, 'V', 9, s)
+
 struct vbg_session;
 
 /** VBox guest memory balloon. */
diff --git a/drivers/virt/vboxguest/vboxguest_linux.c b/drivers/virt/vboxguest/vboxguest_linux.c
index 6e8c0f1c1056..32c2c52f7e84 100644
--- a/drivers/virt/vboxguest/vboxguest_linux.c
+++ b/drivers/virt/vboxguest/vboxguest_linux.c
@@ -131,7 +131,8 @@ static long vbg_misc_device_ioctl(struct file *filp, unsigned int req,
 	 * the need for a bounce-buffer and another copy later on.
 	 */
 	is_vmmdev_req = (req & ~IOCSIZE_MASK) == VBG_IOCTL_VMMDEV_REQUEST(0) ||
-			 req == VBG_IOCTL_VMMDEV_REQUEST_BIG;
+			 req == VBG_IOCTL_VMMDEV_REQUEST_BIG ||
+			 req == VBG_IOCTL_VMMDEV_REQUEST_BIG_ALT;
 
 	if (is_vmmdev_req)
 		buf = vbg_req_alloc(size, VBG_IOCTL_HDR_TYPE_DEFAULT,
diff --git a/include/uapi/linux/vboxguest.h b/include/uapi/linux/vboxguest.h
index 9cec58a6a5ea..f79d7abe27db 100644
--- a/include/uapi/linux/vboxguest.h
+++ b/include/uapi/linux/vboxguest.h
@@ -103,7 +103,7 @@ VMMDEV_ASSERT_SIZE(vbg_ioctl_driver_version_info, 24 + 20);
 
 
 /* IOCTL to perform a VMM Device request larger then 1KB. */
-#define VBG_IOCTL_VMMDEV_REQUEST_BIG	_IOC(_IOC_READ | _IOC_WRITE, 'V', 3, 0)
+#define VBG_IOCTL_VMMDEV_REQUEST_BIG	_IO('V', 3)
 
 
 /** VBG_IOCTL_HGCM_CONNECT data structure. */
@@ -198,7 +198,7 @@ struct vbg_ioctl_log {
 	} u;
 };
 
-#define VBG_IOCTL_LOG(s)		_IOC(_IOC_READ | _IOC_WRITE, 'V', 9, s)
+#define VBG_IOCTL_LOG(s)		_IO('V', 9)
 
 
 /** VBG_IOCTL_WAIT_FOR_EVENTS data structure. */
-- 
2.26.2

