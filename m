Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7F4D1C4471
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 20:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732143AbgEDSH0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 14:07:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:38216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732140AbgEDSHZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 14:07:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 091042075A;
        Mon,  4 May 2020 18:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588615644;
        bh=5dCP/Gb0YTMsyzKSqzDCdkXmTEkcfDYj7iiRizgRm3E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RSl6NsSB0XgtOog3jxzkCEzT/8xq5OWOkWjgTIijzHBmN7V9vxBAxvH5+/vk+rOXD
         5TYpsK7gbu9+nCKXZhcdsHRaDgbkAyrLx3caRo/AQT7vmduq1quzryvGf1pf0AhS6J
         ZQpSOCteLudBbGAipSNPwAISSBobsR2EIbISe/xw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Ian Kent <raven@themaw.net>, Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.6 65/73] Fix use after free in get_tree_bdev()
Date:   Mon,  4 May 2020 19:58:08 +0200
Message-Id: <20200504165510.120029947@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504165501.781878940@linuxfoundation.org>
References: <20200504165501.781878940@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

commit dd7bc8158b413e0b580c491e8bd18cb91057c7c2 upstream.

Commit 6fcf0c72e4b9, a fix to get_tree_bdev() put a missing blkdev_put() in
the wrong place, before a warnf() that displays the bdev under
consideration rather after it.

This results in a silent lockup in printk("%pg") called via warnf() from
get_tree_bdev() under some circumstances when there's a race with the
blockdev being frozen.  This can be caused by xfstests/tests/generic/085 in
combination with Lukas Czerner's ext4 mount API conversion patchset.  It
looks like it ought to occur with other users of get_tree_bdev() such as
XFS, but apparently doesn't.

Fix this by switching the order of the lines.

Fixes: 6fcf0c72e4b9 ("vfs: add missing blkdev_put() in get_tree_bdev()")
Reported-by: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Ian Kent <raven@themaw.net>
cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/super.c
+++ b/fs/super.c
@@ -1302,8 +1302,8 @@ int get_tree_bdev(struct fs_context *fc,
 	mutex_lock(&bdev->bd_fsfreeze_mutex);
 	if (bdev->bd_fsfreeze_count > 0) {
 		mutex_unlock(&bdev->bd_fsfreeze_mutex);
-		blkdev_put(bdev, mode);
 		warnf(fc, "%pg: Can't mount, blockdev is frozen", bdev);
+		blkdev_put(bdev, mode);
 		return -EBUSY;
 	}
 


