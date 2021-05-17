Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 960B93831CC
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239767AbhEQOlE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:41:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:34044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240245AbhEQOhW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:37:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0413861401;
        Mon, 17 May 2021 14:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261069;
        bh=2zX5QNryXuHkHppIJ6sRzAzN6z5+2bkOJWv9MaTigCU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1ay6d/NdAQgeP6SwxeGJLYb7YS6JeXRMRWzP0Y1/8+Prp813jDrbYoBTn7X1L1qZf
         yopnyEy/NRScW+a28/AJ56KX/Elt/OykpqOOkk1MJx+40rE1PLhsmFqxQYJRdhS+rz
         FUat8dLLpev5Y7q8asMcpuZN/MFRD0PW5VU7U/a4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 067/329] virtiofs: fix userns
Date:   Mon, 17 May 2021 15:59:38 +0200
Message-Id: <20210517140304.333275313@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

[ Upstream commit 0a7419c68a45d2d066b996be5087aa2d07ce80eb ]

get_user_ns() is done twice (once in virtio_fs_get_tree() and once in
fuse_conn_init()), resulting in a reference leak.

Also looks better to use fsc->user_ns (which *should* be the
current_user_ns() at this point).

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/virtio_fs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index 1e5affed158e..005209b1cd50 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -1437,8 +1437,7 @@ static int virtio_fs_get_tree(struct fs_context *fsc)
 	if (!fm)
 		goto out_err;
 
-	fuse_conn_init(fc, fm, get_user_ns(current_user_ns()),
-		       &virtio_fs_fiq_ops, fs);
+	fuse_conn_init(fc, fm, fsc->user_ns, &virtio_fs_fiq_ops, fs);
 	fc->release = fuse_free_conn;
 	fc->delete_stale = true;
 	fc->auto_submounts = true;
-- 
2.30.2



