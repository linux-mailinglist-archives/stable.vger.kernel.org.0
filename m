Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF2CC31379D
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:29:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233927AbhBHP2i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:28:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:35868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233881AbhBHPX0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:23:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8AEFD64F0F;
        Mon,  8 Feb 2021 15:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797254;
        bh=csgGPtw0nfHMpqHzEKYlrXpCeoxyEDunEzrWeE+k//I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AB3XeuvbSyjd+jnx/xFzZPsvq3zMCYl3V2mnIAxz5coQWEynt+PwewegIvfDclKcK
         TABi5LCaOWuT9tOW9MzUQvtPkiH/sxz7aEMGQryBzcp5qmOx2tIwJSwW4hSOd6Aq/O
         +BbOxv7TdnkIlMyTbQOFPClGgR6ufZ59HD5TltB8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pan Bian <bianpan2016@163.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        KP Singh <kpsingh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 028/120] bpf, inode_storage: Put file handler if no storage was found
Date:   Mon,  8 Feb 2021 16:00:15 +0100
Message-Id: <20210208145819.516525622@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
References: <20210208145818.395353822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>

[ Upstream commit b9557caaf872271671bdc1ef003d72f421eb72f6 ]

Put file f if inode_storage_ptr() returns NULL.

Fixes: 8ea636848aca ("bpf: Implement bpf_local_storage for inodes")
Signed-off-by: Pan Bian <bianpan2016@163.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: KP Singh <kpsingh@kernel.org>
Link: https://lore.kernel.org/bpf/20210121020856.25507-1-bianpan2016@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/bpf_inode_storage.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/bpf_inode_storage.c b/kernel/bpf/bpf_inode_storage.c
index dbc1dbdd2cbf0..c2a501cd90eba 100644
--- a/kernel/bpf/bpf_inode_storage.c
+++ b/kernel/bpf/bpf_inode_storage.c
@@ -125,8 +125,12 @@ static int bpf_fd_inode_storage_update_elem(struct bpf_map *map, void *key,
 
 	fd = *(int *)key;
 	f = fget_raw(fd);
-	if (!f || !inode_storage_ptr(f->f_inode))
+	if (!f)
+		return -EBADF;
+	if (!inode_storage_ptr(f->f_inode)) {
+		fput(f);
 		return -EBADF;
+	}
 
 	sdata = bpf_local_storage_update(f->f_inode,
 					 (struct bpf_local_storage_map *)map,
-- 
2.27.0



