Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E4D433DC67
	for <lists+stable@lfdr.de>; Tue, 16 Mar 2021 19:18:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236558AbhCPSR5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 14:17:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58042 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239966AbhCPSR2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Mar 2021 14:17:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615918648;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HAM1TwwmGz08tYIJFcJigdtdBF6Phn1evgG1Tccbtsg=;
        b=Q9rG+KP3BWgvwJNzCa2Gkqkoev4xmPpVZjhN9k3yvEwnaRFyOVUK8IYjWULg1dJ/vnotN3
        d7ar81t/92VruQgLLbcIMHOUKyzrobRD2gnAuv7Lfz4l/7nZyQQWtLBvNf2vhP/m/cxE4t
        qt/K7jPgO18W7K6+roHjZ8LsUAr3MRw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-527-QoVFzhEFMwyyetXQP_FxeQ-1; Tue, 16 Mar 2021 14:17:26 -0400
X-MC-Unique: QoVFzhEFMwyyetXQP_FxeQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 03632107ACCA;
        Tue, 16 Mar 2021 18:17:25 +0000 (UTC)
Received: from horse.redhat.com (ovpn-114-57.rdu2.redhat.com [10.10.114.57])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 892EC5D9C0;
        Tue, 16 Mar 2021 18:17:18 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 1B80E220BCF; Tue, 16 Mar 2021 14:17:18 -0400 (EDT)
Date:   Tue, 16 Mar 2021 14:17:18 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Luis Henriques <lhenriques@suse.de>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        virtualization@lists.linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, virtio-fs-list <virtio-fs@redhat.com>
Subject: Re: [PATCH] virtiofs: fix memory leak in virtio_fs_probe()
Message-ID: <20210316181718.GG270529@redhat.com>
References: <20210316170234.21736-1-lhenriques@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316170234.21736-1-lhenriques@suse.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 16, 2021 at 05:02:34PM +0000, Luis Henriques wrote:
> When accidentally passing twice the same tag to qemu, kmemleak ended up
> reporting a memory leak in virtiofs.  Also, looking at the log I saw the
> following error (that's when I realised the duplicated tag):
> 
>   virtiofs: probe of virtio5 failed with error -17
> 
> Here's the kmemleak log for reference:
> 
> unreferenced object 0xffff888103d47800 (size 1024):
>   comm "systemd-udevd", pid 118, jiffies 4294893780 (age 18.340s)
>   hex dump (first 32 bytes):
>     00 00 00 00 ad 4e ad de ff ff ff ff 00 00 00 00  .....N..........
>     ff ff ff ff ff ff ff ff 80 90 02 a0 ff ff ff ff  ................
>   backtrace:
>     [<000000000ebb87c1>] virtio_fs_probe+0x171/0x7ae [virtiofs]
>     [<00000000f8aca419>] virtio_dev_probe+0x15f/0x210
>     [<000000004d6baf3c>] really_probe+0xea/0x430
>     [<00000000a6ceeac8>] device_driver_attach+0xa8/0xb0
>     [<00000000196f47a7>] __driver_attach+0x98/0x140
>     [<000000000b20601d>] bus_for_each_dev+0x7b/0xc0
>     [<00000000399c7b7f>] bus_add_driver+0x11b/0x1f0
>     [<0000000032b09ba7>] driver_register+0x8f/0xe0
>     [<00000000cdd55998>] 0xffffffffa002c013
>     [<000000000ea196a2>] do_one_initcall+0x64/0x2e0
>     [<0000000008f727ce>] do_init_module+0x5c/0x260
>     [<000000003cdedab6>] __do_sys_finit_module+0xb5/0x120
>     [<00000000ad2f48c6>] do_syscall_64+0x33/0x40
>     [<00000000809526b5>] entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Luis Henriques <lhenriques@suse.de>

Hi Luis,

Thanks for the report and the fix. So looks like leak is happening
because we are not doing kfree(fs->vqs) in error path.

> ---
>  fs/fuse/virtio_fs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
> index 8868ac31a3c0..4e6ef9f24e84 100644
> --- a/fs/fuse/virtio_fs.c
> +++ b/fs/fuse/virtio_fs.c
> @@ -899,7 +899,7 @@ static int virtio_fs_probe(struct virtio_device *vdev)
>  
>  out:
>  	vdev->priv = NULL;
> -	kfree(fs);
> +	virtio_fs_put(fs);

[ CC virtio-fs list ]

fs object is not fully formed. So calling virtio_fs_put() is little odd.
I will expect it to be called if somebody takes a reference using _get()
or in the final virtio_fs_remove() when creation reference should go
away.

How about open coding it and free fs->vqs explicitly. Something like
as follows.

@@ -896,7 +896,7 @@ static int virtio_fs_probe(struct virtio
 out_vqs:
        vdev->config->reset(vdev);
        virtio_fs_cleanup_vqs(vdev, fs);
-
+       kfree(fs->vqs);
 out:
        vdev->priv = NULL;
        kfree(fs);

Thanks
Vivek

