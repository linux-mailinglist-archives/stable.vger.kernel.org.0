Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC181122159
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 02:18:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726191AbfLQBSP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 20:18:15 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:35724 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbfLQBSP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 20:18:15 -0500
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ih1V7-0002xv-1e; Tue, 17 Dec 2019 01:18:13 +0000
Date:   Tue, 17 Dec 2019 01:18:13 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Miklos Szeredi <mszeredi@redhat.com>
Cc:     linux-fsdevel@vger.kernel.org, Andrew Price <anprice@redhat.com>,
        David Howells <dhowells@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCH 02/12] fs_parse: fix fs_param_v_optional handling
Message-ID: <20191217011813.GQ4203@ZenIV.linux.org.uk>
References: <20191128155940.17530-1-mszeredi@redhat.com>
 <20191128155940.17530-3-mszeredi@redhat.com>
 <20191216232845.GP4203@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191216232845.GP4203@ZenIV.linux.org.uk>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 16, 2019 at 11:28:45PM +0000, Al Viro wrote:
> On Thu, Nov 28, 2019 at 04:59:30PM +0100, Miklos Szeredi wrote:
> > String options always have parameters, hence the check for optional
> > parameter will never trigger.
> 
> What do you mean, always have parameters?  Granted, for fsconfig(2) it's
> (currently) true, but I see at least two other pathways that do not impose
> such requirement - vfs_parse_fs_string() and rbd_parse_options().
> 
> You seem to deal with the former later in the patchset, but I don't see
> anything for the latter...

FWIW, I strongly dislike fs_param_v_optional.  I mean, look at the
gfs2 usecase:
	quota			->uint_64 = 0		->negated = false
	quota=off		->uint_32 = 1		->negated = false
	quota=account		->uint_32 = 2		->negated = false
	quota=on		->uint_32 = 3		->negated = false
	noquota			->boolean = false	->negated = true
with gfs2 postprocessing for that thing being
                if (result.negated)
                        args->ar_quota = GFS2_QUOTA_OFF;
                else if (result.int_32 > 0)
                        args->ar_quota = opt_quota_values[result.int_32];
                else   
                        args->ar_quota = GFS2_QUOTA_ON;
                break;
and that relies upon having enum opt_quota members associated with
off/account/on starting from 1.  I mean, WTF?  What we really want is
	quota		GFS2_QUOTA_ON
	quota=on	GFS2_QUOTA_ON
	quota=account	GFS2_QUOTA_ACCOUNT
	quota=off	GFS2_QUOTA_OFF
	noquota		GFS2_QUOTA_OFF

I certainly agree that flag/NULL string is ugly; do we even want to keep
fs_value_is_flag?  It's internal-only, so we can bloody well turn it
into fs_value_is_string and ->string is NULL...  And sure, ->has_value
is redundant - if nothing else, it would make a lot more sense as
static inline bool param_has_value(const struct fs_parameter *param)
{
	return !!param->string;
}
But I really wonder if we should keep breeding kludges.  Look at the
use cases, including the yet-to-be-merged ones.
	1) GFS2: see above
	2) ceph: fsc/nofsc/fsc=...
	3) ext4: init_itable/noinit_itable/init_itable=<number>
	4) nfs: fsc/nofsc/fsc=...

All of that is trivially handled by splitting the opt=... and opt
cases.  We have two such in the tree and two more in posted patchsets.
Plus one more that ext4 patchset breaks, AFAICS (barrier).  Out of
several hundreds.  Everything else either requires = in all cases
or rejects it in all cases.

So how about a flag for "takes no arguments", set automatically by
fsparam_flag()/fsparam_flag_no(), with fs_lookup_key() taking an
extra "comes with argument" flag and filtering according to it?
Rules:
	foo		=> "foo", true
	foo=		=> "foo", false
	foo=bar		=> "foo", false
And to hell with the "optional" flag; for gfs2 we'd end up with
	fsparam_flag_no("quota", Opt_quota_flag),			// quota|noquota
	fsparam_flag_enum("quota", Opt_quota, gfs2_param_quota),	// quota={on|account|off}
Postprocessing won't be any harder, really - we could bloody well do
	case Opt_quota_flag:
		result.int_32 = result.negated ? GFS2_QUOTA_OFF : GFS2_QUOTA_ON;
		/* fallthru */
	case Opt_quota:
		args->ar_quota = result.int_32;
                break;
with gfs2_param_quota having the right values in it, instead of
that intermediate enum.

All ->has_value checks go away that way, AFAICS.  With minimal
impact on yet-to-be-merged series...
