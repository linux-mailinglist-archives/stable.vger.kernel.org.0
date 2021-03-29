Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 903CC34C85C
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233296AbhC2IVk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:21:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:36736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233366AbhC2IUx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:20:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8AAEA61554;
        Mon, 29 Mar 2021 08:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006041;
        bh=vTiQ4lbdj/zsCApx9tl3LVRNY6OLYz9huurQkgXcsIQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qSTScNiyC/E72thRdC3eujDg+KBovqj3ajev4kZKE19kgt3z45nzfo+9jqWP3t5mE
         ai1CbEklbXzYv893snmOU/KEX7pO5T1mbTd37p1gng8ArLKhfh3+ZoCoelWAnfZRb+
         7nRhyOlCMD8R9Xtdg1r7EKNDxsugBWkmxhXAYvkc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tal Lossos <tallossos@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>, KP Singh <kpsingh@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 095/221] bpf: Change inode_storages lookup_elem return value from NULL to -EBADF
Date:   Mon, 29 Mar 2021 09:57:06 +0200
Message-Id: <20210329075632.374491687@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tal Lossos <tallossos@gmail.com>

[ Upstream commit 769c18b254ca191b45047e1fcb3b2ce56fada0b6 ]

bpf_fd_inode_storage_lookup_elem() returned NULL when getting a bad FD,
which caused -ENOENT in bpf_map_copy_value. -EBADF error is better than
-ENOENT for a bad FD behaviour.

The patch was partially contributed by CyberArk Software, Inc.

Fixes: 8ea636848aca ("bpf: Implement bpf_local_storage for inodes")
Signed-off-by: Tal Lossos <tallossos@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Yonghong Song <yhs@fb.com>
Acked-by: KP Singh <kpsingh@kernel.org>
Link: https://lore.kernel.org/bpf/20210307120948.61414-1-tallossos@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/bpf_inode_storage.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/bpf_inode_storage.c b/kernel/bpf/bpf_inode_storage.c
index c2a501cd90eb..a4ac48c7dada 100644
--- a/kernel/bpf/bpf_inode_storage.c
+++ b/kernel/bpf/bpf_inode_storage.c
@@ -109,7 +109,7 @@ static void *bpf_fd_inode_storage_lookup_elem(struct bpf_map *map, void *key)
 	fd = *(int *)key;
 	f = fget_raw(fd);
 	if (!f)
-		return NULL;
+		return ERR_PTR(-EBADF);
 
 	sdata = inode_storage_lookup(f->f_inode, map, true);
 	fput(f);
-- 
2.30.1



