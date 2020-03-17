Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E70E1880F9
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:14:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729069AbgCQLN0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:13:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:57304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729344AbgCQLNY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:13:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2C322076F;
        Tue, 17 Mar 2020 11:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584443604;
        bh=2gNUVrFf3z0eqzjHAqn4loYBqESHZkwaMZOw7bbK8Vc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sx15Wo48iPMroMJ1znYyIPU0Vx85umINqKnFLOdqd+HV6YMm2qTBy2BQ/ahXuVUz6
         Njs0nv+mNdpzG9i3syr25fZrGRnZ+rs2QViunQ/jbrQY2ExYVOSSfvLpFgUPQWqhT9
         q6Z5OPM8/OmC6kGkQfGIt+DMjHirHoSaUTJb2Mi0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kyle Sanderson <kyle.leet@gmail.com>,
        Michael Stapelberg <michael+lkml@stapelberg.ch>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.5 101/151] fuse: fix stack use after return
Date:   Tue, 17 Mar 2020 11:55:11 +0100
Message-Id: <20200317103333.636383044@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103326.593639086@linuxfoundation.org>
References: <20200317103326.593639086@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

commit 3e8cb8b2eaeb22f540f1cbc00cbb594047b7ba89 upstream.

Normal, synchronous requests will have their args allocated on the stack.
After the FR_FINISHED bit is set by receiving the reply from the userspace
fuse server, the originating task may return and reuse the stack frame,
resulting in an Oops if the args structure is dereferenced.

Fix by setting a flag in the request itself upon initializing, indicating
whether it has an asynchronous ->end() callback.

Reported-by: Kyle Sanderson <kyle.leet@gmail.com>
Reported-by: Michael Stapelberg <michael+lkml@stapelberg.ch>
Fixes: 2b319d1f6f92 ("fuse: don't dereference req->args on finished request")
Cc: <stable@vger.kernel.org> # v5.4
Tested-by: Michael Stapelberg <michael+lkml@stapelberg.ch>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/fuse/dev.c    |    6 +++---
 fs/fuse/fuse_i.h |    2 ++
 2 files changed, 5 insertions(+), 3 deletions(-)

--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -276,12 +276,10 @@ static void flush_bg_queue(struct fuse_c
 void fuse_request_end(struct fuse_conn *fc, struct fuse_req *req)
 {
 	struct fuse_iqueue *fiq = &fc->iq;
-	bool async;
 
 	if (test_and_set_bit(FR_FINISHED, &req->flags))
 		goto put_request;
 
-	async = req->args->end;
 	/*
 	 * test_and_set_bit() implies smp_mb() between bit
 	 * changing and below intr_entry check. Pairs with
@@ -324,7 +322,7 @@ void fuse_request_end(struct fuse_conn *
 		wake_up(&req->waitq);
 	}
 
-	if (async)
+	if (test_bit(FR_ASYNC, &req->flags))
 		req->args->end(fc, req->args, req->out.h.error);
 put_request:
 	fuse_put_request(fc, req);
@@ -471,6 +469,8 @@ static void fuse_args_to_req(struct fuse
 	req->in.h.opcode = args->opcode;
 	req->in.h.nodeid = args->nodeid;
 	req->args = args;
+	if (args->end)
+		__set_bit(FR_ASYNC, &req->flags);
 }
 
 ssize_t fuse_simple_request(struct fuse_conn *fc, struct fuse_args *args)
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -301,6 +301,7 @@ struct fuse_io_priv {
  * FR_SENT:		request is in userspace, waiting for an answer
  * FR_FINISHED:		request is finished
  * FR_PRIVATE:		request is on private list
+ * FR_ASYNC:		request is asynchronous
  */
 enum fuse_req_flag {
 	FR_ISREPLY,
@@ -314,6 +315,7 @@ enum fuse_req_flag {
 	FR_SENT,
 	FR_FINISHED,
 	FR_PRIVATE,
+	FR_ASYNC,
 };
 
 /**


