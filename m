Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F53020B9F0
	for <lists+stable@lfdr.de>; Fri, 26 Jun 2020 22:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726206AbgFZUGf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jun 2020 16:06:35 -0400
Received: from mx2.suse.de ([195.135.220.15]:43994 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725823AbgFZUGf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jun 2020 16:06:35 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D36B7AD72;
        Fri, 26 Jun 2020 20:06:32 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 87B25DA703; Fri, 26 Jun 2020 22:06:19 +0200 (CEST)
Date:   Fri, 26 Jun 2020 22:06:19 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc:     David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org,
        stable@vger.kernel.org, hans@knorrie.org
Subject: Re: [PATCH v3] btrfs: pass checksum type via BTRFS_IOC_FS_INFO ioctl
Message-ID: <20200626200619.GI27795@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        linux-btrfs@vger.kernel.org, stable@vger.kernel.org,
        hans@knorrie.org
References: <20200626150107.19666-1-johannes.thumshirn@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200626150107.19666-1-johannes.thumshirn@wdc.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jun 27, 2020 at 12:01:07AM +0900, Johannes Thumshirn wrote:
> With the recent addition of filesystem checksum types other than CRC32c,
> it is not anymore hard-coded which checksum type a btrfs filesystem uses.
> 
> Up to now there is no good way to read the filesystem checksum, apart from
> reading the filesystem UUID and then query sysfs for the checksum type.
> 
> Add a new csum_type field to the BTRFS_IOC_FS_INFO ioctl command which
> usually is used to query filesystem features. Also add a flags member
> indicating that the kernel responded with a set csum_type field.
> 
> To simplify further additions to the ioctl, also switch the padding to a
> u8 array. Pahole was used to verify the result of this switch:
> 
> pahole -C btrfs_ioctl_fs_info_args fs/btrfs/btrfs.ko
> struct btrfs_ioctl_fs_info_args {
>         __u64                      max_id;               /*     0     8 */
>         __u64                      num_devices;          /*     8     8 */
>         __u8                       fsid[16];             /*    16    16 */
g         __u32                      nodesize;             /*    32     4 */
>         __u32                      sectorsize;           /*    36     4 */
>         __u32                      clone_alignment;      /*    40     4 */
>         __u32                      flags;                /*    44     4 */
>         __u16                      csum_type;            /*    48     2 */
>         __u16                      csum_size;            /*    50     2 */
>         __u8                       reserved[972];        /*    52   972 */
> 
>         /* size: 1024, cachelines: 16, members: 10 */
> };
> 
> Fixes: 3951e7f050ac ("btrfs: add xxhash64 to checksumming algorithms")
> Fixes: 3831bf0094ab ("btrfs: add sha256 to checksumming algorithm")
> Cc: stable@vger.kernel.org

CC: stable@vger.kernel.org # 5.5+

it'll not compile otherwise.

> +++ b/fs/btrfs/ioctl.c
> @@ -3217,6 +3217,9 @@ static long btrfs_ioctl_fs_info(struct btrfs_fs_info *fs_info,
>  	fi_args->nodesize = fs_info->nodesize;
>  	fi_args->sectorsize = fs_info->sectorsize;
>  	fi_args->clone_alignment = fs_info->sectorsize;
> +	fi_args->csum_type = btrfs_super_csum_type(fs_info->super_copy);
> +	fi_args->csum_size = btrfs_super_csum_size(fs_info->super_copy);
> +	fi_args->flags |= BTRFS_FS_INFO_FLAG_CSUM_TYPE_SIZE;
>  
>  	if (copy_to_user(arg, fi_args, sizeof(*fi_args)))
>  		ret = -EFAULT;
> diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
> index e6b6cb0f8bc6..2de3ef3c5c71 100644
> --- a/include/uapi/linux/btrfs.h
> +++ b/include/uapi/linux/btrfs.h
> @@ -250,10 +250,20 @@ struct btrfs_ioctl_fs_info_args {
>  	__u32 nodesize;				/* out */
>  	__u32 sectorsize;			/* out */
>  	__u32 clone_alignment;			/* out */
> -	__u32 reserved32;
> -	__u64 reserved[122];			/* pad to 1k */
> +	__u32 flags;				/* out */

After the discussion under v2 with Hans, I think he has a point that
future extension could be problematic as it was with the LOGICAL_INO.
It's similar, once we'd want to do the input flags, there's no way to
make the behaviour safe.

If all ioctl users would zero the buffer it's all fine, but I don't know
how to make that more than a convention and given that this is not well
documented we can't blame users/programs when this is not honored.

So, my suggestion is to make the flags also input, where the valid value
is 0, meaning 'return everything you have'. In this case it's a no-op,
but allows future extensions and fine grained data retrieval.

There's effectively no change in the implementation, other than
documenting the 'in' semantics.

Although this is basically the same situation as in the LOGICAL_INO v1
and v2, the number of users of FS_INFO ioctl is presumably not high and
the buffer has been write-only so far, there's no existing logic that
would had to be tweaked.

Once the flags are there, all new implementations should take the
semantics into account. Therefore I think this is a safe plan, but feel
free to poke more holes to that.
