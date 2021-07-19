Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 898153CD780
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 16:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241488AbhGSORC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:17:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:50136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241620AbhGSOQ4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:16:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D960161003;
        Mon, 19 Jul 2021 14:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626706655;
        bh=XKIdcRFmU5GuMtfXcljpIi+SkH8MyrVAUkuEs5VReRU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0UnhbHQHZXICFLpG06IkYDZdQEOL422GGbr+GKsaKDkrRO+e5BC0GKY0NevYFeltQ
         4NJnYfbDQs9BwSQvIpFdS14SPpa6+Kt7StY+f2dq738V4x9A/c/JbuQTnc7lK8T5T4
         peGH2vBVNMM+YbfT1slRrY4rqVfu9Whtvk0WY8zw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>,
        syzbot+213ac8bb98f7f4420840@syzkaller.appspotmail.com,
        Anton Altaparmakov <anton@tuxera.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.4 007/188] ntfs: fix validity check for file name attribute
Date:   Mon, 19 Jul 2021 16:49:51 +0200
Message-Id: <20210719144914.783468210@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144913.076563739@linuxfoundation.org>
References: <20210719144913.076563739@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>

commit d98e4d95411bbde2220a7afa38dcc9c14d71acbe upstream.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ntfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ntfs/inode.c
+++ b/fs/ntfs/inode.c
@@ -502,7 +502,7 @@ err_corrupt_attr:
 		}
 		file_name_attr = (FILE_NAME_ATTR*)((u8*)attr +
 				le16_to_cpu(attr->data.resident.value_offset));
-		p2 = (u8*)attr + le32_to_cpu(attr->data.resident.value_length);
+		p2 = (u8 *)file_name_attr + le32_to_cpu(attr->data.resident.value_length);
 		if (p2 < (u8*)attr || p2 > p)
 			goto err_corrupt_attr;
 		/* This attribute is ok, but is it in the $Extend directory? */


