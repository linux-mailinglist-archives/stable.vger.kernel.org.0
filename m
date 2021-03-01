Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC8F03287D4
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:30:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238542AbhCAR2z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:28:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:48864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238245AbhCARYA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:24:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A12A65073;
        Mon,  1 Mar 2021 16:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617328;
        bh=573bljVzYWhD4ui2+AHihux+rb4jvs/sMGde0ArCrUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CmIwShcqa3V/rGsR8zFGTzRBebSkmBTEGnvfW+r9ZH1MfYPBiOjIyWfC2RmIAt9WN
         5JVGyw2hGrqFTUeFsWCzH4oVrTQ+vf5siwcwXv2gqLPcGBR9dJVrk2Kvn+z0m7t2OH
         esE+KK2N+WYJgFuUum9xGKmf9jKWPucoavh+ldXM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ludovic Pouzenc <bugreports@pouzenc.fr>,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 5.4 008/340] virt: vbox: Do not use wait_event_interruptible when called from kernel context
Date:   Mon,  1 Mar 2021 17:09:12 +0100
Message-Id: <20210301161048.717006737@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit c35901b39ddc20077f4ae7b9f7bf344487f62212 upstream.

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
 drivers/virt/vboxguest/vboxguest_utils.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--- a/drivers/virt/vboxguest/vboxguest_utils.c
+++ b/drivers/virt/vboxguest/vboxguest_utils.c
@@ -466,7 +466,7 @@ static int hgcm_cancel_call(struct vbg_d
  *               Cancellation fun.
  */
 static int vbg_hgcm_do_call(struct vbg_dev *gdev, struct vmmdev_hgcm_call *call,
-			    u32 timeout_ms, bool *leak_it)
+			    u32 timeout_ms, bool interruptible, bool *leak_it)
 {
 	int rc, cancel_rc, ret;
 	long timeout;
@@ -493,10 +493,15 @@ static int vbg_hgcm_do_call(struct vbg_d
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
@@ -629,7 +634,8 @@ int vbg_hgcm_call(struct vbg_dev *gdev,
 	hgcm_call_init_call(call, client_id, function, parms, parm_count,
 			    bounce_bufs);
 
-	ret = vbg_hgcm_do_call(gdev, call, timeout_ms, &leak_it);
+	ret = vbg_hgcm_do_call(gdev, call, timeout_ms,
+			       requestor & VMMDEV_REQUESTOR_USERMODE, &leak_it);
 	if (ret == 0) {
 		*vbox_status = call->header.result;
 		ret = hgcm_call_copy_back_result(call, parms, parm_count,


