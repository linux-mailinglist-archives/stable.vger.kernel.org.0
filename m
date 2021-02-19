Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E073A31FEFC
	for <lists+stable@lfdr.de>; Fri, 19 Feb 2021 19:53:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbhBSSwI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Feb 2021 13:52:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:50190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229587AbhBSSwC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Feb 2021 13:52:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A74CB64E77;
        Fri, 19 Feb 2021 18:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1613760680;
        bh=SJDKPvSrMgz7cKB0cB2tSNrH15r9ERGRy52b3KOiO0c=;
        h=Date:From:To:Subject:From;
        b=FtHt+hNVXzom9Tdc4Db79ZOj8aAvSEh30PbeC9G/9o64eH/chRecgQOeAT3/OxXrg
         QJHWSe1F03Q7RK/r9UuLIgvvvotwUAl66OE6D/rbVsS5ZMyURxTj7sZKiT80pi1sRh
         0VCEbpodsg3AEQqdC3wbx+DsnjymoObI0l0fsAOk=
Date:   Fri, 19 Feb 2021 10:51:20 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        anton@tuxera.com, rkovhaev@gmail.com
Subject:  + ntfs-check-for-valid-standard-information-attribute.patch
 added to -mm tree
Message-ID: <20210219185120.-Bufi%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: ntfs: check for valid standard information attribute
has been added to the -mm tree.  Its filename is
     ntfs-check-for-valid-standard-information-attribute.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ntfs-check-for-valid-standard-information-attribute.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ntfs-check-for-valid-standard-information-attribute.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

ntfs-check-for-valid-standard-information-attribute.patch

