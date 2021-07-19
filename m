Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E8483CE19D
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345995AbhGSP0l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:26:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:40472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348122AbhGSPYf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:24:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E927A6144A;
        Mon, 19 Jul 2021 16:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710536;
        bh=V+ll+dQt8QNi9GNrsvJWYWppN539pPpzpPtM/CQLKhM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TiFO8nUrZQlGsNXTdYyUgek2omI8MYftCZIMIIsclhI7s2eqlSyZlQtNmWUKhJiPz
         dU69naoA4ij9v9yYMMYCvAeBpc8J07xl/sQPvD0aIjL5rh25EPS9CTSsPoypejS8Km
         EBdyL+f+9cs/V2P9mzs6mQGq+0QNv4nbSMcI0oGY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.13 014/351] scsi: core: Fix bad pointer dereference when ehandler kthread is invalid
Date:   Mon, 19 Jul 2021 16:49:20 +0200
Message-Id: <20210719144944.999135317@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tyrel Datwyler <tyreld@linux.ibm.com>

commit 93aa71ad7379900e61c8adff6a710a4c18c7c99b upstream.

Commit 66a834d09293 ("scsi: core: Fix error handling of scsi_host_alloc()")
changed the allocation logic to call put_device() to perform host cleanup
with the assumption that IDA removal and stopping the kthread would
properly be performed in scsi_host_dev_release(). However, in the unlikely
case that the error handler thread fails to spawn, shost->ehandler is set
to ERR_PTR(-ENOMEM).

The error handler cleanup code in scsi_host_dev_release() will call
kthread_stop() if shost->ehandler != NULL which will always be the case
whether the kthread was successfully spawned or not. In the case that it
failed to spawn this has the nasty side effect of trying to dereference an
invalid pointer when kthread_stop() is called. The following splat provides
an example of this behavior in the wild:

scsi host11: error handler thread failed to spawn, error = -4
Kernel attempted to read user page (10c) - exploit attempt? (uid: 0)
BUG: Kernel NULL pointer dereference on read at 0x0000010c
Faulting instruction address: 0xc00000000818e9a8
Oops: Kernel access of bad area, sig: 11 [#1]
LE PAGE_SIZE=64K MMU=Hash SMP NR_CPUS=2048 NUMA pSeries
Modules linked in: ibmvscsi(+) scsi_transport_srp dm_multipath dm_mirror dm_region
 hash dm_log dm_mod fuse overlay squashfs loop
CPU: 12 PID: 274 Comm: systemd-udevd Not tainted 5.13.0-rc7 #1
NIP:  c00000000818e9a8 LR: c0000000089846e8 CTR: 0000000000007ee8
REGS: c000000037d12ea0 TRAP: 0300   Not tainted  (5.13.0-rc7)
MSR:  800000000280b033 &lt;SF,VEC,VSX,EE,FP,ME,IR,DR,RI,LE&gt;  CR: 28228228
XER: 20040001
CFAR: c0000000089846e4 DAR: 000000000000010c DSISR: 40000000 IRQMASK: 0
GPR00: c0000000089846e8 c000000037d13140 c000000009cc1100 fffffffffffffffc
GPR04: 0000000000000001 0000000000000000 0000000000000000 c000000037dc0000
GPR08: 0000000000000000 c000000037dc0000 0000000000000001 00000000fffff7ff
GPR12: 0000000000008000 c00000000a049000 c000000037d13d00 000000011134d5a0
GPR16: 0000000000001740 c0080000190d0000 c0080000190d1740 c000000009129288
GPR20: c000000037d13bc0 0000000000000001 c000000037d13bc0 c0080000190b7898
GPR24: c0080000190b7708 0000000000000000 c000000033bb2c48 0000000000000000
GPR28: c000000046b28280 0000000000000000 000000000000010c fffffffffffffffc
NIP [c00000000818e9a8] kthread_stop+0x38/0x230
LR [c0000000089846e8] scsi_host_dev_release+0x98/0x160
Call Trace:
[c000000033bb2c48] 0xc000000033bb2c48 (unreliable)
[c0000000089846e8] scsi_host_dev_release+0x98/0x160
[c00000000891e960] device_release+0x60/0x100
[c0000000087e55c4] kobject_release+0x84/0x210
[c00000000891ec78] put_device+0x28/0x40
[c000000008984ea4] scsi_host_alloc+0x314/0x430
[c0080000190b38bc] ibmvscsi_probe+0x54/0xad0 [ibmvscsi]
[c000000008110104] vio_bus_probe+0xa4/0x4b0
[c00000000892a860] really_probe+0x140/0x680
[c00000000892aefc] driver_probe_device+0x15c/0x200
[c00000000892b63c] device_driver_attach+0xcc/0xe0
[c00000000892b740] __driver_attach+0xf0/0x200
[c000000008926f28] bus_for_each_dev+0xa8/0x130
[c000000008929ce4] driver_attach+0x34/0x50
[c000000008928fc0] bus_add_driver+0x1b0/0x300
[c00000000892c798] driver_register+0x98/0x1a0
[c00000000810eb60] __vio_register_driver+0x80/0xe0
[c0080000190b4a30] ibmvscsi_module_init+0x9c/0xdc [ibmvscsi]
[c0000000080121d0] do_one_initcall+0x60/0x2d0
[c000000008261abc] do_init_module+0x7c/0x320
[c000000008265700] load_module+0x2350/0x25b0
[c000000008265cb4] __do_sys_finit_module+0xd4/0x160
[c000000008031110] system_call_exception+0x150/0x2d0
[c00000000800d35c] system_call_common+0xec/0x278

Fix this be nulling shost->ehandler when the kthread fails to spawn.

Link: https://lore.kernel.org/r/20210701195659.3185475-1-tyreld@linux.ibm.com
Fixes: 66a834d09293 ("scsi: core: Fix error handling of scsi_host_alloc()")
Cc: stable@vger.kernel.org
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/hosts.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -485,6 +485,7 @@ struct Scsi_Host *scsi_host_alloc(struct
 		shost_printk(KERN_WARNING, shost,
 			"error handler thread failed to spawn, error = %ld\n",
 			PTR_ERR(shost->ehandler));
+		shost->ehandler = NULL;
 		goto fail;
 	}
 


