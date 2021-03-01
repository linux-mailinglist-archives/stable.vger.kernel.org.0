Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 151B9328B49
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:35:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239808AbhCAScM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:32:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:39696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239501AbhCASXi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:23:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2FF9865133;
        Mon,  1 Mar 2021 17:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618225;
        bh=79rOFTT/IovUaux/wNo6aWc/xiSNmYmvGDLS2CxSZ5k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1ca/3yA1tA4VPKBBsRh/krUQKcJtb69NlRw8b4oaZorivDNIbvhG84uqW7FWHK+ai
         hGxITe9axD0YckhdUyXH+aGZO0ebuHzweaaTippcvbuHmmd8NYHJijRTn/w7AhTYpU
         KQviGcS7DjIdVmVFVxY+47IlYlTTYE7FzwXDP0ts=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ludovic Pouzenc <bugreports@pouzenc.fr>,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 5.10 011/663] virt: vbox: Do not use wait_event_interruptible when called from kernel context
Date:   Mon,  1 Mar 2021 17:04:19 +0100
Message-Id: <20210301161142.340767476@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
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
@@ -468,7 +468,7 @@ static int hgcm_cancel_call(struct vbg_d
  *               Cancellation fun.
  */
 static int vbg_hgcm_do_call(struct vbg_dev *gdev, struct vmmdev_hgcm_call *call,
-			    u32 timeout_ms, bool *leak_it)
+			    u32 timeout_ms, bool interruptible, bool *leak_it)
 {
 	int rc, cancel_rc, ret;
 	long timeout;
@@ -495,10 +495,15 @@ static int vbg_hgcm_do_call(struct vbg_d
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
@@ -631,7 +636,8 @@ int vbg_hgcm_call(struct vbg_dev *gdev,
 	hgcm_call_init_call(call, client_id, function, parms, parm_count,
 			    bounce_bufs);
 
-	ret = vbg_hgcm_do_call(gdev, call, timeout_ms, &leak_it);
+	ret = vbg_hgcm_do_call(gdev, call, timeout_ms,
+			       requestor & VMMDEV_REQUESTOR_USERMODE, &leak_it);
 	if (ret == 0) {
 		*vbox_status = call->header.result;
 		ret = hgcm_call_copy_back_result(call, parms, parm_count,


