Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4BC233DA0A
	for <lists+stable@lfdr.de>; Tue, 16 Mar 2021 18:02:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236981AbhCPRBc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 13:01:32 -0400
Received: from mx2.suse.de ([195.135.220.15]:33794 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237145AbhCPRBY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 13:01:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 11A0EAC24;
        Tue, 16 Mar 2021 17:01:23 +0000 (UTC)
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id 77c30980;
        Tue, 16 Mar 2021 17:02:37 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.de>
To:     Vivek Goyal <vgoyal@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>
Cc:     virtualization@lists.linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Luis Henriques <lhenriques@suse.de>, stable@vger.kernel.org
Subject: [PATCH] virtiofs: fix memory leak in virtio_fs_probe()
Date:   Tue, 16 Mar 2021 17:02:34 +0000
Message-Id: <20210316170234.21736-1-lhenriques@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 fs/fuse/virtio_fs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index 8868ac31a3c0..4e6ef9f24e84 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -899,7 +899,7 @@ static int virtio_fs_probe(struct virtio_device *vdev)
 
 out:
 	vdev->priv = NULL;
-	kfree(fs);
+	virtio_fs_put(fs);
 	return ret;
 }
 
