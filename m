Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0A9D291B9D
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 21:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732542AbgJRTcr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 15:32:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:42392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731899AbgJRT04 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:26:56 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98C68207DE;
        Sun, 18 Oct 2020 19:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603049216;
        bh=wwcSHnEGzPMRuAF0NbOb9fwXJ3eDhP46kueuiqZkXOc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g7J5NAeccAHPY3wvg0DDsM50aYATualjrRZPKdRpkckGDlfhfh2GDz0MlD8WyvK5F
         9xgBamAA7dp5QAp+HAvgl1+V+kPt6ajyjtuBusbRdLlGrjXL+v0zW0uXBT7PhxATdB
         fVKQBVvhKiWS60/aizKOyusUsTRVvlBmt9U+u8Ck=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rustam Kovhaev <rkovhaev@gmail.com>,
        syzbot+aed06913f36eff9b544e@syzkaller.appspotmail.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Altaparmakov <anton@tuxera.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-ntfs-dev@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.9 16/41] ntfs: add check for mft record size in superblock
Date:   Sun, 18 Oct 2020 15:26:10 -0400
Message-Id: <20201018192635.4056198-16-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192635.4056198-1-sashal@kernel.org>
References: <20201018192635.4056198-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 7c410f8794124..2aa073b82d30f 100644
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

