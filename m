Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27AC53244D7
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 21:03:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234995AbhBXUCM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 15:02:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:55460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234917AbhBXUCI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 15:02:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B13FF64F08;
        Wed, 24 Feb 2021 20:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614196832;
        bh=lgDhecVyjLcC8CX2QsFWfn7GWsa4VUqLSi3Jc9aifws=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=HsgIJOJKi0RhtDiBvgO9IlUsy/qvs9dild4oSVsfCTPAAOkapyl1h/kh+1MMfNE+M
         EoC44MGoL6+qCb3P/PqQvMjB72z1oKdmARXOJiCZyWEmw27s0FrRxD7VRPFvmoE6G1
         LixUS8uPgKHGqBvR5nXfHploTd+IRFqiqf//Y5S8=
Date:   Wed, 24 Feb 2021 12:00:30 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, anton@tuxera.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rkovhaev@gmail.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 007/173] ntfs: check for valid standard
 information attribute
Message-ID: <20210224200030.F8x-RJnAx%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
