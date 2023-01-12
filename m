Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD997667826
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:53:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240162AbjALOx1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:53:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240145AbjALOww (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:52:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4825551D8
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:39:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 503D262036
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:39:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56C90C43392;
        Thu, 12 Jan 2023 14:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673534370;
        bh=x9H5O/BEqVZDe985QUI9gaFgZthS1dnBhFIuyCrBYrQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KTAxo7moo2IYXuMes5OMkKrbq0vrQo4dDafFTvt5TIX+OGXWtwjg3FI6UcBocd07I
         KH4N+ZIhIOAvpRsUAMr4rfSqAqYUwDxn2LWbNFT7RVRdPN9s6F3Bsoi6c63AzMUwPs
         2d4BVMvCnNxNGvdSXiGki4duO/TgrTGiG/hRqtNM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+ba9dac45bc76c490b7c3@syzkaller.appspotmail.com,
        Eric Biggers <ebiggers@google.com>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 5.10 766/783] ext4: dont allow journal inode to have encrypt flag
Date:   Thu, 12 Jan 2023 14:58:02 +0100
Message-Id: <20230112135559.882269572@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit 105c78e12468413e426625831faa7db4284e1fec upstream.

Mounting a filesystem whose journal inode has the encrypt flag causes a
NULL dereference in fscrypt_limit_io_blocks() when the 'inlinecrypt'
mount option is used.

The problem is that when jbd2_journal_init_inode() calls bmap(), it
eventually finds its way into ext4_iomap_begin(), which calls
fscrypt_limit_io_blocks().  fscrypt_limit_io_blocks() requires that if
the inode is encrypted, then its encryption key must already be set up.
That's not the case here, since the journal inode is never "opened" like
a normal file would be.  Hence the crash.

A reproducer is:

    mkfs.ext4 -F /dev/vdb
    debugfs -w /dev/vdb -R "set_inode_field <8> flags 0x80808"
    mount /dev/vdb /mnt -o inlinecrypt

To fix this, make ext4 consider journal inodes with the encrypt flag to
be invalid.  (Note, maybe other flags should be rejected on the journal
inode too.  For now, this is just the minimal fix for the above issue.)

I've marked this as fixing the commit that introduced the call to
fscrypt_limit_io_blocks(), since that's what made an actual crash start
being possible.  But this fix could be applied to any version of ext4
that supports the encrypt feature.

Reported-by: syzbot+ba9dac45bc76c490b7c3@syzkaller.appspotmail.com
Fixes: 38ea50daa7a4 ("ext4: support direct I/O with fscrypt using blk-crypto")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
Link: https://lore.kernel.org/r/20221102053312.189962-1-ebiggers@kernel.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5262,7 +5262,7 @@ static struct inode *ext4_get_journal_in
 
 	jbd_debug(2, "Journal inode found at %p: %lld bytes\n",
 		  journal_inode, journal_inode->i_size);
-	if (!S_ISREG(journal_inode->i_mode)) {
+	if (!S_ISREG(journal_inode->i_mode) || IS_ENCRYPTED(journal_inode)) {
 		ext4_msg(sb, KERN_ERR, "invalid journal inode");
 		iput(journal_inode);
 		return NULL;


