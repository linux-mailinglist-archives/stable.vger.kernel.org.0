Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0F632E99C1
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 17:06:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729045AbhADQDL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 11:03:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:40326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727978AbhADQDL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 11:03:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3ECCF21D93;
        Mon,  4 Jan 2021 16:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609776175;
        bh=wNn5OVPGzvJBRu9PKBApH/bCNsGShBsY94tzkQUFjUI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V2gvWVPxqlyDqQllSYVYp76L31dOfdQD89xB6V5iR/gc8RAoBZWTzHEh4zcx++0P5
         Rkem13XGhX9ozcq1Zhhm50yCfWR5zW9mRXarZOY+AdG+Ixgx9tGtMyv2++FnwVk6DP
         dL0FCgxTvrNFuLW26ivAZ9Y2RHgaUdG/8A6mIYi4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 55/63] ceph: fix inode refcount leak when ceph_fill_inode on non-I_NEW inode fails
Date:   Mon,  4 Jan 2021 16:57:48 +0100
Message-Id: <20210104155711.482932410@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210104155708.800470590@linuxfoundation.org>
References: <20210104155708.800470590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 68cbb8056a4c24c6a38ad2b79e0a9764b235e8fa ]

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 526faf4778ce4..2462a9a84b956 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -1335,6 +1335,8 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
 				in, ceph_vinop(in));
 			if (in->i_state & I_NEW)
 				discard_new_inode(in);
+			else
+				iput(in);
 			goto done;
 		}
 		req->r_target_inode = in;
-- 
2.27.0



