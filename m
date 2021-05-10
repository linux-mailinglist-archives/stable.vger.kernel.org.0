Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 125203782C9
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:37:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231147AbhEJKiC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:38:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:40904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232047AbhEJKfy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:35:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B090461626;
        Mon, 10 May 2021 10:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642543;
        bh=/LogAFM6LnjxbranjfGc8t6rHE8tXrgUBthEQ/zuHOU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E6rFVFXg7ptyi13ItJqvyv5m6d4qfkagJp94fzGtTmJxaJHEwUtIzrqSHBpHgaobK
         AxZjRkVukf4ziEcQIpCS0LHrRsh+3wv4rdP0sXc3MJTj4rDm2tcuYb7fEJTx41Jp2w
         i7xebVLjjq4Eg7cDuuQDs8Bx4r4EGXlcysWGtuzc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luis Henriques <lhenriques@suse.de>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.4 138/184] virtiofs: fix memory leak in virtio_fs_probe()
Date:   Mon, 10 May 2021 12:20:32 +0200
Message-Id: <20210510101954.673106194@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510101950.200777181@linuxfoundation.org>
References: <20210510101950.200777181@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luis Henriques <lhenriques@suse.de>

commit c79c5e0178922a9e092ec8fed026750f39dcaef4 upstream.

When accidentally passing twice the same tag to qemu, kmemleak ended up
reporting a memory leak in virtiofs.  Also, looking at the log I saw the
following error (that's when I realised the duplicated tag):

  virtiofs: probe of virtio5 failed with error -17

Here's the kmemleak log for reference:

unreferenced object 0xffff888103d47800 (size 1024):
  comm "systemd-udevd", pid 118, jiffies 4294893780 (age 18.340s)
  hex dump (first 32 bytes):
    00 00 00 00 ad 4e ad de ff ff ff ff 00 00 00 00  .....N..........
    ff ff ff ff ff ff ff ff 80 90 02 a0 ff ff ff ff  ................
  backtrace:
    [<000000000ebb87c1>] virtio_fs_probe+0x171/0x7ae [virtiofs]
    [<00000000f8aca419>] virtio_dev_probe+0x15f/0x210
    [<000000004d6baf3c>] really_probe+0xea/0x430
    [<00000000a6ceeac8>] device_driver_attach+0xa8/0xb0
    [<00000000196f47a7>] __driver_attach+0x98/0x140
    [<000000000b20601d>] bus_for_each_dev+0x7b/0xc0
    [<00000000399c7b7f>] bus_add_driver+0x11b/0x1f0
    [<0000000032b09ba7>] driver_register+0x8f/0xe0
    [<00000000cdd55998>] 0xffffffffa002c013
    [<000000000ea196a2>] do_one_initcall+0x64/0x2e0
    [<0000000008f727ce>] do_init_module+0x5c/0x260
    [<000000003cdedab6>] __do_sys_finit_module+0xb5/0x120
    [<00000000ad2f48c6>] do_syscall_64+0x33/0x40
    [<00000000809526b5>] entry_SYSCALL_64_after_hwframe+0x44/0xae

Cc: stable@vger.kernel.org
Signed-off-by: Luis Henriques <lhenriques@suse.de>
Fixes: a62a8ef9d97d ("virtio-fs: add virtiofs filesystem")
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Reviewed-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/virtio_fs.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -667,6 +667,7 @@ static int virtio_fs_probe(struct virtio
 out_vqs:
 	vdev->config->reset(vdev);
 	virtio_fs_cleanup_vqs(vdev, fs);
+	kfree(fs->vqs);
 
 out:
 	vdev->priv = NULL;


