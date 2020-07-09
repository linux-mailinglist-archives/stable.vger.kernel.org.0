Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 475A421A289
	for <lists+stable@lfdr.de>; Thu,  9 Jul 2020 16:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbgGIOwe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jul 2020 10:52:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:45684 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726371AbgGIOwe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Jul 2020 10:52:34 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 0370EAC7D;
        Thu,  9 Jul 2020 14:52:32 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 273DBDAB7F; Thu,  9 Jul 2020 16:52:11 +0200 (CEST)
Date:   Thu, 9 Jul 2020 16:52:11 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc:     David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org,
        Hans van Kranenburg <hans@knorrie.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH v5] btrfs: pass checksum type via BTRFS_IOC_FS_INFO ioctl
Message-ID: <20200709145211.GA3533@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        linux-btrfs@vger.kernel.org, Hans van Kranenburg <hans@knorrie.org>,
        stable@vger.kernel.org
References: <20200706150924.40218-1-johannes.thumshirn@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200706150924.40218-1-johannes.thumshirn@wdc.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 07, 2020 at 12:09:24AM +0900, Johannes Thumshirn wrote:
> With the recent addition of filesystem checksum types other than CRC32c,
> it is not anymore hard-coded which checksum type a btrfs filesystem uses.
> 
> Up to now there is no good way to read the filesystem checksum, apart from
> reading the filesystem UUID and then query sysfs for the checksum type.
> 
> Add a new csum_type and csum_size fields to the BTRFS_IOC_FS_INFO ioctl
> command which usually is used to query filesystem features. Also add a
> flags member indicating that the kernel responded with a set csum_type and
> csum_size field.
> 
> For compatibility reasons, only return the csum_type and csum_size if the
> BTRFS_FS_INFO_FLAG_CSUM_TYPE_SIZE flag was passed to the kernel. Also
> clear any unknown flags so we don't pass false positives to user-space
> newer than the kernel.
> 
> To simplify further additions to the ioctl, also switch the padding to a
> u8 array. Pahole was used to verify the result of this switch:
> 
> pahole -C btrfs_ioctl_fs_info_args fs/btrfs/btrfs.ko
> struct btrfs_ioctl_fs_info_args {
>         __u64                      max_id;               /*     0     8 */
>         __u64                      num_devices;          /*     8     8 */
>         __u8                       fsid[16];             /*    16    16 */
>         __u32                      nodesize;             /*    32     4 */
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
> CC: stable@vger.kernel.org # 5.5+
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
> Changes to v4:
> * zero all data passed in from user-space
>   (I've chosen this variant as I think it is the most complete)
> 
> Changes to v3:
> * make flags in/out (David)
> * make csum return opt-in (Hans)
> 
> Changes to v2:
> * add additional csum_size (David)
> * rename flag value to BTRFS_FS_INFO_FLAG_CSUM_TYPE_SIZE to reflect
>   additional size
> 
> Changes to v1:
> * add 'out' comment to be consistent (Hans)
> * remove le16_to_cpu() (kbuild robot)
> * switch padding to be all u8 (David)
> ---
>  fs/btrfs/ioctl.c           | 16 +++++++++++++---
>  include/uapi/linux/btrfs.h | 14 ++++++++++++--
>  2 files changed, 25 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index ab34179d7cbc..df8a6ba91055 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -3217,11 +3217,15 @@ static long btrfs_ioctl_fs_info(struct btrfs_fs_info *fs_info,
>  	struct btrfs_ioctl_fs_info_args *fi_args;
>  	struct btrfs_device *device;
>  	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
> +	u32 inflags;
>  	int ret = 0;
>  
> -	fi_args = kzalloc(sizeof(*fi_args), GFP_KERNEL);
> -	if (!fi_args)
> -		return -ENOMEM;
> +	fi_args = memdup_user(arg, sizeof(*fi_args));
> +	if (IS_ERR(fi_args))
> +		return PTR_ERR(fi_args);
> +
> +	inflags = fi_args->flags;
> +	memset(fi_args, 0, sizeof(*fi_args));
>  
>  	rcu_read_lock();
>  	fi_args->num_devices = fs_devices->num_devices;
> @@ -3237,6 +3241,12 @@ static long btrfs_ioctl_fs_info(struct btrfs_fs_info *fs_info,
>  	fi_args->sectorsize = fs_info->sectorsize;
>  	fi_args->clone_alignment = fs_info->sectorsize;
>  
> +	if (inflags & BTRFS_FS_INFO_FLAG_CSUM_TYPE_SIZE) {
> +		fi_args->csum_type = btrfs_super_csum_type(fs_info->super_copy);
> +		fi_args->csum_size = btrfs_super_csum_size(fs_info->super_copy);
> +		fi_args->flags |= BTRFS_FS_INFO_FLAG_CSUM_TYPE_SIZE;
> +	}

That's safe, but we'll have to add a new flag for all new members and we
have already 2 ready (generation, metadata_uuid) and ioctl user has to
set the bits. Minor inconvenience, in exchange for future extensions, so
let it be.

> +
>  	if (copy_to_user(arg, fi_args, sizeof(*fi_args)))
>  		ret = -EFAULT;
>  
> diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
> index e6b6cb0f8bc6..c130eaea416e 100644
> --- a/include/uapi/linux/btrfs.h
> +++ b/include/uapi/linux/btrfs.h
> @@ -250,10 +250,20 @@ struct btrfs_ioctl_fs_info_args {
>  	__u32 nodesize;				/* out */
>  	__u32 sectorsize;			/* out */
>  	__u32 clone_alignment;			/* out */
> -	__u32 reserved32;
> -	__u64 reserved[122];			/* pad to 1k */
> +	__u32 flags;				/* in/out */
> +	__u16 csum_type;			/* out */
> +	__u16 csum_size;			/* out */
> +	__u8 reserved[972];			/* pad to 1k */
>  };
>  
> +/*
> + * fs_info ioctl flags
> + *
> + * Used by:
> + * struct btrfs_ioctl_fs_info_args
> + */
> +#define BTRFS_FS_INFO_FLAG_CSUM_TYPE_SIZE		(1 << 0)

Flags should be defined before the structure, but that I can fix up.
