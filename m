Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 223DA20D321
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 21:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729678AbgF2Sz5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 14:55:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:42464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729975AbgF2SzR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:55:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE93C25579;
        Mon, 29 Jun 2020 15:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593446142;
        bh=C6FW2g4U3g9zleI+T6QiaWuTQjwS7KiK2AgAFaLs56w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ng6HIQjcOEABxj12/uEgXMyLzxV8uqN0gez9wffQ1T3D0VOf3A8suWCkbGfgdV5Xs
         Ie5eIlxNPTY8lvxLjqyfLdJG6Ci7ZlnUei8AK18oC4NIhDckjl04UTSHHcJSDCKlOA
         7+Yl+01rQvgc1wOMo4Re4e9B2zjHAuKSB/RolAvg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chuck Lever <chuck.lever@oracle.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.4 130/135] SUNRPC: Properly set the @subbuf parameter of xdr_buf_subsegment()
Date:   Mon, 29 Jun 2020 11:53:04 -0400
Message-Id: <20200629155309.2495516-131-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629155309.2495516-1-sashal@kernel.org>
References: <20200629155309.2495516-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.229-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.229-rc1
X-KernelTest-Deadline: 2020-07-01T15:53+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

commit 89a3c9f5b9f0bcaa9aea3e8b2a616fcaea9aad78 upstream.

@subbuf is an output parameter of xdr_buf_subsegment(). A survey of
call sites shows that @subbuf is always uninitialized before
xdr_buf_segment() is invoked by callers.

There are some execution paths through xdr_buf_subsegment() that do
not set all of the fields in @subbuf, leaving some pointer fields
containing garbage addresses. Subsequent processing of that buffer
then results in a page fault.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/xdr.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/sunrpc/xdr.c b/net/sunrpc/xdr.c
index ed9bbd383f7d3..df7ecf9584f68 100644
--- a/net/sunrpc/xdr.c
+++ b/net/sunrpc/xdr.c
@@ -1031,6 +1031,7 @@ xdr_buf_subsegment(struct xdr_buf *buf, struct xdr_buf *subbuf,
 		base = 0;
 	} else {
 		base -= buf->head[0].iov_len;
+		subbuf->head[0].iov_base = buf->head[0].iov_base;
 		subbuf->head[0].iov_len = 0;
 	}
 
@@ -1043,6 +1044,8 @@ xdr_buf_subsegment(struct xdr_buf *buf, struct xdr_buf *subbuf,
 		base = 0;
 	} else {
 		base -= buf->page_len;
+		subbuf->pages = buf->pages;
+		subbuf->page_base = 0;
 		subbuf->page_len = 0;
 	}
 
@@ -1054,6 +1057,7 @@ xdr_buf_subsegment(struct xdr_buf *buf, struct xdr_buf *subbuf,
 		base = 0;
 	} else {
 		base -= buf->tail[0].iov_len;
+		subbuf->tail[0].iov_base = buf->tail[0].iov_base;
 		subbuf->tail[0].iov_len = 0;
 	}
 
-- 
2.25.1

