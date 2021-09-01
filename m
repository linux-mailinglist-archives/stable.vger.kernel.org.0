Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFF0F3FDC37
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344663AbhIAMsA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:48:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:49840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345257AbhIAMqC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:46:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9282A61075;
        Wed,  1 Sep 2021 12:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499970;
        bh=h8HYeRSMPhwCEiHN7UhHG7WhfHOKYEcSPPoWVRnUrPo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=phDqVu1Gc7BLBraTxTyPUKEC7UoKPyxBuLMQL5avrg2uHtgFdC+qdZifOMdQt3MUq
         cmPeMofgPgu/OfOToo4CZ1IxjwgxaDkWo7wNCEasuY8ptzERkhzwRqKvhrVw+qLSD/
         A9/v8bnBpTpjt+5lRS1tIJLZTmhGX3nUXWc9t+Sc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 053/113] SUNRPC: Fix XPT_BUSY flag leakage in svc_handle_xprt()...
Date:   Wed,  1 Sep 2021 14:28:08 +0200
Message-Id: <20210901122303.743147206@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122301.984263453@linuxfoundation.org>
References: <20210901122301.984263453@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 062b829c52ef4ed5df14f4850fc07651bb7c3b33 ]

If the attempt to reserve a slot fails, we currently leak the XPT_BUSY
flag on the socket. Among other things, this make it impossible to close
the socket.

Fixes: 82011c80b3ec ("SUNRPC: Move svc_xprt_received() call sites")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/svc_xprt.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sunrpc/svc_xprt.c b/net/sunrpc/svc_xprt.c
index d66a8e44a1ae..dbb41821b1b8 100644
--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -835,7 +835,8 @@ static int svc_handle_xprt(struct svc_rqst *rqstp, struct svc_xprt *xprt)
 		rqstp->rq_stime = ktime_get();
 		rqstp->rq_reserved = serv->sv_max_mesg;
 		atomic_add(rqstp->rq_reserved, &xprt->xpt_reserved);
-	}
+	} else
+		svc_xprt_received(xprt);
 out:
 	trace_svc_handle_xprt(xprt, len);
 	return len;
-- 
2.30.2



