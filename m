Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EDFD28B65C
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388370AbgJLNdF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:33:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:34274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388530AbgJLNc1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:32:27 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82011204EA;
        Mon, 12 Oct 2020 13:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602509547;
        bh=LGXr3Fb2J82Lc2+22Ud1es4udhjjIXRiFM5vElhzJt4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cq7qKMvRAoq0P9xEI3iJ/GN9bzAZlYZK23q5bC92redngbyQvHJhlhUbrpIsWg9kU
         c0rMd1ZHUHnsSN/opzvuLsRf66Kw/EgzzLk+801paDNGq2BJ+K9RBC/6NE7NsVgWMi
         MSjZb6P/Vfs1MYheg6KGKwB6GwX9eHZqjYmLdCns=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jeffrey Mitchell <jeffrey.mitchell@starlab.io>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 08/39] nfs: Fix security label length not being reset
Date:   Mon, 12 Oct 2020 15:26:38 +0200
Message-Id: <20201012132628.543672457@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132628.130632267@linuxfoundation.org>
References: <20201012132628.130632267@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeffrey Mitchell <jeffrey.mitchell@starlab.io>

[ Upstream commit d33030e2ee3508d65db5644551435310df86010e ]

nfs_readdir_page_filler() iterates over entries in a directory, reusing
the same security label buffer, but does not reset the buffer's length.
This causes decode_attr_security_label() to return -ERANGE if an entry's
security label is longer than the previous one's. This error, in
nfs4_decode_dirent(), only gets passed up as -EAGAIN, which causes another
failed attempt to copy into the buffer. The second error is ignored and
the remaining entries do not show up in ls, specifically the getdents64()
syscall.

Reproduce by creating multiple files in NFS and giving one of the later
files a longer security label. ls will not see that file nor any that are
added afterwards, though they will exist on the backend.

In nfs_readdir_page_filler(), reset security label buffer length before
every reuse

Signed-off-by: Jeffrey Mitchell <jeffrey.mitchell@starlab.io>
Fixes: b4487b935452 ("nfs: Fix getxattr kernel panic and memory overflow")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/dir.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 21e5fcbcb2272..ba7e98d8ce098 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -562,6 +562,9 @@ int nfs_readdir_page_filler(nfs_readdir_descriptor_t *desc, struct nfs_entry *en
 	xdr_set_scratch_buffer(&stream, page_address(scratch), PAGE_SIZE);
 
 	do {
+		if (entry->label)
+			entry->label->len = NFS4_MAXLABELLEN;
+
 		status = xdr_decode(desc, entry, &stream);
 		if (status != 0) {
 			if (status == -EAGAIN)
-- 
2.25.1



