Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3979B226586
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 17:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730700AbgGTPyi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:54:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:53392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731073AbgGTPyi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:54:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC31322CAF;
        Mon, 20 Jul 2020 15:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260477;
        bh=Im+ui7xrDY+1uPqPsd5zagZko41qbiBiA3DWNeKStOk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w73aMPw9uElwHcRKxm1sfR+0IkV6x2+teVTTNwYit4KyQdVcm2/saIHRZxXrisugT
         2uys2sAKMHhWORv9ZVPwBO5lULHC3mHlBaG/O+HYOTqaWJOI8mMdRlOewEN5x7TEo+
         0UswUGSeAf5U2RNT26tm7BeyGbkFRCazxarWYZtw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 4.19 099/133] virt: vbox: Fix VBGL_IOCTL_VMMDEV_REQUEST_BIG and _LOG req numbers to match upstream
Date:   Mon, 20 Jul 2020 17:37:26 +0200
Message-Id: <20200720152808.510660301@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152803.732195882@linuxfoundation.org>
References: <20200720152803.732195882@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit f794db6841e5480208f0c3a3ac1df445a96b079e upstream.

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
Link: https://lore.kernel.org/r/20200709120858.63928-2-hdegoede@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/virt/vboxguest/vboxguest_core.c  |    4 +++-
 drivers/virt/vboxguest/vboxguest_core.h  |   15 +++++++++++++++
 drivers/virt/vboxguest/vboxguest_linux.c |    3 ++-
 include/uapi/linux/vboxguest.h           |    4 ++--
 4 files changed, 22 insertions(+), 4 deletions(-)

--- a/drivers/virt/vboxguest/vboxguest_core.c
+++ b/drivers/virt/vboxguest/vboxguest_core.c
@@ -1482,7 +1482,8 @@ int vbg_core_ioctl(struct vbg_session *s
 
 	/* For VMMDEV_REQUEST hdr->type != VBG_IOCTL_HDR_TYPE_DEFAULT */
 	if (req_no_size == VBG_IOCTL_VMMDEV_REQUEST(0) ||
-	    req == VBG_IOCTL_VMMDEV_REQUEST_BIG)
+	    req == VBG_IOCTL_VMMDEV_REQUEST_BIG ||
+	    req == VBG_IOCTL_VMMDEV_REQUEST_BIG_ALT)
 		return vbg_ioctl_vmmrequest(gdev, session, data);
 
 	if (hdr->type != VBG_IOCTL_HDR_TYPE_DEFAULT)
@@ -1520,6 +1521,7 @@ int vbg_core_ioctl(struct vbg_session *s
 	case VBG_IOCTL_HGCM_CALL(0):
 		return vbg_ioctl_hgcm_call(gdev, session, f32bit, data);
 	case VBG_IOCTL_LOG(0):
+	case VBG_IOCTL_LOG_ALT(0):
 		return vbg_ioctl_log(data);
 	}
 
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
--- a/drivers/virt/vboxguest/vboxguest_linux.c
+++ b/drivers/virt/vboxguest/vboxguest_linux.c
@@ -112,7 +112,8 @@ static long vbg_misc_device_ioctl(struct
 	 * the need for a bounce-buffer and another copy later on.
 	 */
 	is_vmmdev_req = (req & ~IOCSIZE_MASK) == VBG_IOCTL_VMMDEV_REQUEST(0) ||
-			 req == VBG_IOCTL_VMMDEV_REQUEST_BIG;
+			 req == VBG_IOCTL_VMMDEV_REQUEST_BIG ||
+			 req == VBG_IOCTL_VMMDEV_REQUEST_BIG_ALT;
 
 	if (is_vmmdev_req)
 		buf = vbg_req_alloc(size, VBG_IOCTL_HDR_TYPE_DEFAULT);
--- a/include/uapi/linux/vboxguest.h
+++ b/include/uapi/linux/vboxguest.h
@@ -103,7 +103,7 @@ VMMDEV_ASSERT_SIZE(vbg_ioctl_driver_vers
 
 
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


