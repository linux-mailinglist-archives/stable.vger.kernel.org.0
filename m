Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2DEF37426B
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 18:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235596AbhEEQqt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 12:46:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:49510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235788AbhEEQpB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:45:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 615D461924;
        Wed,  5 May 2021 16:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232541;
        bh=KjIbtQturyaX5JvK1zjF8fkhJORDXNC82qCyUxG0KHU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=feEJbHXTPENpgMtM/vWu1GtRnn6qf+EgoteyiTYYe+71WqYO3QkOHyBuzCI2w7BpJ
         /z0LSfHZkIZKiey/o5qOBEknAkLaf1Lfz3tmus629E4uMeU6eY1odAmLW/CyBIq6vv
         M7CtIrLF81D9FSDO4E35ki2fkLJH2gjWM/X5sXokgIu4q80TxnZGvgNwqMe7C9w98b
         odZEoF0HknCE6Hw4CwDQHmArppJ3IhwQj2mJJKdguy8Rqqgd894qer+PWClVqzl6JA
         wiIuo7KFuVtTR1anlm8+RRAF9qcThzjHd4q+LpzeZRqemgEx+YZ3C1KCjwAeR8kGt1
         qmq+eOTqWg9hQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        virtualization@lists.linux-foundation.org,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 060/104] virtiofs: fix userns
Date:   Wed,  5 May 2021 12:33:29 -0400
Message-Id: <20210505163413.3461611-60-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163413.3461611-1-sashal@kernel.org>
References: <20210505163413.3461611-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 4ee6f734ba83..46e243bcb150 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -1436,8 +1436,7 @@ static int virtio_fs_get_tree(struct fs_context *fsc)
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

