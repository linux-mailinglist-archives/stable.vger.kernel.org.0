Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7352B2D66
	for <lists+stable@lfdr.de>; Sat, 14 Nov 2020 14:49:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbgKNNtU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Nov 2020 08:49:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:59750 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726513AbgKNNtU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Nov 2020 08:49:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605361757;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ug9xoD0PUa5DKevh55gCjRc+sFfYVHm5RSwAOyirBQ4=;
        b=NJvN1isdoe4OoWGgdLbyHbWV9IgGswnIRHcKoZhhM0ajHCu4xjy4iKNo5hZuJQpzqQVcGm
        fat3T78xfqJ+52kntb0anrjcBCW478MpwLU+f8d+k331yyrT42kZSCTtpGue0QzutwGfF8
        vvxMnDJJY+Tjx7VZLXg9O0bAnn3DUV8=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-582-vY8AIy4iNoiDvrNoZ-xVKA-1; Sat, 14 Nov 2020 08:49:15 -0500
X-MC-Unique: vY8AIy4iNoiDvrNoZ-xVKA-1
Received: by mail-pf1-f197.google.com with SMTP id 190so8662410pfz.16
        for <stable@vger.kernel.org>; Sat, 14 Nov 2020 05:49:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ug9xoD0PUa5DKevh55gCjRc+sFfYVHm5RSwAOyirBQ4=;
        b=kJuStP8WPbdgNIx9SB9TK2vTVVj3xQPAC3iBlcnD04rhhSgzK38ze8ZIzPK4OonE/7
         CAwiSgxCBt8wGdQBuINnwCeBd1FbQnlif3ERIUNCH9uwp14ilx3xI6KtdJbMzFixKCIK
         2/CilWnN0z2AIak3cRj9Ah8RFYpuQTU2QS6/WeL+dCk2xFigOS+n6X2nnKSAjyIb72g0
         F1HNryMm8lBfiVW7NUb8pa1h1Hlbj859/MxnlMXS/jwedK0sOvGVxi/GhgNd3vP6s136
         B61WVN0ZAd1EuPtLsmLS8fIy3VY1xzb1qXVxZtyztDnEpYaVXsHXO0PB91HuvGVe9Ibu
         n0qw==
X-Gm-Message-State: AOAM530a64jevuX2hoMhnyhhFWOuDXtDXDQs4wyYA75lxvUX0rUoRd2U
        cMXfFjbJZyH7qnGiKNfjzGc6A8IaAAamVJYFibDzCR2XpLQrdGtIzqe+0bUG71WpuqKI89USxBg
        KwoKTd2iiUYLqay3X
X-Received: by 2002:a63:e757:: with SMTP id j23mr5353261pgk.301.1605361754279;
        Sat, 14 Nov 2020 05:49:14 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz4+MActlPhr7QdN5M+1vxo6ALwKjsGv3neTqwMdVc/Z9pAtkdCMac/51dkDE1xAezO80WBeg==
X-Received: by 2002:a63:e757:: with SMTP id j23mr5353247pgk.301.1605361753962;
        Sat, 14 Nov 2020 05:49:13 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o16sm11500381pgn.66.2020.11.14.05.49.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2020 05:49:13 -0800 (PST)
Date:   Sat, 14 Nov 2020 21:49:02 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Dennis Gilmore <dgilmore@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2] xfs: fix forkoff miscalculation related to
 XFS_LITINO(mp)
Message-ID: <20201114134902.GA1151199@xiangao.remote.csb>
References: <20201112063005.692054-1-hsiangkao@redhat.com>
 <20201113015044.844213-1-hsiangkao@redhat.com>
 <20201114103249.GA19866@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201114103249.GA19866@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Nov 14, 2020 at 11:32:49AM +0100, Christoph Hellwig wrote:
> On Fri, Nov 13, 2020 at 09:50:44AM +0800, Gao Xiang wrote:
> > Currently, commit e9e2eae89ddb dropped a (int) decoration from
> > XFS_LITINO(mp), and since sizeof() expression is also involved,
> > the result of XFS_LITINO(mp) is simply as the size_t type
> > (commonly unsigned long).
> > 
> > Considering the expression in xfs_attr_shortform_bytesfit():
> >   offset = (XFS_LITINO(mp) - bytes) >> 3;
> > let "bytes" be (int)340, and
> >     "XFS_LITINO(mp)" be (unsigned long)336.
> > 
> > on 64-bit platform, the expression is
> >   offset = ((unsigned long)336 - (int)340) >> 3 =
> >            (int)(0xfffffffffffffffcUL >> 3) = -1
> > 
> > but on 32-bit platform, the expression is
> >   offset = ((unsigned long)336 - (int)340) >> 3 =
> >            (int)(0xfffffffcUL >> 3) = 0x1fffffff
> > instead.
> > 
> > so offset becomes a large positive number on 32-bit platform, and
> > cause xfs_attr_shortform_bytesfit() returns maxforkoff rather than 0.
> > 
> > Therefore, one result is
> >   "ASSERT(new_size <= XFS_IFORK_SIZE(ip, whichfork));"
> > 
> > assertion failure in xfs_idata_realloc(), which was also the root
> > cause of the original bugreport from Dennis, see:
> >    https://bugzilla.redhat.com/show_bug.cgi?id=1894177
> > 
> > And it can also be manually triggered with the following commands:
> >   $ touch a;
> >   $ setfattr -n user.0 -v "`seq 0 80`" a;
> >   $ setfattr -n user.1 -v "`seq 0 80`" a
> > 
> > on 32-bit platform.
> > 
> > Fix the case in xfs_attr_shortform_bytesfit() by bailing out
> > "XFS_LITINO(mp) < bytes" in advance suggested by Eric and a misleading
> > comment together with this bugfix suggested by Darrick. It seems the
> > other users of XFS_LITINO(mp) are not impacted.
> > 
> > Reported-by: Dennis Gilmore <dgilmore@redhat.com>
> > Fixes: e9e2eae89ddb ("xfs: only check the superblock version for dinode size calculation")
> > Cc: <stable@vger.kernel.org> # 5.7+
> > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > ---
> > changes since v1:
> >  - fix 2 typos ">> 8" to ">> 3" mentioned by Eric;
> >  - directly bail out "XFS_LITINO(mp) < bytes" suggested
> >    by Eric and Darrick;
> >  - fix a misleading comment together suggested by Darrick;
> >  - since (int) decorator doesn't need to be added, so update
> >    the patch subject as well.
> > 
> >  fs/xfs/libxfs/xfs_attr_leaf.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> > index bb128db220ac..c8d91034850b 100644
> > --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> > +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> > @@ -515,7 +515,7 @@ xfs_attr_copy_value(
> >   *========================================================================*/
> >  
> >  /*
> > - * Query whether the requested number of additional bytes of extended
> > + * Query whether the total requested number of attr fork bytes of extended
> >   * attribute space will be able to fit inline.
> >   *
> >   * Returns zero if not, else the di_forkoff fork offset to be used in the
> > @@ -535,6 +535,10 @@ xfs_attr_shortform_bytesfit(
> >  	int			maxforkoff;
> >  	int			offset;
> >  
> > +	/* there is no chance we can fit */
> 
> Maybe:
> 
> 	/* 
> 	 * Check if the new size could fit at all first:
> 	 */

ok, let me quick revise it as the next version.

> 
> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

Thanks,
Gao Xiang

> 

