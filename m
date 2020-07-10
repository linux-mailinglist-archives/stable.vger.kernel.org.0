Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C81F321B659
	for <lists+stable@lfdr.de>; Fri, 10 Jul 2020 15:28:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbgGJN2g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 09:28:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:51558 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726774AbgGJN2g (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Jul 2020 09:28:36 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 258A6AD65;
        Fri, 10 Jul 2020 13:28:35 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id E5CD9DA842; Fri, 10 Jul 2020 15:28:14 +0200 (CEST)
Date:   Fri, 10 Jul 2020 15:28:14 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc:     David Sterba <dsterba@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] btrfs: add missing check for nocow and compression inode
 flags
Message-ID: <20200710132814.GA3703@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        David Sterba <dsterba@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <20200710100553.13567-1-dsterba@suse.com>
 <SN4PR0401MB35981E3913C16CB69DA42DF29B650@SN4PR0401MB3598.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SN4PR0401MB35981E3913C16CB69DA42DF29B650@SN4PR0401MB3598.namprd04.prod.outlook.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 10, 2020 at 10:17:55AM +0000, Johannes Thumshirn wrote:
> On 10/07/2020 12:06, David Sterba wrote:
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
> > +		return -EINVAL;
> > +	if ((flags & FS_NOCOW_FL) && (old_flags & (FS_COMPR_FL | FS_NOCOMP_FL)))
> > +		return -EINVAL;
> > +
> 
> 
> If we'd pass in fs_info to check_fsflags() we could also validate against mount options
> which are incompatible with inode flags. Like -o nodatacow and FS_COMPR_FL or 
> -o auth_key and FS_NOCOW_FL.

Same question was asked on IRC too, mount options are independent and
take lower precedence than the inode attributes. A scenario where user
wants to set a nodatacow attribute when the filesystem is mounted with
compress= is valid and can be quite common.
