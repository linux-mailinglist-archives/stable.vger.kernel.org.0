Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DFB7318E15
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 16:23:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbhBKPUc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 10:20:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:51606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230118AbhBKPNT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 10:13:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 14F0464EF8;
        Thu, 11 Feb 2021 15:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613055900;
        bh=lzV1Rkiz6ux/f+cEQb6FghqVNqxAghEf1kzhFnYXk+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qZWYtGpqVAJ9IkE9OsNVV/AjtdzlxpubQxb0gw9PGstNAc7wjPlP74TNN+niBKEpK
         xoiSdPTHqe2kVhsGQ9LMuiOmbhJF3XXwUszWbE2/nqL9iChzJ3kQv3D2lKw/ccPR7e
         qFXOtKr5JFkEkwzysKnOjFiIUx6VL2E1azQ2h31c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+6fba78f99b9afd4b5634@syzkaller.appspotmail.com,
        Phillip Lougher <phillip@squashfs.org.uk>,
        Philippe Liard <pliard@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 51/54] squashfs: avoid out of bounds writes in decompressors
Date:   Thu, 11 Feb 2021 16:02:35 +0100
Message-Id: <20210211150155.100243358@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210211150152.885701259@linuxfoundation.org>
References: <20210211150152.885701259@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Phillip Lougher <phillip@squashfs.org.uk>

commit e812cbbbbbb15adbbbee176baa1e8bda53059bf0 upstream.

Patch series "Squashfs: fix BIO migration regression and add sanity checks".

Patch [1/4] fixes a regression introduced by the "migrate from
ll_rw_block usage to BIO" patch, which has produced a number of
Sysbot/Syzkaller reports.

Patches [2/4], [3/4], and [4/4] fix a number of filesystem corruption
issues which have produced Sysbot reports in the id, inode and xattr
lookup code.

Each patch has been tested against the Sysbot reproducers using the
given kernel configuration.  They have the appropriate "Reported-by:"
lines added.

Additionally, all of the reproducer filesystems are indirectly fixed by
patch [4/4] due to the fact they all have xattr corruption which is now
detected there.

Additional testing with other configurations and architectures (32bit,
big endian), and normal filesystems has also been done to trap any
inadvertent regressions caused by the additional sanity checks.

This patch (of 4):

This is a regression introduced by the patch "migrate from ll_rw_block
usage to BIO".

Sysbot/Syskaller has reported a number of "out of bounds writes" and
"unable to handle kernel paging request in squashfs_decompress" errors
which have been identified as a regression introduced by the above
patch.

Specifically, the patch removed the following sanity check

        if (length < 0 || length > output->length ||
		(index + length) > msblk->bytes_used)

This check did two things:

1. It ensured any reads were not beyond the end of the filesystem

2. It ensured that the "length" field read from the filesystem
   was within the expected maximum length.  Without this any
   corrupted values can over-run allocated buffers.

Link: https://lkml.kernel.org/r/20210204130249.4495-1-phillip@squashfs.org.uk
Link: https://lkml.kernel.org/r/20210204130249.4495-2-phillip@squashfs.org.uk
Fixes: 93e72b3c612adc ("squashfs: migrate from ll_rw_block usage to BIO")
Reported-by: syzbot+6fba78f99b9afd4b5634@syzkaller.appspotmail.com
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Cc: Philippe Liard <pliard@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/squashfs/block.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/squashfs/block.c
+++ b/fs/squashfs/block.c
@@ -196,9 +196,15 @@ int squashfs_read_data(struct super_bloc
 		length = SQUASHFS_COMPRESSED_SIZE(length);
 		index += 2;
 
-		TRACE("Block @ 0x%llx, %scompressed size %d\n", index,
+		TRACE("Block @ 0x%llx, %scompressed size %d\n", index - 2,
 		      compressed ? "" : "un", length);
 	}
+	if (length < 0 || length > output->length ||
+			(index + length) > msblk->bytes_used) {
+		res = -EIO;
+		goto out;
+	}
+
 	if (next_index)
 		*next_index = index + length;
 


