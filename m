Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 986503C4491
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 08:21:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233780AbhGLGUH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:20:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:38010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233967AbhGLGTh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:19:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 666C9610A6;
        Mon, 12 Jul 2021 06:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626070608;
        bh=/Y1Mkf1M+k2dxpIKYjn3JBq+L2doUleTpDIx/Ixafmc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ISOMi7bijXIZLYSfaoukjky8ua5C/RXPYFD5A7zjzx4Yy1r1TKMUIP6pgJtmSvisj
         Ke9MkKuPcjkjLZUsjXAfo64Xs28vINskZidAFz6sj2yr6fGeeYYpwCDlIUHJMEH4fb
         K/EFRTdQdTibmsytnmslbVDhzC/7l7kmNUWsV+NQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pradeep P V K <pragalla@codeaurora.org>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.4 062/348] fuse: check connected before queueing on fpq->io
Date:   Mon, 12 Jul 2021 08:07:26 +0200
Message-Id: <20210712060710.230878713@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

commit 80ef08670d4c28a06a3de954bd350368780bcfef upstream.

A request could end up on the fpq->io list after fuse_abort_conn() has
reset fpq->connected and aborted requests on that list:

Thread-1			  Thread-2
========			  ========
->fuse_simple_request()           ->shutdown
  ->__fuse_request_send()
    ->queue_request()		->fuse_abort_conn()
->fuse_dev_do_read()                ->acquire(fpq->lock)
  ->wait_for(fpq->lock) 	  ->set err to all req's in fpq->io
				  ->release(fpq->lock)
  ->acquire(fpq->lock)
  ->add req to fpq->io

After the userspace copy is done the request will be ended, but
req->out.h.error will remain uninitialized.  Also the copy might block
despite being already aborted.

Fix both issues by not allowing the request to be queued on the fpq->io
list after fuse_abort_conn() has processed this list.

Reported-by: Pradeep P V K <pragalla@codeaurora.org>
Fixes: fd22d62ed0c3 ("fuse: no fc->lock for iqueue parts")
Cc: <stable@vger.kernel.org> # v4.2
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/fuse/dev.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1264,6 +1264,15 @@ static ssize_t fuse_dev_do_read(struct f
 		goto restart;
 	}
 	spin_lock(&fpq->lock);
+	/*
+	 *  Must not put request on fpq->io queue after having been shut down by
+	 *  fuse_abort_conn()
+	 */
+	if (!fpq->connected) {
+		req->out.h.error = err = -ECONNABORTED;
+		goto out_end;
+
+	}
 	list_add(&req->list, &fpq->io);
 	spin_unlock(&fpq->lock);
 	cs->req = req;


