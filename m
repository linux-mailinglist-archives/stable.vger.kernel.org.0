Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98BBA2AB8C1
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 13:55:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729174AbgKIMzx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 07:55:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:50768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726410AbgKIMzx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 07:55:53 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE76820684;
        Mon,  9 Nov 2020 12:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604926552;
        bh=zlu4+sAM+Ik0vfl+gZBPnfG9y9AwcOYi9/E+fOtqMGk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UM0Mq057EzDl18GftDDHlAichicP2k3jZo5EuvthzLIcJ/IkE8LABv4Wn6OmOR7BO
         T76O5tOsXv4l8kwt6ZFXyUZ7d6FZDhC6uUxjtUfBulHcT63U3WnSsFJeKvRfKQl2X/
         5uvihhrl/dZKYv64KxpHq3mEMIcxLcZ6YSRYM3cY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, NeilBrown <neilb@suse.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        Calum Mackay <calum.mackay@oracle.com>
Subject: [PATCH 4.4 01/86] SUNRPC: ECONNREFUSED should cause a rebind.
Date:   Mon,  9 Nov 2020 13:54:08 +0100
Message-Id: <20201109125020.921445454@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125020.852643676@linuxfoundation.org>
References: <20201109125020.852643676@linuxfoundation.org>
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
@@ -1826,6 +1826,14 @@ call_connect_status(struct rpc_task *tas
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


