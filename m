Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC5C20DC4C
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732298AbgF2UOI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:14:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:40570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732851AbgF2TaT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:30:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E5DE252BA;
        Mon, 29 Jun 2020 15:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445027;
        bh=QGu1ul3MHIdZdof5n8qolPY0g5YIYXbad143qfGhvsY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BaojjbEtnRbEe1U12iPK9But0bZXmAw83OxG8irnU4YTMHhv3emXJvoC1UFuROy4G
         URz2+Mv+VyExbrpmR0bhdmH6fGM4L6LLhGztLphf5npm3M6mQzRzWXIom9saCZyp3y
         56cDMzPpIqN3klO5RoJarahrnQBgvgrevHsoLOBA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chuck Lever <chuck.lever@oracle.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.19 125/131] SUNRPC: Properly set the @subbuf parameter of xdr_buf_subsegment()
Date:   Mon, 29 Jun 2020 11:34:56 -0400
Message-Id: <20200629153502.2494656-126-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629153502.2494656-1-sashal@kernel.org>
References: <20200629153502.2494656-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.131-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.131-rc1
X-KernelTest-Deadline: 2020-07-01T15:34+00:00
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
index ac16f509c95cb..540e340e2565c 100644
--- a/net/sunrpc/xdr.c
+++ b/net/sunrpc/xdr.c
@@ -1036,6 +1036,7 @@ xdr_buf_subsegment(struct xdr_buf *buf, struct xdr_buf *subbuf,
 		base = 0;
 	} else {
 		base -= buf->head[0].iov_len;
+		subbuf->head[0].iov_base = buf->head[0].iov_base;
 		subbuf->head[0].iov_len = 0;
 	}
 
@@ -1048,6 +1049,8 @@ xdr_buf_subsegment(struct xdr_buf *buf, struct xdr_buf *subbuf,
 		base = 0;
 	} else {
 		base -= buf->page_len;
+		subbuf->pages = buf->pages;
+		subbuf->page_base = 0;
 		subbuf->page_len = 0;
 	}
 
@@ -1059,6 +1062,7 @@ xdr_buf_subsegment(struct xdr_buf *buf, struct xdr_buf *subbuf,
 		base = 0;
 	} else {
 		base -= buf->tail[0].iov_len;
+		subbuf->tail[0].iov_base = buf->tail[0].iov_base;
 		subbuf->tail[0].iov_len = 0;
 	}
 
-- 
2.25.1

