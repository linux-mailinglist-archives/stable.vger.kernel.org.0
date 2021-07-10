Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E80CB3C2D49
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232585AbhGJCWX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:22:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:38804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232437AbhGJCVt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:21:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80DC361419;
        Sat, 10 Jul 2021 02:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883544;
        bh=HAf0RaDTzDP5F1hXJJDZbhvANHYbr8yOdM2uGhwNgiI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PWzZ9pstKDLQjTYsSSze3jwcJ9ZCjEA3cg5DX6CXBiciUIn9NZVnsGBcMA9MvJ5NX
         0U/XBYFA+UlKfCkT0pBEHVA9XSh54BDTez6fmacEjy4ldMamP47XraSwmuyoPEXVbd
         ojVX5hLcLEzGrQCtVGjsw8Vxb65LSOnE9+K7NXhnCUSDObMmh4whTqyvNpFA5tLt3K
         TJRSBxgBlwyJBIXFeZkVy5v/HeMBIMoSFRw+qRO8VPEAEyth3OgACx5gqaX1nTmmh4
         wXmApafNDucJ3FztGSrAkdPQUcJgnLya7Hl7+z+klV4tLIM0xK8vjPx4mrmLMs7Dwe
         xZGLRZwOl86JA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Al Viro <viro@zeniv.linux.org.uk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.13 055/114] iov_iter_advance(): use consistent semantics for move past the end
Date:   Fri,  9 Jul 2021 22:16:49 -0400
Message-Id: <20210710021748.3167666-55-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710021748.3167666-1-sashal@kernel.org>
References: <20210710021748.3167666-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index c701b7a187f2..82a889283eca 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -1092,8 +1092,6 @@ static inline void pipe_truncate(struct iov_iter *i)
 static void pipe_advance(struct iov_iter *i, size_t size)
 {
 	struct pipe_inode_info *pipe = i->pipe;
-	if (unlikely(i->count < size))
-		size = i->count;
 	if (size) {
 		struct pipe_buffer *buf;
 		unsigned int p_mask = pipe->ring_size - 1;
@@ -1134,6 +1132,8 @@ static void iov_iter_bvec_advance(struct iov_iter *i, size_t size)
 
 void iov_iter_advance(struct iov_iter *i, size_t size)
 {
+	if (unlikely(i->count < size))
+		size = i->count;
 	if (unlikely(iov_iter_is_pipe(i))) {
 		pipe_advance(i, size);
 		return;
@@ -1143,7 +1143,6 @@ void iov_iter_advance(struct iov_iter *i, size_t size)
 		return;
 	}
 	if (unlikely(iov_iter_is_xarray(i))) {
-		size = min(size, i->count);
 		i->iov_offset += size;
 		i->count -= size;
 		return;
-- 
2.30.2

