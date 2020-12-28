Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 819F32E64F5
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:55:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390685AbgL1Nge (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:36:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:36930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390523AbgL1Ngd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:36:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 935E1205CB;
        Mon, 28 Dec 2020 13:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162552;
        bh=cYKIWtitTmOCqJ67n06KAUnkiW4C0HOfRQEAM2qKt70=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vCK3ZYXlXhq9HqTz5+/53/cXbtXAl51s5iW1Mho3m5qDDRGV/eqeqrnD7uxCr+Atf
         7N1R59E4uQAv7Q8AFcEOhu3e6Q42KpRRGKRXG7kEc1P/BmE0+JG/a+RJP9jQNmhF33
         Of4vxsMYgajBe0Ibne8wFuBGEuRyPamSGOVovHnE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olivier Benjamin <oliben@amazon.com>,
        Pawel Wieczorkiewicz <wipawel@amazon.de>,
        Julien Grall <jgrall@amazon.com>,
        Juergen Gross <jgross@suse.com>
Subject: [PATCH 4.19 338/346] xen-blkback: set ring->xenblkd to NULL after kthread_stop()
Date:   Mon, 28 Dec 2020 13:50:57 +0100
Message-Id: <20201228124936.096961407@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pawel Wieczorkiewicz <wipawel@amazon.de>

commit 1c728719a4da6e654afb9cc047164755072ed7c9 upstream.

When xen_blkif_disconnect() is called, the kernel thread behind the
block interface is stopped by calling kthread_stop(ring->xenblkd).
The ring->xenblkd thread pointer being non-NULL determines if the
thread has been already stopped.
Normally, the thread's function xen_blkif_schedule() sets the
ring->xenblkd to NULL, when the thread's main loop ends.

However, when the thread has not been started yet (i.e.
wake_up_process() has not been called on it), the xen_blkif_schedule()
function would not be called yet.

In such case the kthread_stop() call returns -EINTR and the
ring->xenblkd remains dangling.
When this happens, any consecutive call to xen_blkif_disconnect (for
example in frontend_changed() callback) leads to a kernel crash in
kthread_stop() (e.g. NULL pointer dereference in exit_creds()).

This is XSA-350.

Cc: <stable@vger.kernel.org> # 4.12
Fixes: a24fa22ce22a ("xen/blkback: don't use xen_blkif_get() in xen-blkback kthread")
Reported-by: Olivier Benjamin <oliben@amazon.com>
Reported-by: Pawel Wieczorkiewicz <wipawel@amazon.de>
Signed-off-by: Pawel Wieczorkiewicz <wipawel@amazon.de>
Reviewed-by: Julien Grall <jgrall@amazon.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/xen-blkback/xenbus.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -264,6 +264,7 @@ static int xen_blkif_disconnect(struct x
 
 		if (ring->xenblkd) {
 			kthread_stop(ring->xenblkd);
+			ring->xenblkd = NULL;
 			wake_up(&ring->shutdown_wq);
 		}
 


