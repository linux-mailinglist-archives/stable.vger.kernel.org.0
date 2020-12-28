Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CADD2E4047
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:51:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437727AbgL1OUN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:20:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:55632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437712AbgL1OUN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:20:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EACF120791;
        Mon, 28 Dec 2020 14:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165172;
        bh=CMKylOKtoHz1W0vslQVxsRmMu8bKNp+Ga+jf0yGqgTE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zm+Jx4gBqZsIqUlO+ycSapVSkgMA+xYAuy7rfsKyamT0sMGBmnX1e/7vVzD/gul1G
         Wz3OZJHCtXqJ6C/2IfP1Wwjt5/3oNUaxrkX/FUJ5tViOjRR9rKTWj1o02WF2+oOT2m
         nxKMfkqCLL2Swd7yv0Cv1X5mWKff/1tc8nM+4CvU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Aloni <dan@kernelim.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 437/717] sunrpc: fix xs_read_xdr_buf for partial pages receive
Date:   Mon, 28 Dec 2020 13:47:15 +0100
Message-Id: <20201228125041.909680863@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Aloni <dan@kernelim.com>

[ Upstream commit ac9645c87380e39a8fa87a1b51721efcdea89dbf ]

When receiving pages data, return value 'ret' when positive includes
`buf->page_base`, so we should subtract that before it is used for
changing `offset` and comparing against `want`.

This was discovered on the very rare cases where the server returned a
chunk of bytes that when added to the already received amount of bytes
for the pages happened to match the current `recv.len`, for example
on this case:

     buf->page_base : 258356
     actually received from socket: 1740
     ret : 260096
     want : 260096

In this case neither of the two 'if ... goto out' trigger, and we
continue to tail parsing.

Worth to mention that the ensuing EMSGSIZE from the continued execution of
`xs_read_xdr_buf` may be observed by an application due to 4 superfluous
bytes being added to the pages data.

Fixes: 277e4ab7d530 ("SUNRPC: Simplify TCP receive code by switching to using iterators")
Signed-off-by: Dan Aloni <dan@kernelim.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtsock.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index c93ff70da3f98..c56a66cdf4ac8 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -433,7 +433,8 @@ xs_read_xdr_buf(struct socket *sock, struct msghdr *msg, int flags,
 		if (ret <= 0)
 			goto sock_err;
 		xs_flush_bvec(buf->bvec, ret, seek + buf->page_base);
-		offset += ret - buf->page_base;
+		ret -= buf->page_base;
+		offset += ret;
 		if (offset == count || msg->msg_flags & (MSG_EOR|MSG_TRUNC))
 			goto out;
 		if (ret != want)
-- 
2.27.0



