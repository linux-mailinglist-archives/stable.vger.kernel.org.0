Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 792DA171BA8
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:04:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387581AbgB0OEY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:04:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:40608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387578AbgB0OEY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:04:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E038E20578;
        Thu, 27 Feb 2020 14:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812263;
        bh=eX3CCKJI3h6JY/7HDQXOo9dHoGft1PhSOYahbKrWMz0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LpMDba0exa/3Z3CbBUZ8TzkPd/8BgaGLQ7bUDh0j0Nn3h44Mk2OQft3ch67fSHUl4
         ySg0oZMXy1cKtqTer6ud7hjTDr310nTHgmwSt8EDA78h3PcAhsI2Ue74yUT/xxP9F4
         ACCgd+0X6qBvVEYlcJxWfn/BMppjVPFIBKuL3420=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>,
        Logan Gunthorpe <logang@deltatee.com>,
        Keith Busch <kbusch@kernel.org>
Subject: [PATCH 4.19 47/97] nvme-multipath: Fix memory leak with ana_log_buf
Date:   Thu, 27 Feb 2020 14:36:55 +0100
Message-Id: <20200227132222.273136212@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132214.553656188@linuxfoundation.org>
References: <20200227132214.553656188@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Logan Gunthorpe <logang@deltatee.com>

commit 3b7830904e17202524bad1974505a9bfc718d31f upstream.

kmemleak reports a memory leak with the ana_log_buf allocated by
nvme_mpath_init():

unreferenced object 0xffff888120e94000 (size 8208):
  comm "nvme", pid 6884, jiffies 4295020435 (age 78786.312s)
    hex dump (first 32 bytes):
      00 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00  ................
      01 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00  ................
    backtrace:
      [<00000000e2360188>] kmalloc_order+0x97/0xc0
      [<0000000079b18dd4>] kmalloc_order_trace+0x24/0x100
      [<00000000f50c0406>] __kmalloc+0x24c/0x2d0
      [<00000000f31a10b9>] nvme_mpath_init+0x23c/0x2b0
      [<000000005802589e>] nvme_init_identify+0x75f/0x1600
      [<0000000058ef911b>] nvme_loop_configure_admin_queue+0x26d/0x280
      [<00000000673774b9>] nvme_loop_create_ctrl+0x2a7/0x710
      [<00000000f1c7a233>] nvmf_dev_write+0xc66/0x10b9
      [<000000004199f8d0>] __vfs_write+0x50/0xa0
      [<0000000065466fef>] vfs_write+0xf3/0x280
      [<00000000b0db9a8b>] ksys_write+0xc6/0x160
      [<0000000082156b91>] __x64_sys_write+0x43/0x50
      [<00000000c34fbb6d>] do_syscall_64+0x77/0x2f0
      [<00000000bbc574c9>] entry_SYSCALL_64_after_hwframe+0x49/0xbe

nvme_mpath_init() is called by nvme_init_identify() which is called in
multiple places (nvme_reset_work(), nvme_passthru_end(), etc). This
means nvme_mpath_init() may be called multiple times before
nvme_mpath_uninit() (which is only called on nvme_free_ctrl()).

When nvme_mpath_init() is called multiple times, it overwrites the
ana_log_buf pointer with a new allocation, thus leaking the previous
allocation.

To fix this, free ana_log_buf before allocating a new one.

Fixes: 0d0b660f214dc490 ("nvme: add ANA support")
Cc: <stable@vger.kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/nvme/host/multipath.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -569,6 +569,7 @@ int nvme_mpath_init(struct nvme_ctrl *ct
 	}
 
 	INIT_WORK(&ctrl->ana_work, nvme_ana_work);
+	kfree(ctrl->ana_log_buf);
 	ctrl->ana_log_buf = kmalloc(ctrl->ana_log_size, GFP_KERNEL);
 	if (!ctrl->ana_log_buf) {
 		error = -ENOMEM;


