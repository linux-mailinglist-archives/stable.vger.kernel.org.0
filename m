Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 698E263B691
	for <lists+stable@lfdr.de>; Tue, 29 Nov 2022 01:24:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234889AbiK2AX5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 19:23:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234890AbiK2AXw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 19:23:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57A3B3FB88;
        Mon, 28 Nov 2022 16:23:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E68A961510;
        Tue, 29 Nov 2022 00:23:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42345C433D6;
        Tue, 29 Nov 2022 00:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669681418;
        bh=WT6nVeES1yqoAXl+M03ESuOIpXyux92DU+gbpELzevM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HwZQCxO3vgMpJIGGdJOMiDwoxisiOEbpKX+O3rHu84PomXNbDMTho94bC5BUieY97
         vRVQQkSunS1XUbs/BX6U3LQbrmeo3FAQEPPBlHd+SeBZG/rYF3IuEyqUmSjFnc+vmz
         HM3/gDi2JSJQZObAyQx74Xs5ltXMKhAEuwioF+YmF2raffNKQg5n7Pw8cxjhQPEOPy
         gxMxetgPKv0qqwiVGe1yZq2eqigkNcZQJl4hV0cvydVBncobtOGSl40xLgSerOBgU3
         0uG1s9rRPPcO4t1fug1LUeD1Xg0wKSmfzad6ePOnLF0aGwyjeR+99UK2nTD0z5E0Sq
         YGqqIUluzyioA==
Date:   Tue, 29 Nov 2022 00:23:36 +0000
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-ext4@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, stable@vger.kernel.org,
        syzbot+ba9dac45bc76c490b7c3@syzkaller.appspotmail.com
Subject: Re: [PATCH] ext4: don't allow journal inode to have encrypt flag
Message-ID: <Y4VRCIk4JQyH+utN@gmail.com>
References: <20221102053312.189962-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102053312.189962-1-ebiggers@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 01, 2022 at 10:33:12PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Mounting a filesystem whose journal inode has the encrypt flag causes a
> NULL dereference in fscrypt_limit_io_blocks() when the 'inlinecrypt'
> mount option is used.
> 
> The problem is that when jbd2_journal_init_inode() calls bmap(), it
> eventually finds its way into ext4_iomap_begin(), which calls
> fscrypt_limit_io_blocks().  fscrypt_limit_io_blocks() requires that if
> the inode is encrypted, then its encryption key must already be set up.
> That's not the case here, since the journal inode is never "opened" like
> a normal file would be.  Hence the crash.
> 
> A reproducer is:
> 
>     mkfs.ext4 -F /dev/vdb
>     debugfs -w /dev/vdb -R "set_inode_field <8> flags 0x80808"
>     mount /dev/vdb /mnt -o inlinecrypt
> 
> To fix this, make ext4 consider journal inodes with the encrypt flag to
> be invalid.  (Note, maybe other flags should be rejected on the journal
> inode too.  For now, this is just the minimal fix for the above issue.)
> 
> I've marked this as fixing the commit that introduced the call to
> fscrypt_limit_io_blocks(), since that's what made an actual crash start
> being possible.  But this fix could be applied to any version of ext4
> that supports the encrypt feature.
> 
> Reported-by: syzbot+ba9dac45bc76c490b7c3@syzkaller.appspotmail.com
> Fixes: 38ea50daa7a4 ("ext4: support direct I/O with fscrypt using blk-crypto")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  fs/ext4/super.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 7950904fbf04f..2274f730b87e5 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -5723,7 +5723,7 @@ static struct inode *ext4_get_journal_inode(struct super_block *sb,
>  
>  	ext4_debug("Journal inode found at %p: %lld bytes\n",
>  		  journal_inode, journal_inode->i_size);
> -	if (!S_ISREG(journal_inode->i_mode)) {
> +	if (!S_ISREG(journal_inode->i_mode) || IS_ENCRYPTED(journal_inode)) {
>  		ext4_msg(sb, KERN_ERR, "invalid journal inode");
>  		iput(journal_inode);
>  		return NULL;
> 
> base-commit: 8f71a2b3f435f29b787537d1abedaa7d8ebe6647
> -- 

Ping.

- Eric
