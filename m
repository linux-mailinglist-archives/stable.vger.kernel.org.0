Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBC552992BF
	for <lists+stable@lfdr.de>; Mon, 26 Oct 2020 17:46:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1786348AbgJZQq3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 12:46:29 -0400
Received: from casper.infradead.org ([90.155.50.34]:45024 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408380AbgJZQot (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Oct 2020 12:44:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:To:From:Date:Sender:Reply-To:Cc:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ulnqTjMrBKaF480Abr2+mk3fNXPi753tTvCmHg1d4pg=; b=f1NI3CAsOSysuZzKkwfJhVuIWR
        3mXIQtiVD7DD/2SdiUrYbTpuJuX6lgF28b/95rFLxUerMdwSVmj/ZV+tnAz6dfDbVkSdMl8QQJJ3n
        rpRsqBFIv8JAhq+bzsja5A3WUI151bKwWdqER6/6DpsxpQ5cju9L+9HnwftwJrMUJsnBY7ZyiSaZE
        8qIFt38vcTDLCQX9rCsElOM2Ls24D0mI6Qa8Th4tgk+hFQHG+OuASqdjaqYMzYmn28LiHoaDg4WOl
        jNsaZjcAxkuv+tE9b6PitSKZTpk4b1W73VyFNGg8Te+nIR/QvFEqofI+P0lH20xmNgUMLOXbB4jLN
        dNv1gxow==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kX5bu-0003Lt-GL; Mon, 26 Oct 2020 16:44:42 +0000
Date:   Mon, 26 Oct 2020 16:44:42 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     dsterba@suse.cz, linux-fsdevel@vger.kernel.org, ericvh@gmail.com,
        lucho@ionkov.net, viro@zeniv.linux.org.uk, jlayton@kernel.org,
        idryomov@gmail.com, mark@fasheh.com, jlbec@evilplan.org,
        joseph.qi@linux.alibaba.com, v9fs-developer@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org,
        ocfs2-devel@oss.oracle.com, linux-btrfs@vger.kernel.org,
        clm@fb.com, josef@toxicpanda.com, dsterba@suse.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 6/7] btrfs: Promote to unsigned long long before shifting
Message-ID: <20201026164442.GU20115@casper.infradead.org>
References: <20201004180428.14494-1-willy@infradead.org>
 <20201004180428.14494-7-willy@infradead.org>
 <20201026163546.GP6756@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201026163546.GP6756@twin.jikos.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 26, 2020 at 05:35:46PM +0100, David Sterba wrote:
> On Sun, Oct 04, 2020 at 07:04:27PM +0100, Matthew Wilcox (Oracle) wrote:
> > On 32-bit systems, this shift will overflow for files larger than 4GB.
> > 
> > Cc: stable@vger.kernel.org
> > Fixes: 53b381b3abeb ("Btrfs: RAID5 and RAID6")
> > Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> > ---
> >  fs/btrfs/raid56.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
> > index 255490f42b5d..5ee0a53301bd 100644
> > --- a/fs/btrfs/raid56.c
> > +++ b/fs/btrfs/raid56.c
> > @@ -1089,7 +1089,7 @@ static int rbio_add_io_page(struct btrfs_raid_bio *rbio,
> >  	u64 disk_start;
> >  
> >  	stripe = &rbio->bbio->stripes[stripe_nr];
> > -	disk_start = stripe->physical + (page_index << PAGE_SHIFT);
> > +	disk_start = stripe->physical + ((loff_t)page_index << PAGE_SHIFT);
> 
> It seems that this patch is mechanical replacement. If you check the
> callers, the page_index is passed from an int that iterates over bits
> set in an unsigned long (bitmap). The result won't overflow.

Not mechanical, but I clearly made mistakes.  Will you pick up the
patches which actually fix bugs?
