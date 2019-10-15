Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 626AFD7291
	for <lists+stable@lfdr.de>; Tue, 15 Oct 2019 11:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbfJOJxb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Oct 2019 05:53:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:35330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725890AbfJOJxb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Oct 2019 05:53:31 -0400
Received: from localhost (unknown [84.241.198.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0DAE20659;
        Tue, 15 Oct 2019 09:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571133209;
        bh=qrS1Li+aM/D70cvMwpJEJm39oVCjUpXDVJKvk7tEhQE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ret2mrFHlWc9NqFsQTwPv1/9Fkxx/UcLBYFRG4i++1r6JSe/gWyZRa+PM+b+DxsE/
         AXBqGpSggD1UZYad61Z4PeZ0S3k8LZgBouKETZaw//WGA3RBmT7vn6iVFzciAwu+fP
         980fgmA9WtmZm3CdcATF7dC7409GA+yN77qw4Xms=
Date:   Tue, 15 Oct 2019 11:53:25 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Yi Li <yili@winhong.com>
Cc:     stable@vger.kernel.org, Yi Li <yilikernel@gmail.com>
Subject: Re: [PATCH] ocfs2: fix panic due to ocfs2_wq is null
Message-ID: <20191015095325.GD968039@kroah.com>
References: <1571129255-1617-1-git-send-email-yili@winhong.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1571129255-1617-1-git-send-email-yili@winhong.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 15, 2019 at 04:47:35PM +0800, Yi Li wrote:
> mount.ocfs2 failed when read ocfs2 filesystem super error.
> the func ocfs2_initialize_super will return before allocate ocfs2_wq.
> ocfs2_dismount_volume will flush the ocfs2_wq, that triggered the following panic.
> 
> Oct 15 16:09:27 cnwarekv-205120 kernel: OCFS2: ERROR (device dm-34): ocfs2_validate_inode_block: Invalid dinode #513: fs_generation is 1837764116
> Oct 15 16:09:27 cnwarekv-205120 kernel: On-disk corruption discovered. Please run fsck.ocfs2 once the filesystem is unmounted.
> Oct 15 16:09:27 cnwarekv-205120 kernel: OCFS2: File system is now read-only.
> Oct 15 16:09:27 cnwarekv-205120 kernel: (mount.ocfs2,22804,44):ocfs2_read_locked_inode:537 ERROR: status = -30
> Oct 15 16:09:27 cnwarekv-205120 kernel: (mount.ocfs2,22804,44):ocfs2_init_global_system_inodes:458 ERROR: status = -30
> Oct 15 16:09:27 cnwarekv-205120 kernel: (mount.ocfs2,22804,44):ocfs2_init_global_system_inodes:491 ERROR: status = -30
> Oct 15 16:09:27 cnwarekv-205120 kernel: (mount.ocfs2,22804,44):ocfs2_initialize_super:2313 ERROR: status = -30
> Oct 15 16:09:27 cnwarekv-205120 kernel: (mount.ocfs2,22804,44):ocfs2_fill_super:1033 ERROR: status = -30
> ------------[ cut here ]------------
> Oops: 0002 [#1] SMP NOPTI
> Modules linked in: ocfs2 rpcsec_gss_krb5 auth_rpcgss nfsv4 nfs fscache lockd grace ocfs2_dlmfs ocfs2_stack_o2cb ocfs2_dlm ocfs2_nodemanager ocfs2_stackglue configfs sunrpc ipt_REJECT nf_reject_ipv4 nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_reject_ipv6 nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr ipv6 ovmapi ppdev parport_pc parport xen_netfront fb_sys_fops sysimgblt sysfillrect syscopyarea acpi_cpufreq pcspkr i2c_piix4 i2c_core sg ext4 jbd2 mbcache2 sr_mod cdrom xen_blkfront pata_acpi ata_generic ata_piix floppy dm_mirror dm_region_hash dm_log dm_mod
> CPU: 1 PID: 11753 Comm: mount.ocfs2 Tainted: G  E	4.14.148-200.ckv.x86_64 #1
> Hardware name: Sugon H320-G30/35N16-US, BIOS 0SSDX017 12/21/2018
> task: ffff967af0520000 task.stack: ffffa5f05484000
> RIP: 0010:mutex_lock+0x19/0x20
> Call Trace:
>   flush_workqueue+0x81/0x460
>   ocfs2_shutdown_local_alloc+0x47/0x440 [ocfs2]
>   ocfs2_dismount_volume+0x84/0x400 [ocfs2]
>   ocfs2_fill_super+0xa4/0x1270 [ocfs2]
>   ? ocfs2_initialize_super.isa.211+0xf20/0xf20 [ocfs2]
>   mount_bdev+0x17f/0x1c0
>   mount_fs+0x3a/0x160
> 
> Signed-off-by: Yi Li <yilikernel@gmail.com>
> ---
>  fs/ocfs2/localalloc.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 


<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
