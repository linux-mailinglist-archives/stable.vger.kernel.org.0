Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1C563CDC9A
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244766AbhGSOxK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:53:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:42484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344732AbhGSOtI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:49:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 489D160551;
        Mon, 19 Jul 2021 15:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708586;
        bh=y/npxEBPgWx6Nj/RGcHLzEbTg//DYvL0MZX+fQFqi4A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Soxt/bQ7BYTe75RTem6CrRVQHOSSyHYsbaOlR8mBde7/gBnGwbwkpoLLF/r4hUvtM
         ZHfAuEcsTtCXJ8B9I/xbJTZ3ysoiq+G6QaIwSREfwM9P7sMl+5NAFCOMpxlLXOtt3x
         KM0oegfJEyCcfv7ScH8lo9EtvhwmLhfkjgC5DkO8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pradeep P V K <pragalla@codeaurora.org>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 4.19 050/421] fuse: check connected before queueing on fpq->io
Date:   Mon, 19 Jul 2021 16:47:41 +0200
Message-Id: <20210719144947.959746296@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
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
@@ -1310,6 +1310,15 @@ static ssize_t fuse_dev_do_read(struct f
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


