Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D856530730F
	for <lists+stable@lfdr.de>; Thu, 28 Jan 2021 10:45:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232376AbhA1Joa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jan 2021 04:44:30 -0500
Received: from mo-csw-fb1514.securemx.jp ([210.130.202.170]:43468 "EHLO
        mo-csw-fb.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232449AbhA1Jlx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jan 2021 04:41:53 -0500
X-Greylist: delayed 2049 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Jan 2021 04:41:52 EST
Received: by mo-csw-fb.securemx.jp (mx-mo-csw-fb1514) id 10S97WIt016088; Thu, 28 Jan 2021 18:07:32 +0900
Received: by mo-csw.securemx.jp (mx-mo-csw1514) id 10S95CZT030029; Thu, 28 Jan 2021 18:05:12 +0900
X-Iguazu-Qid: 34tMYNXf59YlsazpGB
X-Iguazu-QSIG: v=2; s=0; t=1611824711; q=34tMYNXf59YlsazpGB; m=U1Tsb9Z7D2c1Rbr5hLlomjaGIllqgeCe0HcvqjYWxNc=
Received: from imx12.toshiba.co.jp (imx12.toshiba.co.jp [61.202.160.132])
        by relay.securemx.jp (mx-mr1512) id 10S95A7v003343;
        Thu, 28 Jan 2021 18:05:10 +0900
Received: from enc02.toshiba.co.jp ([61.202.160.51])
        by imx12.toshiba.co.jp  with ESMTP id 10S95ASk019606;
        Thu, 28 Jan 2021 18:05:10 +0900 (JST)
Received: from hop101.toshiba.co.jp ([133.199.85.107])
        by enc02.toshiba.co.jp  with ESMTP id 10S95A5h030552;
        Thu, 28 Jan 2021 18:05:10 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, sashal@kernel.org,
        Pawel Wieczorkiewicz <wipawel@amazon.de>,
        Olivier Benjamin <oliben@amazon.com>,
        Julien Grall <jgrall@amazon.com>,
        Juergen Gross <jgross@suse.com>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH/RFC] xen-blkback: set ring->xenblkd to NULL after kthread_stop()
Date:   Thu, 28 Jan 2021 18:05:06 +0900
X-TSB-HOP: ON
Message-Id: <20210128090506.3174402-1-nobuhiro1.iwamatsu@toshiba.co.jp>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
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
[iwamatsu: change from ring to blkif]
Signed-off-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
---
 drivers/block/xen-blkback/xenbus.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
index 823f3480ebd19e..f974ed7c33b5df 100644
--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -219,6 +219,7 @@ static int xen_blkif_disconnect(struct xen_blkif *blkif)
 
 	if (blkif->xenblkd) {
 		kthread_stop(blkif->xenblkd);
+		blkif->xenblkd = NULL;
 		wake_up(&blkif->shutdown_wq);
 	}
 
-- 
2.30.0

