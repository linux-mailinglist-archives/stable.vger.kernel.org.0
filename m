Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 598AB56BDE9
	for <lists+stable@lfdr.de>; Fri,  8 Jul 2022 18:09:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238664AbiGHP4B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jul 2022 11:56:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238231AbiGHP4A (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Jul 2022 11:56:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42E2270E71;
        Fri,  8 Jul 2022 08:56:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F24BEB80522;
        Fri,  8 Jul 2022 15:55:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0F47C341C0;
        Fri,  8 Jul 2022 15:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657295757;
        bh=6LeBPWdiXy/BPonoBicUXWGb43e/5efAsBpoQS94gjQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mSgXUIo1yIJaqQMtcKBNuuFF2SnmwWZdASwi9HpKiW2w1g3mkug9V/EHxX7+plCQl
         BsUU/glMpDyUZx+QGLyOCYxRtP+8K9Fr0Kt85/KDThSNcTK37OkeN3nG2KXfHzbC5P
         eFQ0uIFnE4DQtkhlnNDoABbgSPvZ0JRULHrS0CrU6l23OOQxBMihtlj1Lxtth9E/px
         vCOOjP96xjEZgSgn1wXmQoxnIvP8jAlIK21EIcnQQcIMBefuRoXFv4HAAN/gxX93BF
         QD+KptkGpv/5U6V1QRYPakrROxDlwBDTYnQ8iu2oDPDWZ+Zkwte3YW+D6B9qD/ci+7
         lRpqqlaE46H7w==
Date:   Fri, 8 Jul 2022 08:55:57 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     stable@vger.kernel.org, linux-xfs@vger.kernel.org,
        Ke Xu <kkexu@amazon.com>, Ayushman Dutta <ayudutta@amazon.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Leah Rumancik <lrumancik@google.com>
Subject: Re: [PATCH stable 5.15] xfs: remove incorrect ASSERT in xfs_rename
Message-ID: <YshTjclKanmcBsUW@magnolia>
References: <20220707225835.32094-1-kuniyu@amazon.com>
 <YshTJZVNkXpbGKsv@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YshTJZVNkXpbGKsv@magnolia>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 08, 2022 at 08:54:13AM -0700, Darrick J. Wong wrote:
> On Thu, Jul 07, 2022 at 03:58:35PM -0700, Kuniyuki Iwashima wrote:
> > From: Eric Sandeen <sandeen@redhat.com>
> > 
> > commit e445976537ad139162980bee015b7364e5b64fff upstream.
> > 
> > Ayushman Dutta reported our 5.10 kernel hit the warning.  It was because
> > the original commit misses a Fixes tag and was not backported to the stable
> > tree.  The fix is merged in 5.16, so please backport it to 5.15 first.
> > 
> > This ASSERT in xfs_rename is a) incorrect, because
> > (RENAME_WHITEOUT|RENAME_NOREPLACE) is a valid combination, and
> > b) unnecessary, because actual invalid flag combinations are already
> > handled at the vfs level in do_renameat2() before we get called.
> > So, remove it.
> > 
> > Reported-by: Paolo Bonzini <pbonzini@redhat.com>
> > Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > Fixes: 7dcf5c3e4527 ("xfs: add RENAME_WHITEOUT support")
> > Reported-by: Ayushman Dutta <ayudutta@amazon.com>
> > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> 
> Looks good to me, but you really ought to send 5.10 patches to the 5.10
> XFS maintainer (Amir, now cc'd).  (Yes, this is a recent change.) ;)

...and of course the first thing that happens is that I mix up the 5.10
and 5.15 patches.

Amir is the 5.10 maintainer, Leah is the 5.15 maintainer.  Sorry about
the mixup.  /me pours himself a third(!) cup of coffee.

--D

> Acked-by: Darrick J. Wong <djwong@kernel.org>
> 
> --D
> 
> > ---
> > I will send another patch for 4.9 - 5.4 because of a conflict with idmapped
> > mount changes.
> > ---
> >  fs/xfs/xfs_inode.c | 1 -
> >  1 file changed, 1 deletion(-)
> > 
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index 2477e301fa82..c19f3ca605af 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -3128,7 +3128,6 @@ xfs_rename(
> >  	 * appropriately.
> >  	 */
> >  	if (flags & RENAME_WHITEOUT) {
> > -		ASSERT(!(flags & (RENAME_NOREPLACE | RENAME_EXCHANGE)));
> >  		error = xfs_rename_alloc_whiteout(mnt_userns, target_dp, &wip);
> >  		if (error)
> >  			return error;
> > -- 
> > 2.30.2
> > 
