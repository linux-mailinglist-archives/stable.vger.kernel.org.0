Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BED2211DEC
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726371AbfEBPfm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:35:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:50358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728330AbfEBPbS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:31:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05BA8216FD;
        Thu,  2 May 2019 15:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556811077;
        bh=7HXfWF8JYhG/72GZfUXEJYcWrewdH5iBOcy1uX91RHY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ziexXBKflZaDe4cVAHqoEui1xNtZDykoXHWgnX4Q8THnXq9bIXNvUiCkWwtHrsSBD
         XTPenXFWXUrm7LYHPoxYBeOQ4EbHGtCVVaSVNUncKzh6pUTLjvVsWDUihHj8c1cgC1
         zmh/zvLZYMI79Luc9bFp1019Jh4tEWO4V2xarIyA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yi Zhang <yi.zhang@redhat.com>,
        "jianchao.wang" <jianchao.w.wang@oracle.com>,
        Omar Sandoval <osandov@fb.com>, Ming Lei <ming.lei@redhat.com>,
        Jens Axboe <axboe@kernel.dk>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 5.0 064/101] sbitmap: order READ/WRITE freed instance and setting clear bit
Date:   Thu,  2 May 2019 17:21:06 +0200
Message-Id: <20190502143344.154472434@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143339.434882399@linuxfoundation.org>
References: <20190502143339.434882399@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit e6d1fa584e0dd9bfebaf345e9feea588cf75ead2 ]

Inside sbitmap_queue_clear(), once the clear bit is set, it will be
visiable to allocation path immediately. Meantime READ/WRITE on old
associated instance(such as request in case of blk-mq) may be
out-of-order with the setting clear bit, so race with re-allocation
may be triggered.

Adds one memory barrier for ordering READ/WRITE of the freed associated
instance with setting clear bit for avoiding race with re-allocation.

The following kernel oops triggerd by block/006 on aarch64 may be fixed:

[  142.330954] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000330
[  142.338794] Mem abort info:
[  142.341554]   ESR = 0x96000005
[  142.344632]   Exception class = DABT (current EL), IL = 32 bits
[  142.350500]   SET = 0, FnV = 0
[  142.353544]   EA = 0, S1PTW = 0
[  142.356678] Data abort info:
[  142.359528]   ISV = 0, ISS = 0x00000005
[  142.363343]   CM = 0, WnR = 0
[  142.366305] user pgtable: 64k pages, 48-bit VAs, pgdp = 000000002a3c51c0
[  142.372983] [0000000000000330] pgd=0000000000000000, pud=0000000000000000
[  142.379777] Internal error: Oops: 96000005 [#1] SMP
[  142.384613] Modules linked in: null_blk ib_isert iscsi_target_mod ib_srpt target_core_mod ib_srp scsi_transport_srp vfat fat rpcrdma sunrpc rdma_ucm ib_iser rdma_cm iw_cm libiscsi ib_umad scsi_transport_iscsi ib_ipoib ib_cm mlx5_ib ib_uverbs ib_core sbsa_gwdt crct10dif_ce ghash_ce ipmi_ssif sha2_ce ipmi_devintf sha256_arm64 sg sha1_ce ipmi_msghandler ip_tables xfs libcrc32c mlx5_core sdhci_acpi mlxfw ahci_platform at803x sdhci libahci_platform qcom_emac mmc_core hdma hdma_mgmt i2c_dev [last unloaded: null_blk]
[  142.429753] CPU: 7 PID: 1983 Comm: fio Not tainted 5.0.0.cki #2
[  142.449458] pstate: 00400005 (nzcv daif +PAN -UAO)
[  142.454239] pc : __blk_mq_free_request+0x4c/0xa8
[  142.458830] lr : blk_mq_free_request+0xec/0x118
[  142.463344] sp : ffff00003360f6a0
[  142.466646] x29: ffff00003360f6a0 x28: ffff000010e70000
[  142.471941] x27: ffff801729a50048 x26: 0000000000010000
[  142.477232] x25: ffff00003360f954 x24: ffff7bdfff021440
[  142.482529] x23: 0000000000000000 x22: 00000000ffffffff
[  142.487830] x21: ffff801729810000 x20: 0000000000000000
[  142.493123] x19: ffff801729a50000 x18: 0000000000000000
[  142.498413] x17: 0000000000000000 x16: 0000000000000001
[  142.503709] x15: 00000000000000ff x14: ffff7fe000000000
[  142.509003] x13: ffff8017dcde09a0 x12: 0000000000000000
[  142.514308] x11: 0000000000000001 x10: 0000000000000008
[  142.519597] x9 : ffff8017dcde09a0 x8 : 0000000000002000
[  142.524889] x7 : ffff8017dcde0a00 x6 : 000000015388f9be
[  142.530187] x5 : 0000000000000001 x4 : 0000000000000000
[  142.535478] x3 : 0000000000000000 x2 : 0000000000000000
[  142.540777] x1 : 0000000000000001 x0 : ffff00001041b194
[  142.546071] Process fio (pid: 1983, stack limit = 0x000000006460a0ea)
[  142.552500] Call trace:
[  142.554926]  __blk_mq_free_request+0x4c/0xa8
[  142.559181]  blk_mq_free_request+0xec/0x118
[  142.563352]  blk_mq_end_request+0xfc/0x120
[  142.567444]  end_cmd+0x3c/0xa8 [null_blk]
[  142.571434]  null_complete_rq+0x20/0x30 [null_blk]
[  142.576194]  blk_mq_complete_request+0x108/0x148
[  142.580797]  null_handle_cmd+0x1d4/0x718 [null_blk]
[  142.585662]  null_queue_rq+0x60/0xa8 [null_blk]
[  142.590171]  blk_mq_try_issue_directly+0x148/0x280
[  142.594949]  blk_mq_try_issue_list_directly+0x9c/0x108
[  142.600064]  blk_mq_sched_insert_requests+0xb0/0xd0
[  142.604926]  blk_mq_flush_plug_list+0x16c/0x2a0
[  142.609441]  blk_flush_plug_list+0xec/0x118
[  142.613608]  blk_finish_plug+0x3c/0x4c
[  142.617348]  blkdev_direct_IO+0x3b4/0x428
[  142.621336]  generic_file_read_iter+0x84/0x180
[  142.625761]  blkdev_read_iter+0x50/0x78
[  142.629579]  aio_read.isra.6+0xf8/0x190
[  142.633409]  __io_submit_one.isra.8+0x148/0x738
[  142.637912]  io_submit_one.isra.9+0x88/0xb8
[  142.642078]  __arm64_sys_io_submit+0xe0/0x238
[  142.646428]  el0_svc_handler+0xa0/0x128
[  142.650238]  el0_svc+0x8/0xc
[  142.653104] Code: b9402a63 f9000a7f 3100047f 540000a0 (f9419a81)
[  142.659202] ---[ end trace 467586bc175eb09d ]---

Fixes: ea86ea2cdced20057da ("sbitmap: ammortize cost of clearing bits")
Reported-and-bisected_and_tested-by: Yi Zhang <yi.zhang@redhat.com>
Cc: Yi Zhang <yi.zhang@redhat.com>
Cc: "jianchao.wang" <jianchao.w.wang@oracle.com>
Reviewed-by: Omar Sandoval <osandov@fb.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 lib/sbitmap.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/lib/sbitmap.c b/lib/sbitmap.c
index 5b382c1244ed..155fe38756ec 100644
--- a/lib/sbitmap.c
+++ b/lib/sbitmap.c
@@ -591,6 +591,17 @@ EXPORT_SYMBOL_GPL(sbitmap_queue_wake_up);
 void sbitmap_queue_clear(struct sbitmap_queue *sbq, unsigned int nr,
 			 unsigned int cpu)
 {
+	/*
+	 * Once the clear bit is set, the bit may be allocated out.
+	 *
+	 * Orders READ/WRITE on the asssociated instance(such as request
+	 * of blk_mq) by this bit for avoiding race with re-allocation,
+	 * and its pair is the memory barrier implied in __sbitmap_get_word.
+	 *
+	 * One invariant is that the clear bit has to be zero when the bit
+	 * is in use.
+	 */
+	smp_mb__before_atomic();
 	sbitmap_deferred_clear_bit(&sbq->sb, nr);
 
 	/*
-- 
2.19.1



