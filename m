Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E67EF5DB
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 13:39:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727817AbfD3Ljd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:39:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:44838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726648AbfD3Ljc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:39:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 518EE2173E;
        Tue, 30 Apr 2019 11:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624371;
        bh=nLCMzDTipK2iPDywH9QjuhrH1j+pd1EQip2pgPgje2M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kuIwSODtewgNNTMnGzQ/qLy6Kj4dHQuVd/O/IZkCaQxz+XgRr061MnUILVX2HN9Dq
         VON2B2V3qv9gvHR1RLOMaPJaYGwR1ymJJXntXmjOslhFol+gtg8FFhP3ewIFvqEU9S
         qfcz/qH9i/g3N/7GAliH8V5BjokC4+naUKXouhvE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [PATCH 4.9 10/41] nfsd: Dont release the callback slot unless it was actually held
Date:   Tue, 30 Apr 2019 13:38:21 +0200
Message-Id: <20190430113527.552502516@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113524.451237916@linuxfoundation.org>
References: <20190430113524.451237916@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trondmy@gmail.com>

commit e6abc8caa6deb14be2a206253f7e1c5e37e9515b upstream.

If there are multiple callbacks queued, waiting for the callback
slot when the callback gets shut down, then they all currently
end up acting as if they hold the slot, and call
nfsd4_cb_sequence_done() resulting in interesting side-effects.

In addition, the 'retry_nowait' path in nfsd4_cb_sequence_done()
causes a loop back to nfsd4_cb_prepare() without first freeing the
slot, which causes a deadlock when nfsd41_cb_get_slot() gets called
a second time.

This patch therefore adds a boolean to track whether or not the
callback did pick up the slot, so that it can do the right thing
in these 2 cases.

Cc: stable@vger.kernel.org
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/nfs4callback.c |    8 +++++++-
 fs/nfsd/state.h        |    1 +
 2 files changed, 8 insertions(+), 1 deletion(-)

--- a/fs/nfsd/nfs4callback.c
+++ b/fs/nfsd/nfs4callback.c
@@ -934,8 +934,9 @@ static void nfsd4_cb_prepare(struct rpc_
 	cb->cb_seq_status = 1;
 	cb->cb_status = 0;
 	if (minorversion) {
-		if (!nfsd41_cb_get_slot(clp, task))
+		if (!cb->cb_holds_slot && !nfsd41_cb_get_slot(clp, task))
 			return;
+		cb->cb_holds_slot = true;
 	}
 	rpc_call_start(task);
 }
@@ -962,6 +963,9 @@ static bool nfsd4_cb_sequence_done(struc
 		return true;
 	}
 
+	if (!cb->cb_holds_slot)
+		goto need_restart;
+
 	switch (cb->cb_seq_status) {
 	case 0:
 		/*
@@ -999,6 +1003,7 @@ static bool nfsd4_cb_sequence_done(struc
 			cb->cb_seq_status);
 	}
 
+	cb->cb_holds_slot = false;
 	clear_bit(0, &clp->cl_cb_slot_busy);
 	rpc_wake_up_next(&clp->cl_cb_waitq);
 	dprintk("%s: freed slot, new seqid=%d\n", __func__,
@@ -1206,6 +1211,7 @@ void nfsd4_init_cb(struct nfsd4_callback
 	cb->cb_seq_status = 1;
 	cb->cb_status = 0;
 	cb->cb_need_restart = false;
+	cb->cb_holds_slot = false;
 }
 
 void nfsd4_run_cb(struct nfsd4_callback *cb)
--- a/fs/nfsd/state.h
+++ b/fs/nfsd/state.h
@@ -69,6 +69,7 @@ struct nfsd4_callback {
 	int cb_seq_status;
 	int cb_status;
 	bool cb_need_restart;
+	bool cb_holds_slot;
 };
 
 struct nfsd4_callback_ops {


