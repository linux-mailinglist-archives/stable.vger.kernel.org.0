Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F80B305D64
	for <lists+stable@lfdr.de>; Wed, 27 Jan 2021 14:39:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231510AbhA0NjW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jan 2021 08:39:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:60216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233821AbhA0Nh7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Jan 2021 08:37:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B3492072C;
        Wed, 27 Jan 2021 13:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611754638;
        bh=XlzbyapUdttW+xJq4rvU59E0QgnwCtUcs5L72kwNr3E=;
        h=Subject:To:From:Date:From;
        b=qP9KuWE35TItHvgEF5VmHwKzNBn+SS26WtN1tEdY3aJGBZrXc1qp3At6LrLXmlzNR
         12g0EA32yx8JWEWQCv22eQ1KN2pY2rkjVmn9taQB+MC+CsVBHT+uSni+gDpAt2oN+p
         2DYfllXyoG51njDBMVy8Edw2R/jT+Z7doITuxq6o=
Subject: patch "virt: vbox: Do not use wait_event_interruptible when called from" added to char-misc-testing
To:     hdegoede@redhat.com, bugreports@pouzenc.fr,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 27 Jan 2021 14:37:16 +0100
Message-ID: <16117546367238@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    virt: vbox: Do not use wait_event_interruptible when called from

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the char-misc-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From c35901b39ddc20077f4ae7b9f7bf344487f62212 Mon Sep 17 00:00:00 2001
From: Hans de Goede <hdegoede@redhat.com>
Date: Thu, 21 Jan 2021 16:07:54 +0100
Subject: virt: vbox: Do not use wait_event_interruptible when called from
 kernel context

Do not use wait_event_interruptible when vbg_hgcm_call() gets called from
kernel-context, such as it being called by the vboxsf filesystem code.

This fixes some filesystem related system calls on shared folders
unexpectedly failing with -EINTR.

Fixes: 0532a1b0d045 ("virt: vbox: Implement passing requestor info to the host for VirtualBox 6.0.x")
Reported-by: Ludovic Pouzenc <bugreports@pouzenc.fr>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210121150754.147598-1-hdegoede@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/virt/vboxguest/vboxguest_utils.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/virt/vboxguest/vboxguest_utils.c b/drivers/virt/vboxguest/vboxguest_utils.c
index ea05af41ec69..8d195e3f8301 100644
--- a/drivers/virt/vboxguest/vboxguest_utils.c
+++ b/drivers/virt/vboxguest/vboxguest_utils.c
@@ -468,7 +468,7 @@ static int hgcm_cancel_call(struct vbg_dev *gdev, struct vmmdev_hgcm_call *call)
  *               Cancellation fun.
  */
 static int vbg_hgcm_do_call(struct vbg_dev *gdev, struct vmmdev_hgcm_call *call,
-			    u32 timeout_ms, bool *leak_it)
+			    u32 timeout_ms, bool interruptible, bool *leak_it)
 {
 	int rc, cancel_rc, ret;
 	long timeout;
@@ -495,10 +495,15 @@ static int vbg_hgcm_do_call(struct vbg_dev *gdev, struct vmmdev_hgcm_call *call,
 	else
 		timeout = msecs_to_jiffies(timeout_ms);
 
-	timeout = wait_event_interruptible_timeout(
-					gdev->hgcm_wq,
-					hgcm_req_done(gdev, &call->header),
-					timeout);
+	if (interruptible) {
+		timeout = wait_event_interruptible_timeout(gdev->hgcm_wq,
+							   hgcm_req_done(gdev, &call->header),
+							   timeout);
+	} else {
+		timeout = wait_event_timeout(gdev->hgcm_wq,
+					     hgcm_req_done(gdev, &call->header),
+					     timeout);
+	}
 
 	/* timeout > 0 means hgcm_req_done has returned true, so success */
 	if (timeout > 0)
@@ -631,7 +636,8 @@ int vbg_hgcm_call(struct vbg_dev *gdev, u32 requestor, u32 client_id,
 	hgcm_call_init_call(call, client_id, function, parms, parm_count,
 			    bounce_bufs);
 
-	ret = vbg_hgcm_do_call(gdev, call, timeout_ms, &leak_it);
+	ret = vbg_hgcm_do_call(gdev, call, timeout_ms,
+			       requestor & VMMDEV_REQUESTOR_USERMODE, &leak_it);
 	if (ret == 0) {
 		*vbox_status = call->header.result;
 		ret = hgcm_call_copy_back_result(call, parms, parm_count,
-- 
2.30.0


