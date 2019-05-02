Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0547A11DD2
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:37:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728105AbfEBPdd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:33:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:52904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729285AbfEBPcz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:32:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DBCBD2081C;
        Thu,  2 May 2019 15:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556811175;
        bh=TIF04Z/Lv3iGuadkLwXaDkgKC/e5kCrQWQcV1wlwvIw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=af41vASEa6oId0gmIOyG/+Wxlf2SFhSPVW9cVIyNM1wXimWIDFwE3Jyv2ZScIDhDg
         nxCoBZYjtg2ZrPX0yC4q4lKXNh203dNiAu5OcBsSLE50+Qbg9x2YpNm4yVp+Pnx3Cr
         V0MkIyPlJe95U+vMVbrs1Kyy/0W0hvvTB6VDCnYs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alakesh Haloi <alakesh.haloi@gmail.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 5.0 071/101] SUNRPC: fix uninitialized variable warning
Date:   Thu,  2 May 2019 17:21:13 +0200
Message-Id: <20190502143344.684910273@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143339.434882399@linuxfoundation.org>
References: <20190502143339.434882399@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 01f2f5b82a2b523ae76af53f2ff43c48dde10a00 ]

Avoid following compiler warning on uninitialized variable

net/sunrpc/xprtsock.c: In function ‘xs_read_stream_request.constprop’:
net/sunrpc/xprtsock.c:525:10: warning: ‘read’ may be used uninitialized in this function [-Wmaybe-uninitialized]
   return read;
          ^~~~
net/sunrpc/xprtsock.c:529:23: warning: ‘ret’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  return ret < 0 ? ret : read;
         ~~~~~~~~~~~~~~^~~~~~

Signed-off-by: Alakesh Haloi <alakesh.haloi@gmail.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 net/sunrpc/xprtsock.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 7754aa3e434f..f88c2bd1335a 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -486,8 +486,8 @@ xs_read_stream_request(struct sock_xprt *transport, struct msghdr *msg,
 		int flags, struct rpc_rqst *req)
 {
 	struct xdr_buf *buf = &req->rq_private_buf;
-	size_t want, read;
-	ssize_t ret;
+	size_t want, uninitialized_var(read);
+	ssize_t uninitialized_var(ret);
 
 	xs_read_header(transport, buf);
 
-- 
2.19.1



