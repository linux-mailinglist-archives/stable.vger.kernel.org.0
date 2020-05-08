Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EDAB1CAFDD
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727915AbgEHNVF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:21:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:34226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728716AbgEHMkd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:40:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A578C20731;
        Fri,  8 May 2020 12:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941633;
        bh=CKEsIwLKe5KKKWEEfVgThjd/Hwwpw3XCwsiFwR5ZEB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AYQZ0qTsbox8rK1Z4nY40N2DOXpQ7xljirVcujvtE1ca0c+VKC08mm7xTo2DEZhyw
         UcRpzA4cmBKxuO86m45ZpoD1FMJCV62n2UAbn2fTwu48he6zntcqJdsM25MP+hjRwh
         DOpd7ts0bQUVqkC25Bs7qvLP1HCbQRrGoF5YbW3o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>
Subject: [PATCH 4.4 103/312] xprtrdma: rpcrdma_bc_receive_call() should init rq_private_buf.len
Date:   Fri,  8 May 2020 14:31:34 +0200
Message-Id: <20200508123131.756381617@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

commit 9f74660bcf1e4cca577be99e54bc77b5df62b508 upstream.

Some NFSv4.1 OPEN requests were hanging waiting for the NFS server
to finish recalling delegations. Turns out that each NFSv4.1 CB
request on RDMA gets a GARBAGE_ARGS reply from the Linux client.

Commit 756b9b37cfb2e3dc added a line in bc_svc_process that
overwrites the incoming rq_rcv_buf's length with the value in
rq_private_buf.len. But rpcrdma_bc_receive_call() does not invoke
xprt_complete_bc_request(), thus rq_private_buf.len is not
initialized. svc_process_common() is invoked with a zero-length
RPC message, and fails.

Fixes: 756b9b37cfb2e3dc ('SUNRPC: Fix callback channel')
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sunrpc/xprtrdma/backchannel.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/sunrpc/xprtrdma/backchannel.c
+++ b/net/sunrpc/xprtrdma/backchannel.c
@@ -337,6 +337,8 @@ void rpcrdma_bc_receive_call(struct rpcr
 	rqst->rq_reply_bytes_recvd = 0;
 	rqst->rq_bytes_sent = 0;
 	rqst->rq_xid = headerp->rm_xid;
+
+	rqst->rq_private_buf.len = size;
 	set_bit(RPC_BC_PA_IN_USE, &rqst->rq_bc_pa_state);
 
 	buf = &rqst->rq_rcv_buf;


