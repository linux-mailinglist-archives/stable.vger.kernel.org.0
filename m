Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84B97417437
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345458AbhIXND4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:03:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:56170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345658AbhIXNBw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 09:01:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 73F2561409;
        Fri, 24 Sep 2021 12:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632488062;
        bh=LvdMkAyf+qOvWB98GNR36MD2RLgacGuOKBJBG0s48SY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EtbiiEjf3HGMoNI44JdtaZMIkHhASE6MVH7tmBDDntaEDE3KEBQLrZ/K1rEaT5QvZ
         7uW1f3bqX9Ya6/uW8NfFGc/58b69Ypjzu/aCtZDg3DW4izLiVdJ8AyartVy/Lwf1B7
         a34qQqV5WlBQxHsTKdBhBK46CrEqk7so+zT0rzN8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 067/100] ceph: lockdep annotations for try_nonblocking_invalidate
Date:   Fri, 24 Sep 2021 14:44:16 +0200
Message-Id: <20210924124343.681293593@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124341.214446495@linuxfoundation.org>
References: <20210924124341.214446495@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 3eaf5aa1cfa8c97c72f5824e2e9263d6cc977b03 ]

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/caps.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index c619a926dc18..3296a93be907 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1859,6 +1859,8 @@ static u64 __mark_caps_flushing(struct inode *inode,
  * try to invalidate mapping pages without blocking.
  */
 static int try_nonblocking_invalidate(struct inode *inode)
+	__releases(ci->i_ceph_lock)
+	__acquires(ci->i_ceph_lock)
 {
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	u32 invalidating_gen = ci->i_rdcache_gen;
-- 
2.33.0



