Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F228721B689
	for <lists+stable@lfdr.de>; Fri, 10 Jul 2020 15:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727951AbgGJNeg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 09:34:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:56214 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727031AbgGJNef (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Jul 2020 09:34:35 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 7E8E9AC9F;
        Fri, 10 Jul 2020 13:34:33 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 46A13DA842; Fri, 10 Jul 2020 15:34:13 +0200 (CEST)
Date:   Fri, 10 Jul 2020 15:34:13 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] btrfs: add missing check for nocow and compression inode
 flags
Message-ID: <20200710133413.GB3703@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        stable@vger.kernel.org
References: <20200710100553.13567-1-dsterba@suse.com>
 <c564eb4a-c798-ccd1-2fc9-d365cf5ba3a1@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c564eb4a-c798-ccd1-2fc9-d365cf5ba3a1@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 10, 2020 at 01:10:25PM +0300, Nikolay Borisov wrote:
> > +static int check_fsflags(unsigned int old_flags, unsigned int flags)
> >  {
> >  	if (flags & ~(FS_IMMUTABLE_FL | FS_APPEND_FL | \
> >  		      FS_NOATIME_FL | FS_NODUMP_FL | \
> > @@ -174,9 +177,19 @@ static int check_fsflags(unsigned int flags)
> >  		      FS_NOCOW_FL))
> >  		return -EOPNOTSUPP;
> >  
> > +	/* COMPR and NOCOMP on new/old are valid */
> >  	if ((flags & FS_NOCOMP_FL) && (flags & FS_COMPR_FL))
> >  		return -EINVAL;
> >  
> > +	if ((flags & FS_COMPR_FL) && (flags & FS_NOCOW_FL))
> > +		return -EINVAL;
> > +
> > +	/* NOCOW and compression options are mutually exclusive */
> > +	if ((old_flags & FS_NOCOW_FL) && (flags & (FS_COMPR_FL | FS_NOCOMP_FL)))
> 
> Why is NOCOW and setting NOCOMP (which would really be a NOOP) an
> invalid combination?

The options are not conflicting directly, like for the compression and
nodatacow, but it still is related to compression so it does not feel
right to allow that even if it's a noop.
