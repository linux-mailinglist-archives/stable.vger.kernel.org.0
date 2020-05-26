Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDA131E2DE1
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391686AbgEZTHA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:07:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:35516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389901AbgEZTG7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:06:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A9C2208B3;
        Tue, 26 May 2020 19:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590520019;
        bh=4VPdxXWjr16mx7dly3zIokwM4xa2s8mgnV64LSzfatA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=okNSGQKFxtfTd/7RoLv8Oc16G6PVNdKMNDCWbwCokQc6ZCxB9zHYxA6Pm1jrYW07O
         gGSvJRazMQCJ0vj0all4ucGPGPVOM/WMQgVsIEiRZxORSVGLkZM0/qaYh48Kr84SuC
         VLwKXIx5RrlpFCB+h4p0zDYeOlDBVFW1Fn7QQkzY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>, Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 026/111] configfs: fix config_item refcnt leak in configfs_rmdir()
Date:   Tue, 26 May 2020 20:52:44 +0200
Message-Id: <20200526183935.217763918@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183932.245016380@linuxfoundation.org>
References: <20200526183932.245016380@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiyu Yang <xiyuyang19@fudan.edu.cn>

[ Upstream commit 8aebfffacfa379ba400da573a5bf9e49634e38cb ]

configfs_rmdir() invokes configfs_get_config_item(), which returns a
reference of the specified config_item object to "parent_item" with
increased refcnt.

When configfs_rmdir() returns, local variable "parent_item" becomes
invalid, so the refcount should be decreased to keep refcount balanced.

The reference counting issue happens in one exception handling path of
configfs_rmdir(). When down_write_killable() fails, the function forgets
to decrease the refcnt increased by configfs_get_config_item(), causing
a refcnt leak.

Fix this issue by calling config_item_put() when down_write_killable()
fails.

Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/configfs/dir.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index cf7b7e1d5bd7..cb733652ecca 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -1519,6 +1519,7 @@ static int configfs_rmdir(struct inode *dir, struct dentry *dentry)
 		spin_lock(&configfs_dirent_lock);
 		configfs_detach_rollback(dentry);
 		spin_unlock(&configfs_dirent_lock);
+		config_item_put(parent_item);
 		return -EINTR;
 	}
 	frag->frag_dead = true;
-- 
2.25.1



