Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0A902E4222
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:18:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437247AbgL1OEE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:04:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:38306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727369AbgL1OED (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:04:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5BCD0206E5;
        Mon, 28 Dec 2020 14:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164202;
        bh=p+kYbOJpmrJ+mm5v3an7tXr+GUDnPviWZukcKIEvU3o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P1vtLzaVAI77YfFLDaixUAER1SHt+q0j+DPRCNQDdF/FOZ0fpgcF2FrL12V1JsLQn
         CRMvNs6cjE+xZja364NC5U44bpF6bDrN2VXjKoHkRUdfdykIuJnG3yZVuPO2KVPR/8
         XIKfDnLvj1F6lp+j2wVWCipJ1mLGqq4S01/Vn618=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 097/717] virtiofs fix leak in setup
Date:   Mon, 28 Dec 2020 13:41:35 +0100
Message-Id: <20201228125025.622765683@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

[ Upstream commit 66ab33bf6d4341574f88b511e856a73f6f2a921e ]

This can be triggered for example by adding the "-omand" mount option,
which will be rejected and virtio_fs_fill_super() will return an error.

In such a case the allocations for fuse_conn and fuse_mount will leak due
to s_root not yet being set and so ->put_super() not being called.

Fixes: a62a8ef9d97d ("virtio-fs: add virtiofs filesystem")
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/virtio_fs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index 21a9e534417c0..d2c0e58c6416f 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -1464,6 +1464,8 @@ static int virtio_fs_get_tree(struct fs_context *fsc)
 	if (!sb->s_root) {
 		err = virtio_fs_fill_super(sb, fsc);
 		if (err) {
+			fuse_mount_put(fm);
+			sb->s_fs_info = NULL;
 			deactivate_locked_super(sb);
 			return err;
 		}
-- 
2.27.0



