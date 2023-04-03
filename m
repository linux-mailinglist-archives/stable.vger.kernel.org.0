Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 709F16D4526
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 15:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbjDCNCj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 09:02:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232111AbjDCNCb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 09:02:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47C6326256;
        Mon,  3 Apr 2023 06:02:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0272B819EB;
        Mon,  3 Apr 2023 13:02:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3500FC433D2;
        Mon,  3 Apr 2023 13:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680526935;
        bh=CJhOHcAx44TLQwwh7WfEx2VNavqTnQkv7huZ6nQ9LA0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bokqNQRGQJ1cvkuKDXH3pGwZna4iNQG4vmUn4SmVQ1pcbN8z4D1likGOweiLZiy3z
         9jZuhOUkwQNjOqU+i0KnQfvGgM8S5R3NLwAfdDYc99iJrUpqci67twNksRXfNBd3zO
         PgXa+56wjjU9zEzWG9PuP0P9DxuCsgLYmV53YWAs=
Date:   Mon, 3 Apr 2023 15:02:12 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     stable@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Sherry Yang <sherry.yang@oracle.com>,
        kernel test robot <oliver.sang@intel.com>,
        David Sterba <dsterba@suse.com>
Subject: Re: [PATCH stable-5.4.y stable-5.10.y] btrfs: scan device in
 non-exclusive mode
Message-ID: <2023040302-schnapps-egging-77d7@gregkh>
References: <de2889bd0a9ea5446c3473fe7b2086fbd954b9ab.1680496851.git.anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <de2889bd0a9ea5446c3473fe7b2086fbd954b9ab.1680496851.git.anand.jain@oracle.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 03, 2023 at 01:46:08PM +0800, Anand Jain wrote:
> commit 50d281fc434cb8e2497f5e70a309ccca6b1a09f0 upstream.
> 
> This fixes mkfs/mount/check failures due to race with systemd-udevd
> scan.
> 
> During the device scan initiated by systemd-udevd, other user space
> EXCL operations such as mkfs, mount, or check may get blocked and result
> in a "Device or resource busy" error. This is because the device
> scan process opens the device with the EXCL flag in the kernel.
> 
> Two reports were received:
> 
>  - btrfs/179 test case, where the fsck command failed with the -EBUSY
>    error
> 
>  - LTP pwritev03 test case, where mkfs.vfs failed with
>    the -EBUSY error, when mkfs.vfs tried to overwrite old btrfs filesystem
>    on the device.
> 
> In both cases, fsck and mkfs (respectively) were racing with a
> systemd-udevd device scan, and systemd-udevd won, resulting in the
> -EBUSY error for fsck and mkfs.
> 
> Reproducing the problem has been difficult because there is a very
> small window during which these userspace threads can race to
> acquire the exclusive device open. Even on the system where the problem
> was observed, the problem occurrences were anywhere between 10 to 400
> iterations and chances of reproducing decreases with debug printk()s.
> 
> However, an exclusive device open is unnecessary for the scan process,
> as there are no write operations on the device during scan. Furthermore,
> during the mount process, the superblock is re-read in the below
> function call chain:
> 
>   btrfs_mount_root
>    btrfs_open_devices
>     open_fs_devices
>      btrfs_open_one_device
>        btrfs_get_bdev_and_sb
> 
> So, to fix this issue, removes the FMODE_EXCL flag from the scan
> operation, and add a comment.
> 
> The case where mkfs may still write to the device and a scan is running,
> the btrfs signature is not written at that time so scan will not
> recognize such device.
> 
> Reported-by: Sherry Yang <sherry.yang@oracle.com>
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Link: https://lore.kernel.org/oe-lkp/202303170839.fdf23068-oliver.sang@intel.com
> CC: stable@vger.kernel.org # 5.4+
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> Reviewed-by: David Sterba <dsterba@suse.com>
> Signed-off-by: David Sterba <dsterba@suse.com>
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
> 
> The upstream commit 50d281fc434cb8e2497f5e70a309ccca6b1a09f0 can be
> applied without conflict to LTS stable-5.15.y and stable-6.1.y. However,
> on LTS stable-5.4.y and stable-5.15.y, a conflict fix is required since
> the zoned device support commits are not present in these versions. This
> patch resolves the conflicts.

Now queued up, thanks.

greg k-h
