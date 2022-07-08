Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9512456BF5F
	for <lists+stable@lfdr.de>; Fri,  8 Jul 2022 20:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239440AbiGHQwX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jul 2022 12:52:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239449AbiGHQwD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Jul 2022 12:52:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 008E97D1D5;
        Fri,  8 Jul 2022 09:51:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91B0B622F2;
        Fri,  8 Jul 2022 16:51:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE5DDC341C0;
        Fri,  8 Jul 2022 16:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657299117;
        bh=oEBsbWt653MM50R5gyF/Crs0SqciHj0RYS7DeN510FQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eVkpNXoJ45SjhMsCF8xkzrG5KFteITbT/q1Njw6Rjb3vzebzBG2OZ9g8D23HRnjx5
         BNHhoZYb1qZykL6+5AZFQ8HiT9yrF0PUFucSkQyQzRmuMv0KM3yMiu26X/Fig/KYRn
         SkuyJn2G7taHYVHMCXDh1IU/0mytOqzL8W1qAc0H0+tra8Jbf/2XcTCe3PO2NjmsDO
         CIw+L3sog3A6E6U9U5gOwPxxa8tZwTxDxq0ENnp95rmKW98MPMKXRqbuikGXMIxKpm
         jYf0gdwV30y1TTkQ5HNKqRUxcANWxkb2xo/3G71je16BS3++wbxIyXZKlrwUAlS3pA
         iKA7HzMqDEq5Q==
Date:   Fri, 8 Jul 2022 09:51:56 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     amir73il@gmail.com, ayudutta@amazon.com, kkexu@amazon.com,
        linux-xfs@vger.kernel.org, lrumancik@google.com,
        pbonzini@redhat.com, sandeen@redhat.com, stable@vger.kernel.org
Subject: Re: [PATCH stable 5.15] xfs: remove incorrect ASSERT in xfs_rename
Message-ID: <YshgrEyqzF+rbi0c@magnolia>
References: <YshTjclKanmcBsUW@magnolia>
 <20220708163632.65870-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220708163632.65870-1-kuniyu@amazon.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 08, 2022 at 09:36:32AM -0700, Kuniyuki Iwashima wrote:
> From:   "Darrick J. Wong" <djwong@kernel.org>
> Date:   Fri, 8 Jul 2022 08:55:57 -0700
> > On Fri, Jul 08, 2022 at 08:54:13AM -0700, Darrick J. Wong wrote:
> > > On Thu, Jul 07, 2022 at 03:58:35PM -0700, Kuniyuki Iwashima wrote:
> > > > From: Eric Sandeen <sandeen@redhat.com>
> > > > 
> > > > commit e445976537ad139162980bee015b7364e5b64fff upstream.
> > > > 
> > > > Ayushman Dutta reported our 5.10 kernel hit the warning.  It was because
> > > > the original commit misses a Fixes tag and was not backported to the stable
> > > > tree.  The fix is merged in 5.16, so please backport it to 5.15 first.
> > > > 
> > > > This ASSERT in xfs_rename is a) incorrect, because
> > > > (RENAME_WHITEOUT|RENAME_NOREPLACE) is a valid combination, and
> > > > b) unnecessary, because actual invalid flag combinations are already
> > > > handled at the vfs level in do_renameat2() before we get called.
> > > > So, remove it.
> > > > 
> > > > Reported-by: Paolo Bonzini <pbonzini@redhat.com>
> > > > Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> > > > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > Fixes: 7dcf5c3e4527 ("xfs: add RENAME_WHITEOUT support")
> > > > Reported-by: Ayushman Dutta <ayudutta@amazon.com>
> > > > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > > 
> > > Looks good to me, but you really ought to send 5.10 patches to the 5.10
> > > XFS maintainer (Amir, now cc'd).  (Yes, this is a recent change.) ;)
> > 
> > ...and of course the first thing that happens is that I mix up the 5.10
> > and 5.15 patches.
> > 
> > Amir is the 5.10 maintainer, Leah is the 5.15 maintainer.  Sorry about
> > the mixup.  /me pours himself a third(!) cup of coffee.
> 
> Thank you for taking a look!
> 
> And sorry that I'm not familiar with xfs workflow and didn't know each
> version has dedicated maintainers.

It's a recent change, because I wasn't keeping up with tending to six
LTS trees /and/ upstream /and/ feature development.

> Is there a doc like Documentation/process/maintainer-netdev.rst as both of
> Amir and Leah seem not listed in the xfs entry of MAINTAINERS...?

They're listed in MAINTAINERS in the 5.10 and 5.15 trees, respectively.
That's also a very recent change (within the last week, I think).

--D
