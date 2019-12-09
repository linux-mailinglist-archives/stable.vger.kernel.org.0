Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8908B11793F
	for <lists+stable@lfdr.de>; Mon,  9 Dec 2019 23:27:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbfLIWYV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Dec 2019 17:24:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:40908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726913AbfLIWYU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Dec 2019 17:24:20 -0500
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC3AF20721;
        Mon,  9 Dec 2019 22:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575930260;
        bh=J8Nz3aIsqb9BFur9UNzQ73PoePbe7oFoO4UFcU1gi4Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IyOLd8j4Bio2cZmfbFWTozGwBtN67GJNpGYItPOZ+yHp+bdhJr/9mESep/Luw53p7
         5JlfmHIUCsPs5GJi/BcUcYknBCcmMOxTXRcuhSPavmu3Lcg5G94T2CxOwEVc7qyIqU
         IFgHA85XKvinMqatq+oeU2kgDG+97kDpl5vdwtD4=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-mtd@lists.infradead.org, Richard Weinberger <richard@nod.at>
Cc:     linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 1/2] ubifs: fix FS_IOC_SETFLAGS unexpectedly clearing encrypt flag
Date:   Mon,  9 Dec 2019 14:23:24 -0800
Message-Id: <20191209222325.95656-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.0.393.g34dc348eaf-goog
In-Reply-To: <20191209222325.95656-1-ebiggers@kernel.org>
References: <20191209222325.95656-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

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
---
 fs/ubifs/ioctl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ubifs/ioctl.c b/fs/ubifs/ioctl.c
index 5dc5abca11c70..eeb1be2598881 100644
--- a/fs/ubifs/ioctl.c
+++ b/fs/ubifs/ioctl.c
@@ -113,7 +113,8 @@ static int setflags(struct inode *inode, int flags)
 	if (err)
 		goto out_unlock;
 
-	ui->flags = ioctl2ubifs(flags);
+	ui->flags &= ~ioctl2ubifs(UBIFS_SUPPORTED_IOCTL_FLAGS);
+	ui->flags |= ioctl2ubifs(flags);
 	ubifs_set_inode_flags(inode);
 	inode->i_ctime = current_time(inode);
 	release = ui->dirty;
-- 
2.24.0.393.g34dc348eaf-goog

