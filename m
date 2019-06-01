Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9102531D62
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 15:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729851AbfFAN0q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 09:26:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:57284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729845AbfFAN0q (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Jun 2019 09:26:46 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96367273C3;
        Sat,  1 Jun 2019 13:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559395605;
        bh=QKHwLt3uugsnYRvB0JA2qbRzynAt2NN7z333VfW/eFc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PJnn2z4b8B5dOxd5SeB2fsMr51PbYeyL2ucR44xTJI4bKYK9AL2BCc+Pca19dPzlO
         Mrz29XjFGJFTTKzhZIV77dsMQE5BBpgJgLpwlWvQNBS/b7IH+lvT4xjEyLLadbAyok
         FmnOOZwhaA27CxchaSTPiKze9jhwFsiPE6Sf/Q18=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kirill Smelkov <kirr@nexedi.com>,
        Han-Wen Nienhuys <hanwen@google.com>,
        Jakob Unterwurzacher <jakobunt@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 24/56] fuse: require /dev/fuse reads to have enough buffer capacity
Date:   Sat,  1 Jun 2019 09:25:28 -0400
Message-Id: <20190601132600.27427-24-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190601132600.27427-1-sashal@kernel.org>
References: <20190601132600.27427-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kirill Smelkov <kirr@nexedi.com>

[ Upstream commit d4b13963f217dd947da5c0cabd1569e914d21699 ]

A FUSE filesystem server queues /dev/fuse sys_read calls to get
filesystem requests to handle. It does not know in advance what would be
that request as it can be anything that client issues - LOOKUP, READ,
WRITE, ... Many requests are short and retrieve data from the
filesystem. However WRITE and NOTIFY_REPLY write data into filesystem.

Before getting into operation phase, FUSE filesystem server and kernel
client negotiate what should be the maximum write size the client will
ever issue. After negotiation the contract in between server/client is
that the filesystem server then should queue /dev/fuse sys_read calls with
enough buffer capacity to receive any client request - WRITE in
particular, while FUSE client should not, in particular, send WRITE
requests with > negotiated max_write payload. FUSE client in kernel and
libfuse historically reserve 4K for request header. This way the
contract is that filesystem server should queue sys_reads with
4K+max_write buffer.

If the filesystem server does not follow this contract, what can happen
is that fuse_dev_do_read will see that request size is > buffer size,
and then it will return EIO to client who issued the request but won't
indicate in any way that there is a problem to filesystem server.
This can be hard to diagnose because for some requests, e.g. for
NOTIFY_REPLY which mimics WRITE, there is no client thread that is
waiting for request completion and that EIO goes nowhere, while on
filesystem server side things look like the kernel is not replying back
after successful NOTIFY_RETRIEVE request made by the server.

We can make the problem easy to diagnose if we indicate via error return to
filesystem server when it is violating the contract.  This should not
practically cause problems because if a filesystem server is using shorter
buffer, writes to it were already very likely to cause EIO, and if the
filesystem is read-only it should be too following FUSE_MIN_READ_BUFFER
minimum buffer size.

Please see [1] for context where the problem of stuck filesystem was hit
for real (because kernel client was incorrectly sending more than
max_write data with NOTIFY_REPLY; see also previous patch), how the
situation was traced and for more involving patch that did not make it
into the tree.

[1] https://marc.info/?l=linux-fsdevel&m=155057023600853&w=2

Signed-off-by: Kirill Smelkov <kirr@nexedi.com>
Cc: Han-Wen Nienhuys <hanwen@google.com>
Cc: Jakob Unterwurzacher <jakobunt@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/dev.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 341196338e484..fbb978e75c6be 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1265,6 +1265,16 @@ static ssize_t fuse_dev_do_read(struct fuse_dev *fud, struct file *file,
 	struct fuse_in *in;
 	unsigned reqsize;
 
+	/*
+	 * Require sane minimum read buffer - that has capacity for fixed part
+	 * of any request header + negotated max_write room for data. If the
+	 * requirement is not satisfied return EINVAL to the filesystem server
+	 * to indicate that it is not following FUSE server/client contract.
+	 * Don't dequeue / abort any request.
+	 */
+	if (nbytes < max_t(size_t, FUSE_MIN_READ_BUFFER, 4096 + fc->max_write))
+		return -EINVAL;
+
  restart:
 	spin_lock(&fiq->waitq.lock);
 	err = -EAGAIN;
-- 
2.20.1

