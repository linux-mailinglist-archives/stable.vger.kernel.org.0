Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D39052E78FA
	for <lists+stable@lfdr.de>; Wed, 30 Dec 2020 14:07:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727322AbgL3NFF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Dec 2020 08:05:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:54242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727313AbgL3NFF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Dec 2020 08:05:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA64022482;
        Wed, 30 Dec 2020 13:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609333424;
        bh=wNn5OVPGzvJBRu9PKBApH/bCNsGShBsY94tzkQUFjUI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YPtdTXYo2Y0THWx2KvpsLxnm9G24mlHfU1LW7HQ5nymVJx3yO6w9En+ppV+5Dyi/1
         11EM60tfUfoKgxk8VxI31ylUXEkvGvGEFRSfSwiQe0pLDWbEFxPqZ/LdxD0B5M62eT
         /BWkbilReIywQUJqovEL15cDzwbkdFsqEK3iHKHW6/vzx4sp2FnP8GVmPLos4NQpYa
         dkE1fAeh3v5/41lhMb+p+rMqKSJ2sIrzWczYcxqsRFfH/UVoUoWH0OvG+ay7RnkG//
         diWrulX9KiKGWVh80ImraYeONM8SQzMaoVGGvDWkihhmCNO9YNPUjTV8ebrez77mFO
         UznNyRe+YYgqA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, ceph-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 22/31] ceph: fix inode refcount leak when ceph_fill_inode on non-I_NEW inode fails
Date:   Wed, 30 Dec 2020 08:03:04 -0500
Message-Id: <20201230130314.3636961-22-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201230130314.3636961-1-sashal@kernel.org>
References: <20201230130314.3636961-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

