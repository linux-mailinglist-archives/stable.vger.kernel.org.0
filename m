Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 159A215C658
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 17:12:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728768AbgBMP7o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:59:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:39308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728819AbgBMPYv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:24:51 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2BC224691;
        Thu, 13 Feb 2020 15:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607491;
        bh=RkXA+Oa/Ce3M/Ly4dN8mT21eHp05nHhe1AHpFs07pgY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gyXwNufFNHrFEnTLJrs1UwCoefOx4Fo/4dUxUkgA0lRa5XP3EnMmZFExM4juN47qF
         /cof1WBGLVxoJvavAXbf58VeIB8L/ubmxSKWvOA0ZUCx5ZgaR5vohLLl4hUxs4d+Bz
         jAPUhrNhwFZMib7QP/5jZkF6Uyn9fKs2D3Q3FBSs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 4.14 040/173] ubifs: Fix FS_IOC_SETFLAGS unexpectedly clearing encrypt flag
Date:   Thu, 13 Feb 2020 07:19:03 -0800
Message-Id: <20200213151944.026374406@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151931.677980430@linuxfoundation.org>
References: <20200213151931.677980430@linuxfoundation.org>
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
@@ -129,7 +129,8 @@ static int setflags(struct inode *inode,
 		}
 	}
 
-	ui->flags = ioctl2ubifs(flags);
+	ui->flags &= ~ioctl2ubifs(UBIFS_SUPPORTED_IOCTL_FLAGS);
+	ui->flags |= ioctl2ubifs(flags);
 	ubifs_set_inode_flags(inode);
 	inode->i_ctime = current_time(inode);
 	release = ui->dirty;


