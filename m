Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF3626467F6
	for <lists+stable@lfdr.de>; Thu,  8 Dec 2022 04:41:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbiLHDlk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Dec 2022 22:41:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiLHDlj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Dec 2022 22:41:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 378A660368;
        Wed,  7 Dec 2022 19:41:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BEFDF61D44;
        Thu,  8 Dec 2022 03:41:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 062FFC433C1;
        Thu,  8 Dec 2022 03:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670470898;
        bh=YewYNnh9u1aXQK0Zj4ln0KDnFOQrT59yr7QW1U+yiIg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rAd617MyoQ3afOczctlyqOHP3UX0+V8Y7SK4xC+aKWYZtnBxurBglV2wXYLaMn5Eg
         l/83QDyj7YnRXl6+gXMZYCEUhW316TFFJLgF5BcDAosT9Z+nFAu6bEufl857d3zfza
         yv8MPAWsjrcr2IWlQbhCqky2DYZ7rLCulSgfJoI/W9XE5A9h+mLN6qDOVL+DEAhRzm
         gAaktHkH0kYJORt08rCScPIWW3hYcMLWaxrUR7sh2T/XFBA9QhTy3GEBh0sD1A1Zwn
         IJ8EUoeRBK9bKjvJnKS148eQpXqR6d8ErvH39cb5NqlZr1YjeiAFDE8fJBsz5F0HQe
         MxDtGvaORzDYQ==
Date:   Wed, 7 Dec 2022 19:41:36 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     linux-ext4@vger.kernel.org,
        syzbot+ba9dac45bc76c490b7c3@syzkaller.appspotmail.com,
        linux-fscrypt@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] ext4: don't allow journal inode to have encrypt flag
Message-ID: <Y5Fc8KCMfJ7Yka/x@sol.localdomain>
References: <20221102053312.189962-1-ebiggers@kernel.org>
 <167036049593.156498.14603526492088665546.b4-ty@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167036049593.156498.14603526492088665546.b4-ty@mit.edu>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 06, 2022 at 04:01:48PM -0500, Theodore Ts'o wrote:
> On Tue, 1 Nov 2022 22:33:12 -0700, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > Mounting a filesystem whose journal inode has the encrypt flag causes a
> > NULL dereference in fscrypt_limit_io_blocks() when the 'inlinecrypt'
> > mount option is used.
> > 
> > The problem is that when jbd2_journal_init_inode() calls bmap(), it
> > eventually finds its way into ext4_iomap_begin(), which calls
> > fscrypt_limit_io_blocks().  fscrypt_limit_io_blocks() requires that if
> > the inode is encrypted, then its encryption key must already be set up.
> > That's not the case here, since the journal inode is never "opened" like
> > a normal file would be.  Hence the crash.
> > 
> > [...]
> 
> Applied, thanks!
> 
> [1/1] ext4: don't allow journal inode to have encrypt flag
>       commit: 29cef51d8522c4d8953856afaffcaf1b754e4f6c
> 
> Best regards,
> -- 
> Theodore Ts'o <tytso@mit.edu>

Thanks Ted.  Note that I also sent an e2fsprogs patch to make e2fsck fix this
situation: https://lore.kernel.org/r/20221102220551.3940-1-ebiggers@kernel.org

- Eric
