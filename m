Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F05A03CE1A6
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346472AbhGSP1I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:27:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:41938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348742AbhGSPZE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:25:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 040FF600EF;
        Mon, 19 Jul 2021 16:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710742;
        bh=zcdR+7Ixce2wcvSTjoQub02GaLVwOc/g7cAn+ekALic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xvW6ZKKrFCjv3SRruuGTIOR1tuK83lx3ZyL6M3LAAxeL9G9pWya3lC6/XjsACB+eY
         B8PIP5rAt4K4JgR/JV9eZ8Mngqw5er/5G5zzr8/8yThLYCc8ZtwHAvbi30Vbs4QgC4
         1e1DVaQxlFjoTjd0lKjrXJJmuKiNUEc733vDAHMU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 090/351] iov_iter_advance(): use consistent semantics for move past the end
Date:   Mon, 19 Jul 2021 16:50:36 +0200
Message-Id: <20210719144947.471372587@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 3b3fc051cd2cba42bf736fa62780857d251a1236 ]

asking to advance by more than we have left in the iov_iter should
move to the very end; it should *not* leave negative i->count and
it should not spew into syslog, etc. - it's a legitimate operation.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/iov_iter.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 9eb7c31688cc..459c33c26bea 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -1117,8 +1117,6 @@ static inline void pipe_truncate(struct iov_iter *i)
 static void pipe_advance(struct iov_iter *i, size_t size)
 {
 	struct pipe_inode_info *pipe = i->pipe;
-	if (unlikely(i->count < size))
-		size = i->count;
 	if (size) {
 		struct pipe_buffer *buf;
 		unsigned int p_mask = pipe->ring_size - 1;
@@ -1159,6 +1157,8 @@ static void iov_iter_bvec_advance(struct iov_iter *i, size_t size)
 
 void iov_iter_advance(struct iov_iter *i, size_t size)
 {
+	if (unlikely(i->count < size))
+		size = i->count;
 	if (unlikely(iov_iter_is_pipe(i))) {
 		pipe_advance(i, size);
 		return;
@@ -1168,7 +1168,6 @@ void iov_iter_advance(struct iov_iter *i, size_t size)
 		return;
 	}
 	if (unlikely(iov_iter_is_xarray(i))) {
-		size = min(size, i->count);
 		i->iov_offset += size;
 		i->count -= size;
 		return;
-- 
2.30.2



