Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3D93743FE
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 19:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236314AbhEEQx4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 12:53:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:36276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235335AbhEEQvt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:51:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4933D61969;
        Wed,  5 May 2021 16:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232675;
        bh=S6mHnGbcMAlOfu21dw04qkZuYKHktDgvstABXYrwtcE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u5DYOaxl8Os6Rp5I9bFCr0QcNRxyBiwIYkGMNggGVyVkkaH9pW9DSpyNhkX9z8s2s
         DHMaR1R5RoZkV344uMdatl/2l0OY8h00dbRMhif5q5ROPC4uoMci34zPRvp2WoN9Or
         fcb3wPf650uJHd9ixeWRrz2bUvwqVd3HAPaCKmkDEtX9E1/ruLU0KlxE7AGLsg2yOT
         lXNCTZEcS4zKBzhGsmpUyaChv9Qa7htIc+7TxVY+dmbMLcYokOrjLcWLoT0Qg5AQYQ
         uxtDkmK/FCUrmgCE2OB+O/6tl0S0+YPp3vzWcrVWIEQM8ybcTaQmV3y/zr9+wiM8uU
         heqoCAEHa/oDg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        virtualization@lists.linux-foundation.org,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 45/85] virtiofs: fix userns
Date:   Wed,  5 May 2021 12:36:08 -0400
Message-Id: <20210505163648.3462507-45-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163648.3462507-1-sashal@kernel.org>
References: <20210505163648.3462507-1-sashal@kernel.org>
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
index 3d83c9e12848..9c0211a629d6 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -1456,8 +1456,7 @@ static int virtio_fs_get_tree(struct fs_context *fsc)
 		return -ENOMEM;
 	}
 
-	fuse_conn_init(fc, fm, get_user_ns(current_user_ns()),
-		       &virtio_fs_fiq_ops, fs);
+	fuse_conn_init(fc, fm, fsc->user_ns, &virtio_fs_fiq_ops, fs);
 	fc->release = fuse_free_conn;
 	fc->delete_stale = true;
 	fc->auto_submounts = true;
-- 
2.30.2

