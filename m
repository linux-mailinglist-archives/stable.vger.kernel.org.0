Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71A5C21D90D
	for <lists+stable@lfdr.de>; Mon, 13 Jul 2020 16:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730205AbgGMOua (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jul 2020 10:50:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:52184 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730217AbgGMOu3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Jul 2020 10:50:29 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 8BDB8AB55;
        Mon, 13 Jul 2020 14:50:29 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id E6440DA809; Mon, 13 Jul 2020 16:50:05 +0200 (CEST)
Date:   Mon, 13 Jul 2020 16:50:05 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc:     "dsterba@suse.cz" <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2 1/4] btrfs: pass checksum type via BTRFS_IOC_FS_INFO
 ioctl
Message-ID: <20200713145005.GK3703@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <20200713122901.1773-1-johannes.thumshirn@wdc.com>
 <20200713122901.1773-2-johannes.thumshirn@wdc.com>
 <20200713142716.GJ3703@twin.jikos.cz>
 <SN4PR0401MB3598A0145F197C70A681EB5F9B600@SN4PR0401MB3598.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <SN4PR0401MB3598A0145F197C70A681EB5F9B600@SN4PR0401MB3598.namprd04.prod.outlook.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 13, 2020 at 02:28:36PM +0000, Johannes Thumshirn wrote:
> On 13/07/2020 16:27, David Sterba wrote:
> > On Mon, Jul 13, 2020 at 09:28:58PM +0900, Johannes Thumshirn wrote:
> >> --- a/fs/btrfs/ioctl.c
> >> +++ b/fs/btrfs/ioctl.c
> >> @@ -3217,11 +3217,15 @@ static long btrfs_ioctl_fs_info(struct btrfs_fs_info *fs_info,
> >>  	struct btrfs_ioctl_fs_info_args *fi_args;
> >>  	struct btrfs_device *device;
> >>  	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
> >> +	u32 flags_in;
> > 
> > u64 here too, I'll fix it.
> 
> Uh, surprised why GCC didn't warn me about the truncation

The right warning for that is -Wconversion but it's off by default.
Integer type truncations are common becasue we know what we're doing
(except for the bugs).

fs/btrfs/ioctl.c: In function ‘btrfs_ioctl_fs_info’:
fs/btrfs/ioctl.c:3228:13: warning: conversion from ‘__u64’ {aka ‘long long unsigned int’} to ‘u32’ {aka ‘unsigned int’} may change value [-Wconversion]
 3228 |  flags_in = fi_args->flags;

Otherwise:

$ make ccflags-y=-Wconversion fs/btrfs/ioctl.o 2>&1 | grep warning: | wc -l
533

Most of them are from included headers.
