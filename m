Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 304AC2AB8F3
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:00:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730282AbgKINAE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:00:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:54156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730404AbgKINAA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:00:00 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19DB7208FE;
        Mon,  9 Nov 2020 12:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604926799;
        bh=kbIQ2XAQlnIh6iAJjW3pWk5NnU8+kzBKiHepqLoqt9Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DrBvDTc9nho29sq6sqHwkN5zc3NTExK+TWsB9Xb+aQfJ5vuguiv9W0XczYWJDoINp
         GNBCVC7mHibIlZJSjSd3hyOObV2F3OVHviR7RVAnKgDPNlPRsdVKoZmgnzFIza+N89
         2zHZAI4sIik9G1fPhWnb9ZSpp2pS6M+kWx4VNyzg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, NeilBrown <neilb@suse.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        Calum Mackay <calum.mackay@oracle.com>
Subject: [PATCH 4.9 001/117] SUNRPC: ECONNREFUSED should cause a rebind.
Date:   Mon,  9 Nov 2020 13:53:47 +0100
Message-Id: <20201109125025.700918529@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125025.630721781@linuxfoundation.org>
References: <20201109125025.630721781@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: NeilBrown <neilb@suse.com>

commit fd01b2597941d9c17980222999b0721648b383b8 upstream.

If you
 - mount and NFSv3 filesystem
 - do some file locking which requires the server
   to make a GRANT call back
 - unmount
 - mount again and do the same locking

then the second attempt at locking suffers a 30 second delay.
Unmounting and remounting causes lockd to stop and restart,
which causes it to bind to a new port.
The server still thinks the old port is valid and gets ECONNREFUSED
when trying to contact it.
ECONNREFUSED should be seen as a hard error that is not worth
retrying.  Rebinding is the only reasonable response.

This patch forces a rebind if that makes sense.

Signed-off-by: NeilBrown <neilb@suse.com>
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Cc: Calum Mackay <calum.mackay@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sunrpc/clnt.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -1936,6 +1936,14 @@ call_connect_status(struct rpc_task *tas
 	task->tk_status = 0;
 	switch (status) {
 	case -ECONNREFUSED:
+		/* A positive refusal suggests a rebind is needed. */
+		if (RPC_IS_SOFTCONN(task))
+			break;
+		if (clnt->cl_autobind) {
+			rpc_force_rebind(clnt);
+			task->tk_action = call_bind;
+			return;
+		}
 	case -ECONNRESET:
 	case -ECONNABORTED:
 	case -ENETUNREACH:


