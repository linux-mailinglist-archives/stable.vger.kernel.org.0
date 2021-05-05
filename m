Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C81CC374156
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 18:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234678AbhEEQhP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 12:37:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:54648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234506AbhEEQfM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:35:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6863B61430;
        Wed,  5 May 2021 16:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232379;
        bh=KjIbtQturyaX5JvK1zjF8fkhJORDXNC82qCyUxG0KHU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dzOESbwhTDROlsr2XbecGCKOW9C0oktb0Y0nU7lmIvP6AgbavoXd1r2PkZ4G2ORuQ
         h9VO1VsJVBUKbzchpzN3UaFjF2SlC9xhcFgERSc1iDy+2FuMqO1MgM2CDyyeeWZPeE
         HORjoUAD34UUvi65oZTNeOzLcsEBxQ4Ver+B4OLLaQzp1g/gqzmDi08PmwIvwvZB0H
         EfIJDLqhmsXgtlP26RcAmTDF2RfxfEOMmrzmqXePBTPq2NXSYgQgPISf9oJ0KGldww
         Rcb42GbkOzP2wo9Y3jisHMq+1knpzxfElWiSrbC5uAgQLeBKu5Hcg1QCiw22TP/s2q
         qYUd3EtOTZiGA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        virtualization@lists.linux-foundation.org,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 067/116] virtiofs: fix userns
Date:   Wed,  5 May 2021 12:30:35 -0400
Message-Id: <20210505163125.3460440-67-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163125.3460440-1-sashal@kernel.org>
References: <20210505163125.3460440-1-sashal@kernel.org>
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

