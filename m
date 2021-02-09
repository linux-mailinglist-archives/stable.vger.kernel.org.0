Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1573D315A15
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 00:35:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234268AbhBIXcX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Feb 2021 18:32:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:55568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234039AbhBIWR2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Feb 2021 17:17:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6DD364EC4;
        Tue,  9 Feb 2021 21:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612906911;
        bh=LYrdgh9B9MJd+gEQVz2818OkEWazwLzDnyWKnJ/SkJc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=NwBdFMqBo8f9en5/27ItLhAfFUmTW+kU2EPj6iLdVtMsfVl54rIDY69etgrwysTD8
         RiFxT3pUeFIofS0/rpGy5WEs84NutBOHO+FPDwfgKs7wTEQYfihUWr854hp45Bytk8
         kYzW1jd2geGqLD3+TXtCp6+mWBhSshlrvDaFStEI=
Date:   Tue, 09 Feb 2021 13:41:50 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, phillip@squashfs.org.uk,
        pliard@google.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 01/14] squashfs: avoid out of bounds writes in
 decompressors
Message-ID: <20210209214150._Vu1-fOx4%akpm@linux-foundation.org>
In-Reply-To: <20210209134115.4d933d446165cd0ed8977b03@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Phillip Lougher <phillip@squashfs.org.uk>
Subject: squashfs: avoid out of bounds writes in decompressors

Patch series "Squashfs: fix BIO migration regression and add sanity checks".

Patch [1/4] fixes a regression introduced by the "migrate from ll_rw_block
usage to BIO" patch, which has produced a number of Sysbot/Syzkaller
reports.

Patches [2/4], [3/4], and [4/4] fix a number of filesystem corruption
issues which have produced Sysbot reports in the id, inode and xattr
lookup code.

Each patch has been tested against the Sysbot reproducers using the given
kernel configuration.  They have the appropriate "Reported-by:" lines
added.

Additionally, all of the reproducer filesystems are indirectly fixed by
patch [4/4] due to the fact they all have xattr corruption which is now
detected there.

Additional testing with other configurations and architectures (32bit, big
endian), and normal filesystems has also been done to trap any inadvertent
regressions caused by the additional sanity checks.


This patch (of 4):

This is a regression introduced by the patch "migrate from ll_rw_block
usage to BIO".

Sysbot/Syskaller has reported a number of "out of bounds writes" and
"unable to handle kernel paging request in squashfs_decompress" errors
which have been identified as a regression introduced by the above patch.

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
---

 fs/squashfs/block.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/squashfs/block.c~squashfs-avoid-out-of-bounds-writes-in-decompressors
+++ a/fs/squashfs/block.c
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
 
_
