Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 994EC65D942
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:22:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239663AbjADQWz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:22:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235348AbjADQWi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:22:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A59E91C107
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:22:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5904BB81733
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:22:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B16D7C433EF;
        Wed,  4 Jan 2023 16:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672849355;
        bh=eQUw//YQ2mPxPP/kOf1ekHVOmhMfEWJqpHePVMxDQ3g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pmcIHS6Jd0gCTCVLQIjEjteERv/nicePYmdUSF2JeGDWf3TScEvCJ1HmzYX6ANKsQ
         QfJVcrdkGoPeEzoep9/nbUMImtF1rpQXCTOkih1Wp4gNvFOkYT70i0fG9yhJMT/xGH
         U+UM45IPFH5ERDiETpN676hEUpG/4ZEdN0LdDwh4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+ba9dac45bc76c490b7c3@syzkaller.appspotmail.com,
        Eric Biggers <ebiggers@google.com>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 6.1 175/207] ext4: dont allow journal inode to have encrypt flag
Date:   Wed,  4 Jan 2023 17:07:13 +0100
Message-Id: <20230104160517.415207063@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
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
@@ -5724,7 +5724,7 @@ static struct inode *ext4_get_journal_in
 
 	ext4_debug("Journal inode found at %p: %lld bytes\n",
 		  journal_inode, journal_inode->i_size);
-	if (!S_ISREG(journal_inode->i_mode)) {
+	if (!S_ISREG(journal_inode->i_mode) || IS_ENCRYPTED(journal_inode)) {
 		ext4_msg(sb, KERN_ERR, "invalid journal inode");
 		iput(journal_inode);
 		return NULL;


