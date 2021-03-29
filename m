Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6C5E34CA1D
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233147AbhC2IfC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:35:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:53564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232118AbhC2Idq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:33:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E232A61580;
        Mon, 29 Mar 2021 08:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006826;
        bh=fB+bUIeCiRj31nOqz//yiESzdu73Ba1P883DWaOnAgQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dJrEOtMTaCe2kqrewIjk1JVNlu7dUOVcbt1OxESkzrLO0lhW/eZdYGjw48avzub28
         S3M6vKEFOmPj8K5Hf7qpc7BKTyYtZOLLfzSlyaxO3wUDzaeOApZ1BwrScJWlaXtkfS
         vOUTD4GAjY14MNGT35EQCikQ24i9yahwA+oFfBZM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tal Lossos <tallossos@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>, KP Singh <kpsingh@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 112/254] bpf: Change inode_storages lookup_elem return value from NULL to -EBADF
Date:   Mon, 29 Mar 2021 09:57:08 +0200
Message-Id: <20210329075636.891850944@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
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
index 6639640523c0..b58b2efb9b43 100644
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



