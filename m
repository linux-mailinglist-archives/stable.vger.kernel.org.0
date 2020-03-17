Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84F60188189
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:20:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727303AbgCQLEZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:04:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:44546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727714AbgCQLEY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:04:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71E3020658;
        Tue, 17 Mar 2020 11:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584443063;
        bh=at0jPWMYvZMjVNANj71VSVcc2aFfmEKTKV1uvGdwPB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZbmiQsj5FbxG+m641OXdtS57U1Grj8YdhpCDP3e2+ST1xh4l0Yc0EqcA2THs6f36O
         RfHuYVjHTZ8uYzZ3jUkyHoHsNeNCKyWeUvCF/uKXOY9jStaVj+kWL7B6fkK7q4AKLY
         SCipqHE0pPCSoFFxL2annVdbTSf2oxLsaY3vaR+E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>
Subject: [PATCH 5.4 084/123] fscrypt: dont evict dirty inodes after removing key
Date:   Tue, 17 Mar 2020 11:55:11 +0100
Message-Id: <20200317103316.431595905@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103307.343627747@linuxfoundation.org>
References: <20200317103307.343627747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit 2b4eae95c7361e0a147b838715c8baa1380a428f upstream.

After FS_IOC_REMOVE_ENCRYPTION_KEY removes a key, it syncs the
filesystem and tries to get and put all inodes that were unlocked by the
key so that unused inodes get evicted via fscrypt_drop_inode().
Normally, the inodes are all clean due to the sync.

However, after the filesystem is sync'ed, userspace can modify and close
one of the files.  (Userspace is *supposed* to close the files before
removing the key.  But it doesn't always happen, and the kernel can't
assume it.)  This causes the inode to be dirtied and have i_count == 0.
Then, fscrypt_drop_inode() failed to consider this case and indicated
that the inode can be dropped, causing the write to be lost.

On f2fs, other problems such as a filesystem freeze could occur due to
the inode being freed while still on f2fs's dirty inode list.

Fix this bug by making fscrypt_drop_inode() only drop clean inodes.

I've written an xfstest which detects this bug on ext4, f2fs, and ubifs.

Fixes: b1c0ec3599f4 ("fscrypt: add FS_IOC_REMOVE_ENCRYPTION_KEY ioctl")
Cc: <stable@vger.kernel.org> # v5.4+
Link: https://lore.kernel.org/r/20200305084138.653498-1-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/crypto/keysetup.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -579,6 +579,15 @@ int fscrypt_drop_inode(struct inode *ino
 	mk = ci->ci_master_key->payload.data[0];
 
 	/*
+	 * With proper, non-racy use of FS_IOC_REMOVE_ENCRYPTION_KEY, all inodes
+	 * protected by the key were cleaned by sync_filesystem().  But if
+	 * userspace is still using the files, inodes can be dirtied between
+	 * then and now.  We mustn't lose any writes, so skip dirty inodes here.
+	 */
+	if (inode->i_state & I_DIRTY_ALL)
+		return 0;
+
+	/*
 	 * Note: since we aren't holding ->mk_secret_sem, the result here can
 	 * immediately become outdated.  But there's no correctness problem with
 	 * unnecessarily evicting.  Nor is there a correctness problem with not


