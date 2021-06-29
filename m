Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 819E13B6C86
	for <lists+stable@lfdr.de>; Tue, 29 Jun 2021 04:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231738AbhF2CgV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 22:36:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:57040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230152AbhF2CgU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 22:36:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 46F8261D00;
        Tue, 29 Jun 2021 02:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934033;
        bh=/jc/cT4TXj8SFP1tv5zQ3VRU2S5jc73p/HECogH16Yc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=VrZVckWfaIirnNxzbTt84bnMwtAlp6ayhI/+R+DL/Bkke3NIIt5GI4ZqnDoEX0hNo
         i4tketfFHMPWzgbVLgAf/cEk4SoxT+wkK6jWubM3Ubr8AR8VrMzCMHSRJXDn2pJny4
         urlREwC8u8EN7qrAe8wF76WKev75GhXfl8N915eE=
Date:   Mon, 28 Jun 2021 19:33:52 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, anton@tuxera.com,
        desmondcheongzx@gmail.com, gregkh@linuxfoundation.org,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        skhan@linuxfoundation.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 011/192] ntfs: fix validity check for file name
 attribute
Message-ID: <20210629023352.pV-MT_FHP%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
