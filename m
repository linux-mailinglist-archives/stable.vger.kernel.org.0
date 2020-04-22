Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1D951B4218
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbgDVK5t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:57:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:55458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726795AbgDVKEr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:04:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C95D72077D;
        Wed, 22 Apr 2020 10:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587549887;
        bh=oOeR16JP7+33GN5eawThT9fiHBTWNBFySfENnXf8aGU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AX2iHwcOZh/nZ/9uaAQ8KRkYOUGrk+riz1xNNYFWUDMsw1CxWuTed7Z8Ke9NvX8yb
         i6rD+P8KMNWxxWMOo5qKo1sPuJ5E99e/ogjn3vBl6KjLre/wsl2npeoRdXk0+BaY7j
         24d11rUKFyJ6GDGCg85BP7zCn7H4zP4BTUOGaBWM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Harshini Shetty <harshini.x.shetty@sony.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 4.9 046/125] dm verity fec: fix memory leak in verity_fec_dtr
Date:   Wed, 22 Apr 2020 11:56:03 +0200
Message-Id: <20200422095040.979310396@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095032.909124119@linuxfoundation.org>
References: <20200422095032.909124119@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shetty, Harshini X (EXT-Sony Mobile) <Harshini.X.Shetty@sony.com>

commit 75fa601934fda23d2f15bf44b09c2401942d8e15 upstream.

Fix below kmemleak detected in verity_fec_ctr. output_pool is
allocated for each dm-verity-fec device. But it is not freed when
dm-table for the verity target is removed. Hence free the output
mempool in destructor function verity_fec_dtr.

unreferenced object 0xffffffffa574d000 (size 4096):
  comm "init", pid 1667, jiffies 4294894890 (age 307.168s)
  hex dump (first 32 bytes):
    8e 36 00 98 66 a8 0b 9b 00 00 00 00 00 00 00 00  .6..f...........
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<0000000060e82407>] __kmalloc+0x2b4/0x340
    [<00000000dd99488f>] mempool_kmalloc+0x18/0x20
    [<000000002560172b>] mempool_init_node+0x98/0x118
    [<000000006c3574d2>] mempool_init+0x14/0x20
    [<0000000008cb266e>] verity_fec_ctr+0x388/0x3b0
    [<000000000887261b>] verity_ctr+0x87c/0x8d0
    [<000000002b1e1c62>] dm_table_add_target+0x174/0x348
    [<000000002ad89eda>] table_load+0xe4/0x328
    [<000000001f06f5e9>] dm_ctl_ioctl+0x3b4/0x5a0
    [<00000000bee5fbb7>] do_vfs_ioctl+0x5dc/0x928
    [<00000000b475b8f5>] __arm64_sys_ioctl+0x70/0x98
    [<000000005361e2e8>] el0_svc_common+0xa0/0x158
    [<000000001374818f>] el0_svc_handler+0x6c/0x88
    [<000000003364e9f4>] el0_svc+0x8/0xc
    [<000000009d84cec9>] 0xffffffffffffffff

Fixes: a739ff3f543af ("dm verity: add support for forward error correction")
Depends-on: 6f1c819c219f7 ("dm: convert to bioset_init()/mempool_init()")
Cc: stable@vger.kernel.org
Signed-off-by: Harshini Shetty <harshini.x.shetty@sony.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-verity-fec.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -563,6 +563,7 @@ void verity_fec_dtr(struct dm_verity *v)
 	mempool_destroy(f->rs_pool);
 	mempool_destroy(f->prealloc_pool);
 	mempool_destroy(f->extra_pool);
+	mempool_destroy(f->output_pool);
 	kmem_cache_destroy(f->cache);
 
 	if (f->data_bufio)


