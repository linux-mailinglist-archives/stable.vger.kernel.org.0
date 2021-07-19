Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01B653CD8FB
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243177AbhGSO0R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:26:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:57198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244095AbhGSOYs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:24:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 150F9611CE;
        Mon, 19 Jul 2021 15:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707104;
        bh=XKIdcRFmU5GuMtfXcljpIi+SkH8MyrVAUkuEs5VReRU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pI9xyqFJ9qHKaQetQDcUGo58b20Xza902F/4x6OKh5j4TFKNXv5+OC8xIh3pyRxP8
         KPQxeycSXRu8knw+q/rOUsZO8btp99tP9C4KTGc1OV3yAdgg1R7Kktp5Pi8FoiFrVP
         N7OGwdjBiLfMKRfHbY9m4hBe1j7PqQ8oNIm8CYE4=
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
Subject: [PATCH 4.9 007/245] ntfs: fix validity check for file name attribute
Date:   Mon, 19 Jul 2021 16:49:09 +0200
Message-Id: <20210719144940.623198277@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.288257948@linuxfoundation.org>
References: <20210719144940.288257948@linuxfoundation.org>
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


