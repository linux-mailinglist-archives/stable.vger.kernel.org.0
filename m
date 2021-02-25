Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9598D325687
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 20:17:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234499AbhBYTRA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 14:17:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:57184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233960AbhBYTOy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Feb 2021 14:14:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A314564F29;
        Thu, 25 Feb 2021 19:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280287;
        bh=1gB9LNMVWAZ1Ak/QOPUuxy1c0xwolMhRlVZMIcvOQ2Y=;
        h=Date:From:To:Subject:From;
        b=ConZIPNaj4872NNJxnvAFY8JOby85Lm6QU4s6pjIOCNXvh0ncOmWeadX9FqjVkLpr
         /Hyxqkei2R/b4//LxSNe0vClsPETHYHFuK3mGDePZcSD0jSC4nwjfuDpiQgLaiTIyw
         MdHCHIQY2vXPisX1dWD8bGfJoYmD1ex3k16ItRho=
Date:   Thu, 25 Feb 2021 11:11:27 -0800
From:   akpm@linux-foundation.org
To:     anton@tuxera.com, mm-commits@vger.kernel.org, rkovhaev@gmail.com,
        stable@vger.kernel.org
Subject:  [merged]
 ntfs-check-for-valid-standard-information-attribute.patch removed from -mm
 tree
Message-ID: <20210225191127.GNU2Eisy0%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: ntfs: check for valid standard information attribute
has been removed from the -mm tree.  Its filename was
     ntfs-check-for-valid-standard-information-attribute.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rustam Kovhaev <rkovhaev@gmail.com>
Subject: ntfs: check for valid standard information attribute

Mounting a corrupted filesystem with NTFS resulted in a kernel crash.

We should check for valid STANDARD_INFORMATION attribute offset and length
before trying to access it

Link: https://lkml.kernel.org/r/20210217155930.1506815-1-rkovhaev@gmail.com
Link: https://syzkaller.appspot.com/bug?extid=c584225dabdea2f71969
Signed-off-by: Rustam Kovhaev <rkovhaev@gmail.com>
Reported-by: syzbot+c584225dabdea2f71969@syzkaller.appspotmail.com
Tested-by: syzbot+c584225dabdea2f71969@syzkaller.appspotmail.com
Acked-by: Anton Altaparmakov <anton@tuxera.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ntfs/inode.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/ntfs/inode.c~ntfs-check-for-valid-standard-information-attribute
+++ a/fs/ntfs/inode.c
@@ -629,6 +629,12 @@ static int ntfs_read_locked_inode(struct
 	}
 	a = ctx->attr;
 	/* Get the standard information attribute value. */
+	if ((u8 *)a + le16_to_cpu(a->data.resident.value_offset)
+			+ le32_to_cpu(a->data.resident.value_length) >
+			(u8 *)ctx->mrec + vol->mft_record_size) {
+		ntfs_error(vi->i_sb, "Corrupt standard information attribute in inode.");
+		goto unm_err_out;
+	}
 	si = (STANDARD_INFORMATION*)((u8*)a +
 			le16_to_cpu(a->data.resident.value_offset));
 
_

Patches currently in -mm which might be from rkovhaev@gmail.com are


