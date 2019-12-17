Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 438451222AB
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 04:29:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbfLQD1r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 22:27:47 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:37100 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726698AbfLQD1r (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 22:27:47 -0500
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ih3WT-0006Me-9Z; Tue, 17 Dec 2019 03:27:45 +0000
Date:   Tue, 17 Dec 2019 03:27:45 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Miklos Szeredi <mszeredi@redhat.com>
Cc:     linux-fsdevel@vger.kernel.org, Andrew Price <anprice@redhat.com>,
        David Howells <dhowells@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCH 02/12] fs_parse: fix fs_param_v_optional handling
Message-ID: <20191217032745.GR4203@ZenIV.linux.org.uk>
References: <20191128155940.17530-1-mszeredi@redhat.com>
 <20191128155940.17530-3-mszeredi@redhat.com>
 <20191216232845.GP4203@ZenIV.linux.org.uk>
 <20191217011813.GQ4203@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191217011813.GQ4203@ZenIV.linux.org.uk>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 17, 2019 at 01:18:13AM +0000, Al Viro wrote:

> So how about a flag for "takes no arguments", set automatically by
> fsparam_flag()/fsparam_flag_no(), with fs_lookup_key() taking an
> extra "comes with argument" flag and filtering according to it?
> Rules:
> 	foo		=> "foo", true
> 	foo=		=> "foo", false
> 	foo=bar		=> "foo", false
> And to hell with the "optional" flag; for gfs2 we'd end up with
> 	fsparam_flag_no("quota", Opt_quota_flag),			// quota|noquota
> 	fsparam_flag_enum("quota", Opt_quota, gfs2_param_quota),	// quota={on|account|off}
> Postprocessing won't be any harder, really - we could bloody well do
> 	case Opt_quota_flag:
> 		result.int_32 = result.negated ? GFS2_QUOTA_OFF : GFS2_QUOTA_ON;
> 		/* fallthru */
> 	case Opt_quota:
> 		args->ar_quota = result.int_32;
>                 break;
> with gfs2_param_quota having the right values in it, instead of
> that intermediate enum.
> 
> All ->has_value checks go away that way, AFAICS.  With minimal
> impact on yet-to-be-merged series...

FWIW, we have the following types right now:
fs_param_is_flag	no argument
fs_param_is_bool	no argument or string argument (1 instance in mainline[*])
fs_param_is_u32		string argument [**]
fs_param_is_u32_octal	string argument
fs_param_is_u32_hex	string argument
fs_param_is_s32		string argument
fs_param_is_u64		string argument
fs_param_is_enum	string argument; gfs2 has the quota/noquota/quota=... mess
fs_param_is_string	string argument; ceph (and nfs) have fsc/nofsc/fsc=...
fs_param_is_fd		unused at the moment; eventually - string argument.
fs_param_is_blob	fsconfig-only
fs_param_is_blockdev	fsconfig-only
fs_param_is_path	fsconfig-only

[*] no_disconnect in gadgetfs; buggered, since it used to require a numeric
argument.  Now it quietly treats no_disconnect as no_disconnect=1 and
rejects e.g. no_disconnect=2.  There are two more in ext4, also buggered
as far as I can tell.
[**] ext4 has init_itable/init_itable=%u/noinit_itable

The total over all filesystems with conversions posted or already in mainline:

* no_disconnect [drivers/usb/gadget/function/f_fs.c, broken]
* init_itable/init_itable=%u/noinit_itable [ext4]
* fsc/fsc=%s/nofsc [ceph]
* fsc/fsc=%s/nofsc [nfs]
* quota/quota=on/quota=off/quota=account/noquota [gfs2]
* barrier/barrier=%u/nobarrier [ext4]
* auto_da_alloc/auto_da_alloc=%u/noauto_da_alloc [ext4]

It's rare.  So much that I don't believe that fs_param_v_optional has any
reason to exist.  Let's split those entries and be done with that.

Hmm...  Deciding whether we have an argument-bearing or no-argument case
is somewhat inconvenient for fsconfig-generated calls - check for
NULL param->string is, strictly speaking, in nasal daemon territory
for types other than flag and string...  OK, sold - let's check for
fs_value_is_flag.  So I'm combining your patch with #9/12 (to avoid bisect
hazard) + correction for rbd.  And putting that in the very beginning of
fs_parser reorg series, with elimination of fs_param_v_optional closer
to the end.
