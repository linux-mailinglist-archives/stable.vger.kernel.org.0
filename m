Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D144157549
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:40:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727686AbgBJMkE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:40:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:38920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728813AbgBJMkD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:40:03 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70CE82085B;
        Mon, 10 Feb 2020 12:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338403;
        bh=BvFCv21X/M3zlOubwmJLJSz0U2M68Y+y6binuJ8WJEo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YP+rFEmGPFzoQNEPKv9fkj8cIXeywO9+A7HPkuv4YbovC3obHDDl3iJSBPlFwHCBG
         pdDRFaXlyLEWf4HqPdtw2gy65KQ0qGlQbi1LF7YxTm4XmXNg/SQj637E01hiJtyZhl
         qjJQBvKbutY2DRCC+hYFkNlbUkT3fMOqdwBUr7fI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 5.5 104/367] ubifs: Fix FS_IOC_SETFLAGS unexpectedly clearing encrypt flag
Date:   Mon, 10 Feb 2020 04:30:17 -0800
Message-Id: <20200210122433.984203459@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit 2b57067a7778484c10892fa191997bfda29fea13 upstream.

UBIFS's implementation of FS_IOC_SETFLAGS fails to preserve existing
inode flags that aren't settable by FS_IOC_SETFLAGS, namely the encrypt
flag.  This causes the encrypt flag to be unexpectedly cleared.

Fix it by preserving existing unsettable flags, like ext4 and f2fs do.

Test case with kvm-xfstests shell:

    FSTYP=ubifs KEYCTL_PROG=keyctl
    . fs/ubifs/config
    . ~/xfstests/common/encrypt
    dev=$(__blkdev_to_ubi_volume /dev/vdc)
    ubiupdatevol -t $dev
    mount $dev /mnt -t ubifs
    k=$(_generate_session_encryption_key)
    mkdir /mnt/edir
    xfs_io -c "set_encpolicy $k" /mnt/edir
    echo contents > /mnt/edir/file
    chattr +i /mnt/edir/file
    chattr -i /mnt/edir/file

With the bug, the following errors occur on the last command:

    [   18.081559] fscrypt (ubifs, inode 67): Inconsistent encryption context (parent directory: 65)
    chattr: Operation not permitted while reading flags on /mnt/edir/file

Fixes: d475a507457b ("ubifs: Add skeleton for fscrypto")
Cc: <stable@vger.kernel.org> # v4.10+
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ubifs/ioctl.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/ubifs/ioctl.c
+++ b/fs/ubifs/ioctl.c
@@ -113,7 +113,8 @@ static int setflags(struct inode *inode,
 	if (err)
 		goto out_unlock;
 
-	ui->flags = ioctl2ubifs(flags);
+	ui->flags &= ~ioctl2ubifs(UBIFS_SUPPORTED_IOCTL_FLAGS);
+	ui->flags |= ioctl2ubifs(flags);
 	ubifs_set_inode_flags(inode);
 	inode->i_ctime = current_time(inode);
 	release = ui->dirty;


