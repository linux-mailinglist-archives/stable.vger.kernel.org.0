Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D81A742AD63
	for <lists+stable@lfdr.de>; Tue, 12 Oct 2021 21:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232440AbhJLToN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 15:44:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:42258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231586AbhJLToN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Oct 2021 15:44:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BCDF460D07;
        Tue, 12 Oct 2021 19:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634067731;
        bh=rLcPfsQ3tIufxB8GIp+TXk9TLpGgbzcdK76VOgyWNl8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=PE9gWmdWCZJRgZF+CnoT2sY6C1Wq6AAEZwlasc1rBk3HhO12T0XSPj4seIc6RSHHS
         FudjBEKXv0CaCvO3LTQbs7+Bp7dd6pdfFlCyFITZGLC1LB+rLRSEQ3IzRXFuki8wcF
         /HvAl58TJm+Rnjh+Zzfu/AuKMDXiB5gB9SMjpSFjXcDVl8KN5NWXtdO5C6ViuxGTN2
         82aqbNaplk3lzNSJ88RyiQtnUdLUXGQ5pMywBtL2xh8zYJt14845nc6UKXQGxaytCk
         Tcs5PuckKJxQCWsY48nebRI7/y0XKbXxFmPXeQXBOAMdzzAXMkkdyOWhV0aRBaZDzD
         gXvQsCUuzhpXg==
Message-ID: <e69f6a977f01eb8493284395b04981a7def580b2.camel@kernel.org>
Subject: Re: [PATCH v3] ceph: skip existing superblocks that are blocklisted
 or shut down when mounting
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Niels de Vos <ndevos@redhat.com>,
        "Yan, Zheng" <ukernel@gmail.com>, stable@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Date:   Tue, 12 Oct 2021 15:42:09 -0400
In-Reply-To: <CAOi1vP8L74DQAKHrF9FFz00pvqcktOXLdemhFGmXsROZCtNB=w@mail.gmail.com>
References: <20211012134915.38994-1-jlayton@kernel.org>
         <CAOi1vP8L74DQAKHrF9FFz00pvqcktOXLdemhFGmXsROZCtNB=w@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.4 (3.40.4-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2021-10-12 at 21:05 +0200, Ilya Dryomov wrote:
> On Tue, Oct 12, 2021 at 3:49 PM Jeff Layton <jlayton@kernel.org> wrote:
> > 
> > Currently when mounting, we may end up finding an existing superblock
> > that corresponds to a blocklisted MDS client. This means that the new
> > mount ends up being unusable.
> > 
> > If we've found an existing superblock with a client that is already
> > blocklisted, and the client is not configured to recover on its own,
> > fail the match. Ditto if the superblock has been forcibly unmounted.
> > 
> > While we're in here, also rename "other" to the more conventional "fsc".
> > 
> > Cc: Patrick Donnelly <pdonnell@redhat.com>
> > Cc: Niels de Vos <ndevos@redhat.com>
> > Cc: "Yan, Zheng" <ukernel@gmail.com>
> > Cc: stable@vger.kernel.org
> > URL: https://bugzilla.redhat.com/show_bug.cgi?id=1901499
> > Reviewed-by: Xiubo Li <xiubli@redhat.com>
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > 
> > ceph: when comparing superblocks, skip ones that have been forcibly unmounted
> > 
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> 
> Hi Jeff,
> 
> This looks like a squashing left-over.
> 

Yep, that can be removed.

> > ---
> >  fs/ceph/super.c | 17 ++++++++++++++---
> >  1 file changed, 14 insertions(+), 3 deletions(-)
> > 
> > v3: also handle the case where we have a forcibly unmounted superblock
> >     that is detached but still extant
> > 
> > diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> > index f517ad9eeb26..b9ba50c9dc95 100644
> > --- a/fs/ceph/super.c
> > +++ b/fs/ceph/super.c
> > @@ -1123,16 +1123,16 @@ static int ceph_compare_super(struct super_block *sb, struct fs_context *fc)
> >         struct ceph_fs_client *new = fc->s_fs_info;
> >         struct ceph_mount_options *fsopt = new->mount_options;
> >         struct ceph_options *opt = new->client->options;
> > -       struct ceph_fs_client *other = ceph_sb_to_client(sb);
> > +       struct ceph_fs_client *fsc = ceph_sb_to_client(sb);
> > 
> >         dout("ceph_compare_super %p\n", sb);
> > 
> > -       if (compare_mount_options(fsopt, opt, other)) {
> > +       if (compare_mount_options(fsopt, opt, fsc)) {
> >                 dout("monitor(s)/mount options don't match\n");
> >                 return 0;
> >         }
> >         if ((opt->flags & CEPH_OPT_FSID) &&
> > -           ceph_fsid_compare(&opt->fsid, &other->client->fsid)) {
> > +           ceph_fsid_compare(&opt->fsid, &fsc->client->fsid)) {
> >                 dout("fsid doesn't match\n");
> >                 return 0;
> >         }
> > @@ -1140,6 +1140,17 @@ static int ceph_compare_super(struct super_block *sb, struct fs_context *fc)
> >                 dout("flags differ\n");
> >                 return 0;
> >         }
> > +       /* Exclude any blocklisted superblocks */
> 
> Nit: given the dout message that follows, this comment seems useless.
> 
> Thanks,
> 
>                 Ilya

I'm fine with removing that comment. Would you rather I resend, or do
you just want to fix up the nits in-tree?

Thanks,
-- 
Jeff Layton <jlayton@kernel.org>

