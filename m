Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB8CE417274
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 14:48:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344112AbhIXMsp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 08:48:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:43670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343992AbhIXMrr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:47:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6408D61263;
        Fri, 24 Sep 2021 12:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632487574;
        bh=USBqHPyVKpcA+LHYOsL14wSkZjUUKtnX5yh9viTHh18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hEtZgoiQQEwiIdaaOMHPtShAruvDR4WAFEaf8W1H7IiAi0Bcqe3R61bcGrV+GFC4h
         vsHl2x4NC0DTD6LlacOQohcGdsi/0HZqf0pFAI+g0SaZDs4dvUoOB4zzPfYY7MVl/I
         YlUyJf9mgS9BsS5RrvsC4xKLdvS6mJJD5DBkiIAk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 17/26] ceph: lockdep annotations for try_nonblocking_invalidate
Date:   Fri, 24 Sep 2021 14:44:05 +0200
Message-Id: <20210924124328.919205238@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124328.336953942@linuxfoundation.org>
References: <20210924124328.336953942@linuxfoundation.org>
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
index 0eb2ada032c7..839bccbcc9d6 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1572,6 +1572,8 @@ static int __mark_caps_flushing(struct inode *inode,
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



