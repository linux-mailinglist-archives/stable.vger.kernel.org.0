Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD64138A9B6
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239106AbhETLFg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:05:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:38332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239530AbhETLDd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 07:03:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4DD4261D13;
        Thu, 20 May 2021 10:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621505066;
        bh=qgA/fXD4F6Koj9VdCi58OxcitLjK1laDKud+WmMKar8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OxKHxef/PFXDPWzHc/Cfqyti2fSvZQ+oCqRe2rE6sZgqACC9FbNoitMgUv+fIVreP
         QbyzSFOrziPzRr9yU0gyiLld7fCV8oBcq7c4VbHh4UU/DTjkl1W2p1hGJ9XIbUJ+vI
         opwTmqJoK4P5SWKZDao0fbqDpjQy2g5n5zQzq3Og=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Phillip Lougher <phillip@squashfs.org.uk>,
        syzbot+e8f781243ce16ac2f962@syzkaller.appspotmail.com,
        syzbot+7b98870d4fec9447b951@syzkaller.appspotmail.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.9 207/240] squashfs: fix divide error in calculate_skip()
Date:   Thu, 20 May 2021 11:23:19 +0200
Message-Id: <20210520092115.608903588@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092108.587553970@linuxfoundation.org>
References: <20210520092108.587553970@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Phillip Lougher <phillip@squashfs.org.uk>

commit d6e621de1fceb3b098ebf435ef7ea91ec4838a1a upstream.

Sysbot has reported a "divide error" which has been identified as being
caused by a corrupted file_size value within the file inode.  This value
has been corrupted to a much larger value than expected.

Calculate_skip() is passed i_size_read(inode) >> msblk->block_log.  Due to
the file_size value corruption this overflows the int argument/variable in
that function, leading to the divide error.

This patch changes the function to use u64.  This will accommodate any
unexpectedly large values due to corruption.

The value returned from calculate_skip() is clamped to be never more than
SQUASHFS_CACHED_BLKS - 1, or 7.  So file_size corruption does not lead to
an unexpectedly large return result here.

Link: https://lkml.kernel.org/r/20210507152618.9447-1-phillip@squashfs.org.uk
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Reported-by: <syzbot+e8f781243ce16ac2f962@syzkaller.appspotmail.com>
Reported-by: <syzbot+7b98870d4fec9447b951@syzkaller.appspotmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/squashfs/file.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/squashfs/file.c
+++ b/fs/squashfs/file.c
@@ -224,11 +224,11 @@ failure:
  * If the skip factor is limited in this way then the file will use multiple
  * slots.
  */
-static inline int calculate_skip(int blocks)
+static inline int calculate_skip(u64 blocks)
 {
-	int skip = blocks / ((SQUASHFS_META_ENTRIES + 1)
+	u64 skip = blocks / ((SQUASHFS_META_ENTRIES + 1)
 		 * SQUASHFS_META_INDEXES);
-	return min(SQUASHFS_CACHED_BLKS - 1, skip + 1);
+	return min((u64) SQUASHFS_CACHED_BLKS - 1, skip + 1);
 }
 
 


