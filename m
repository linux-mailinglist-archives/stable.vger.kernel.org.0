Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F01402B142F
	for <lists+stable@lfdr.de>; Fri, 13 Nov 2020 03:13:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726071AbgKMCNJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Nov 2020 21:13:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39735 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726017AbgKMCNI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Nov 2020 21:13:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605233586;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to; bh=6oM1dXJozOSLVQz6gRBJs6vUBSSzAUJlN3r5T2Civp0=;
        b=Fpq+SGHcxgdx2Gucntr5NmhA/C9GXGJZsJNQEGhxbKrGP6YtBwOMsFR/PiMhFa+j9cxQAw
        i/zP0dYnvsCBbVQ6HBeIVyGxOj6GtWc2tmUdlq8l3pZP+95aQAiBPqOm3WKzqyXBYjy2gV
        W//h3PKcUXw/QBSAiDhYs2DrdIt5xpc=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-291-XlLLZn8fNXWVf7vZNHOgow-1; Thu, 12 Nov 2020 21:13:04 -0500
X-MC-Unique: XlLLZn8fNXWVf7vZNHOgow-1
Received: by mail-pl1-f198.google.com with SMTP id p3so4875465plq.21
        for <stable@vger.kernel.org>; Thu, 12 Nov 2020 18:13:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=6oM1dXJozOSLVQz6gRBJs6vUBSSzAUJlN3r5T2Civp0=;
        b=UTdQCQmiu5nF33tixXuSPlWtTivAc+VF2q9vNId1jNfahtJAWB/GOLzkVJ6RU2W89x
         dYSkrgUWgE7gqpKZ6tAiAE9u9KQ7xXImJEGI/v10bmfIsLKS8VEIpXb7Vlj3IKnD1kXk
         GQbpAzN04cLCl09xb+lhC88hsHjBkDu1X/YeaqxzKU7st/QWhJJCL4n7/WohUL4Muo+3
         GpUG+LSTbypluRBDebVT3TrC3SALDQyCkDRJaG4TD47t4tH1PsVwpPdZPbVZxn2g8aHk
         P44ZioU5A2GAAO/Y047xNfqm7D2v0f2uQJz+9zpSKtOKFHxNN5YvVL6dtoKf6AZPoWp4
         EnDw==
X-Gm-Message-State: AOAM532ZfBEm+9OXsg7DsxP/NtHnKX3ZJY/6/N1OPZHq4GDKAGLWVIF+
        66YqqVk+9Wfq6NprTyabk+i+dHWpeP8jn7pPsc+Dr8QX2folrmS2TCZ9bgx7S8qp3WnDyZqgtlX
        S52Cwl6onRwPWehry
X-Received: by 2002:a17:902:8490:b029:d6:d165:fde with SMTP id c16-20020a1709028490b02900d6d1650fdemr2195826plo.73.1605233583662;
        Thu, 12 Nov 2020 18:13:03 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzHEDnci5VkmW35p+GkK2tlw+enhePU4PuyWiPsmXmq5IOOlswViaz7fgp8I0I7jxwD/I/nJQ==
X-Received: by 2002:a17:902:8490:b029:d6:d165:fde with SMTP id c16-20020a1709028490b02900d6d1650fdemr2195806plo.73.1605233583359;
        Thu, 12 Nov 2020 18:13:03 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id c24sm7011431pgk.34.2020.11.12.18.12.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 18:13:02 -0800 (PST)
Date:   Fri, 13 Nov 2020 10:12:51 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dennis Gilmore <dgilmore@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Eric Sandeen <sandeen@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCH] xfs: fix signed calculation related to XFS_LITINO(mp)
Message-ID: <20201113021251.GA847175@xiangao.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201113020413.GA844372@xiangao.remote.csb>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ sorry for forgetting to Cc dgilmore on this reply, it would be
  much better/helpful with a "Tested-by:" for v2... Let me resend,
  sorry for annoying. ]

Hi,

On Thu, Nov 12, 2020 at 10:30:04AM -0800, Darrick J. Wong wrote:
> On Thu, Nov 12, 2020 at 09:53:53AM -0600, Eric Sandeen wrote:
> > On 11/12/20 12:30 AM, Gao Xiang wrote:
> > > Currently, commit e9e2eae89ddb dropped a (int) decoration from
> > > XFS_LITINO(mp), and since sizeof() expression is also involved,
> > > the result of XFS_LITINO(mp) is simply as the size_t type
> > > (commonly unsigned long).
> > 
> > Thanks for finding this!  Let me think through it a little.
> >  
> > > Considering the expression in xfs_attr_shortform_bytesfit():
> > >   offset = (XFS_LITINO(mp) - bytes) >> 3;
> > > let "bytes" be (int)340, and
> > >     "XFS_LITINO(mp)" be (unsigned long)336.
> > > 
> > > on 64-bit platform, the expression is
> > >   offset = ((unsigned long)336 - (int)340) >> 8 =
> > 
> > This should be >> 3, right.
> > 
> > >            (int)(0xfffffffffffffffcUL >> 3) = -1
> > > 
> > > but on 32-bit platform, the expression is
> > >   offset = ((unsigned long)336 - (int)340) >> 8 =
> > 
> > and >> 3 here as well.
> > 
> > >            (int)(0xfffffffcUL >> 3) = 0x1fffffff
> > > instead.
> > 
> > Ok.  But wow, that magical cast to (int) in XFS_LITINO isn't at
> > all clear to me.
> > 
> > XFS_LITINO() indicates a /size/ - fixing this problem by making it a
> > signed value feels very strange, but I'm not sure what would be better,
> > yet.
> 
> TBH I think this needs to be cleaned up -- what is "LITINO", anyway?
> 
> I'm pretty sure it's the size of the literal area, aka everything after
> the inode core, where the forks live?
> 
> And, uh, can these things get turned into static inline helpers instead
> of weird macros?  Separate patches, obviously.

Thanks, I've addressed all comments in these two reviews in v2:
https://lore.kernel.org/r/20201113015044.844213-1-hsiangkao@redhat.com

As for LITINO itself, btw, what would be the suggested name for this?
I'm not good at naming, and will seek time working on cleaning up this.

> 
> > 
> > > Therefore, one result is
> > >   "ASSERT(new_size <= XFS_IFORK_SIZE(ip, whichfork));"
> > >   assertion failure in xfs_idata_realloc().
> > > 
> > > , which can be triggered with the following commands:
> > >  touch a;
> > >  setfattr -n user.0 -v "`seq 0 80`" a;
> > >  setfattr -n user.1 -v "`seq 0 80`" a
> > > on 32-bit platform.
> > 
> > Can you please write an xfstest for this? :)
> 
> Seconded.

Will seek time on this later as well.

> 
> If this is the fix for the corruption report that dgilmore reported on
> IRC, this should credit him as the reporter and/or tester.  Especially
> because I thought this was just a "oh I found this via code review"
> until someone else pointed out that this was actually a fix for
> something that a user hit in the field.
> 
> The difference is that we're headed towards -rc4 and I'm much more
> willing to hold up posting the xfs-5.11-merge branch to get in fixes for
> user-reported problems.

Yeah, sorry for ignoring this original bugreport, since I thought
the original bugzilla couldn't open publicly.
 https://bugzilla.redhat.com/show_bug.cgi?id=1894177

It would be better to get a "Tested-by:" tag to check the original
case for v2. :)

> 
> > > Fix it by restoring (int) decorator to XFS_LITINO(mp) since
> > > int type for XFS_LITINO(mp) is safe and all pre-exist signed
> > > calculations are correct.
> > > 
> > > Fixes: e9e2eae89ddb ("xfs: only check the superblock version for dinode size calculation")
> > > Cc: <stable@vger.kernel.org> # 5.7+
> > > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > > ---
> > > I'm not sure this is the preferred way or just simply fix
> > > xfs_attr_shortform_bytesfit() since I don't look into the
> > > rest of XFS_LITINO(mp) users. Add (int) to XFS_LITINO(mp)
> > > will avoid all potential regression at least.
> > > 
> > >  fs/xfs/libxfs/xfs_format.h | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> > > index dd764da08f6f..f58f0a44c024 100644
> > > --- a/fs/xfs/libxfs/xfs_format.h
> > > +++ b/fs/xfs/libxfs/xfs_format.h
> > > @@ -1061,7 +1061,7 @@ enum xfs_dinode_fmt {
> > >  		sizeof(struct xfs_dinode) : \
> > >  		offsetof(struct xfs_dinode, di_crc))>  #define XFS_LITINO(mp) \
> > > -	((mp)->m_sb.sb_inodesize - XFS_DINODE_SIZE(&(mp)->m_sb))
> > > +	((int)((mp)->m_sb.sb_inodesize - XFS_DINODE_SIZE(&(mp)->m_sb)))
> > 
> > If we do keep the (int) cast here we at least need a comment explaining why
> > it cannot be removed, unless there is a better way to solve the problem.
> 
> It's still weird, because "size of literal inode area" isn't a signed
> quantity because you can't have a negative size.

I'm fine with either way, since my starting point was to address
the regression of e9e2eae89ddb as I mentioned on IRC. And it can
also be simply fixed directly.

Thanks,
Gao Xiang

> 
> > I wonder if explicitly making XFS_LITINO() cast to a size_t would be
> > best, and then in xfs_attr_shortform_bytesfit() we just quickly reject
> > the query if the bytes are larger than the literal area:
> > 
> > diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> > index bb128db..5588c2e 100644
> > --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> > +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> > @@ -535,6 +535,10 @@ STATIC void xfs_attr3_leaf_moveents(struct xfs_da_args *args,
> >         int                     maxforkoff;
> >         int                     offset;
> >  
> > +       /* Is there no chance we can fit? */
> > +       if (bytes > XFS_LITINO(mp))
> > +               return 0;
> > +
> >         /* rounded down */
> >         offset = (XFS_LITINO(mp) - bytes) >> 3;
> 
> So if LITINO is 336 and the caller asked for 350 bytes, offset will be
> negative here.  However, offset is the proposed forkoff, right?  It
> doesn't make any sense to have a negative forkoff, so I think Eric's
> (bytes > LITINO) suggestion above is correct.
> 
> This patch was hard to review because the comment for
> xfs_attr_shortform_bytesfit mentions "...the requested number of
> additional bytes", but the bytes parameter represents the total number
> of attr fork bytes we want, not a delta over what we have right now.
> Can someone please fix that comment too?
> 
> --D
> 
> > 
> > or, maybe simply:
> > 
> > -        offset = (XFS_LITINO(mp) - bytes) >> 3;
> > +        offset = (int)(XFS_LITINO(mp) - bytes) >> 3;
> > 
> > to be sure that the arithmetic doesn't get promoted to unsigned before the shift?
> > 
> > or maybe others have better ideas.
> > 
> > -Eric
> > 
> >   
> > >  /*
> > >   * Inode data & attribute fork sizes, per inode.
> > > 
> 

