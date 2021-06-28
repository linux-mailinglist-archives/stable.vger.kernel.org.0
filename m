Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FDBE3B6AD6
	for <lists+stable@lfdr.de>; Tue, 29 Jun 2021 00:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232745AbhF1WMU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 18:12:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:53860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231864AbhF1WMT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 18:12:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BBE0161CA1;
        Mon, 28 Jun 2021 22:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624918192;
        bh=sqh7heyY6fnl5INzEdwF0Ae+AigtE8pVWuCd6K7XiJw=;
        h=Date:From:To:Subject:From;
        b=fAGeOI7Xz3vtYYhVMFex8kGkDR6W7fDPbK5RQLTYYeaxkrPKuvW/wj/L75ZYKd75r
         IdOi2loHh2aOE18T4Ucd+SQO495bODok6YApdoZJ+CTLRRjq8bgWy26/S2JV4iUSWV
         OHqftuFA3hSRu3w1e05T3dY52OOT+YXi4AsZgRMc=
Date:   Mon, 28 Jun 2021 15:09:51 -0700
From:   akpm@linux-foundation.org
To:     anton@tuxera.com, desmondcheongzx@gmail.com,
        gregkh@linuxfoundation.org, mm-commits@vger.kernel.org,
        skhan@linuxfoundation.org, stable@vger.kernel.org
Subject:  + ntfs-fix-validity-check-for-file-name-attribute.patch
 added to -mm tree
Message-ID: <20210628220951.BybJ7-QZl%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: ntfs: fix validity check for file name attribute
has been added to the -mm tree.  Its filename is
     ntfs-fix-validity-check-for-file-name-attribute.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ntfs-fix-validity-check-for-file-name-attribute.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ntfs-fix-validity-check-for-file-name-attribute.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
Subject: ntfs: fix validity check for file name attribute

When checking the file name attribute, we want to ensure that it fits
within the bounds of ATTR_RECORD.  To do this, we should check that (attr
record + file name offset + file name length) < (attr record + attr record
length).

However, the original check did not include the file name offset in the
calculation.  This means that corrupted on-disk metadata might not caught
by the incorrect file name check, and lead to an invalid memory access.

An example can be seen in the crash report of a memory corruption error
found by Syzbot:
https://syzkaller.appspot.com/bug?id=a1a1e379b225812688566745c3e2f7242bffc246

Adding the file name offset to the validity check fixes this error and
passes the Syzbot reproducer test.

Link: https://lkml.kernel.org/r/20210614050540.289494-1-desmondcheongzx@gmail.com
Signed-off-by: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
Reported-by: syzbot+213ac8bb98f7f4420840@syzkaller.appspotmail.com
Tested-by: syzbot+213ac8bb98f7f4420840@syzkaller.appspotmail.com
Acked-by: Anton Altaparmakov <anton@tuxera.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ntfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ntfs/inode.c~ntfs-fix-validity-check-for-file-name-attribute
+++ a/fs/ntfs/inode.c
@@ -477,7 +477,7 @@ err_corrupt_attr:
 		}
 		file_name_attr = (FILE_NAME_ATTR*)((u8*)attr +
 				le16_to_cpu(attr->data.resident.value_offset));
-		p2 = (u8*)attr + le32_to_cpu(attr->data.resident.value_length);
+		p2 = (u8 *)file_name_attr + le32_to_cpu(attr->data.resident.value_length);
 		if (p2 < (u8*)attr || p2 > p)
 			goto err_corrupt_attr;
 		/* This attribute is ok, but is it in the $Extend directory? */
_

Patches currently in -mm which might be from desmondcheongzx@gmail.com are

ntfs-fix-validity-check-for-file-name-attribute.patch

