Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9882B29C702
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 19:28:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389214AbgJ0S04 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 14:26:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:47762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753576AbgJ0OAX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:00:23 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A2F921D7B;
        Tue, 27 Oct 2020 14:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603807222;
        bh=qr5IBMUcnmL6i6o7msUoTodHVxH92J3rwPTt3mSQ8hE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BVbz4zUqmhkUhKLcQlrE1qTjr+UkoTJOolCM6FIqxyoHHx+IjKF3bvuhk8I19Qxzq
         JJn+8M1fKx8hqQqJXRUyvqoumzrqaIjDfex7/Dtp4QuHJhSYSWOklbGgGMRXNBA3VC
         F4KdDmCUtMIwP3WcpFVguLJtMNuslGnMdSaN6V04=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+aed06913f36eff9b544e@syzkaller.appspotmail.com,
        Rustam Kovhaev <rkovhaev@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Altaparmakov <anton@tuxera.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 087/112] ntfs: add check for mft record size in superblock
Date:   Tue, 27 Oct 2020 14:49:57 +0100
Message-Id: <20201027134904.659373069@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134900.532249571@linuxfoundation.org>
References: <20201027134900.532249571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rustam Kovhaev <rkovhaev@gmail.com>

[ Upstream commit 4f8c94022f0bc3babd0a124c0a7dcdd7547bd94e ]

Number of bytes allocated for mft record should be equal to the mft record
size stored in ntfs superblock as reported by syzbot, userspace might
trigger out-of-bounds read by dereferencing ctx->attr in ntfs_attr_find()

Reported-by: syzbot+aed06913f36eff9b544e@syzkaller.appspotmail.com
Signed-off-by: Rustam Kovhaev <rkovhaev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Tested-by: syzbot+aed06913f36eff9b544e@syzkaller.appspotmail.com
Acked-by: Anton Altaparmakov <anton@tuxera.com>
Link: https://syzkaller.appspot.com/bug?extid=aed06913f36eff9b544e
Link: https://lkml.kernel.org/r/20200824022804.226242-1-rkovhaev@gmail.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/inode.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/ntfs/inode.c b/fs/ntfs/inode.c
index d284f07eda775..38260c07de8b5 100644
--- a/fs/ntfs/inode.c
+++ b/fs/ntfs/inode.c
@@ -1844,6 +1844,12 @@ int ntfs_read_inode_mount(struct inode *vi)
 		brelse(bh);
 	}
 
+	if (le32_to_cpu(m->bytes_allocated) != vol->mft_record_size) {
+		ntfs_error(sb, "Incorrect mft record size %u in superblock, should be %u.",
+				le32_to_cpu(m->bytes_allocated), vol->mft_record_size);
+		goto err_out;
+	}
+
 	/* Apply the mst fixups. */
 	if (post_read_mst_fixup((NTFS_RECORD*)m, vol->mft_record_size)) {
 		/* FIXME: Try to use the $MFTMirr now. */
-- 
2.25.1



