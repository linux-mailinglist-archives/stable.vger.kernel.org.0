Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10DD420172F
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389255AbgFSQfY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:35:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:42646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389262AbgFSOtz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:49:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 196F52158C;
        Fri, 19 Jun 2020 14:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578194;
        bh=KeY8v4RJ7yN+WDz+J0DVALBSxCJOqAb2txDykQhp+Vw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GlxEwThBJmzW7LE4SO6aozeBcJEbu1bXNub5PqKAHiur6OE36Fg8sXYtoRhJVpxxS
         qmdS/E2K3Wu+o/VKdNIbzhyG8AWvLVaKOK4a0Zbi/VUPvGP/qvimdQkoAOkVqDfdm1
         7yzSuw06a8C/wDcMpbbodFFsongc+ZGaErlINDo0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kexec@lists.infradead.org,
        Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2@marvell.com,
        Manish Chopra <manishc@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Bhupesh Sharma <bhsharma@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 119/190] net: qed*: Reduce RX and TX default ring count when running inside kdump kernel
Date:   Fri, 19 Jun 2020 16:32:44 +0200
Message-Id: <20200619141639.584026001@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141633.446429600@linuxfoundation.org>
References: <20200619141633.446429600@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bhupesh Sharma <bhsharma@redhat.com>

[ Upstream commit 73e030977f7884dbe1be0018bab517e8d02760f8 ]

Normally kdump kernel(s) run under severe memory constraint with the
basic idea being to save the crashdump vmcore reliably when the primary
kernel panics/hangs.

Currently the qed* ethernet driver ends up consuming a lot of memory in
the kdump kernel, leading to kdump kernel panic when one tries to save
the vmcore via ssh/nfs (thus utilizing the services of the underlying
qed* network interfaces).

An example OOM message log seen in the kdump kernel can be seen here
[1], with crashkernel size reservation of 512M.

Using tools like memstrack (see [2]), we can track the modules taking up
the bulk of memory in the kdump kernel and organize the memory usage
output as per 'highest allocator first'. An example log for the OOM case
indicates that the qed* modules end up allocating approximately 216M
memory, which is a large part of the total crashkernel size:

 dracut-pre-pivot[676]: ======== Report format module_summary: ========
 dracut-pre-pivot[676]: Module qed using 149.6MB (2394 pages), peak allocation 149.6MB (2394 pages)
 dracut-pre-pivot[676]: Module qede using 65.3MB (1045 pages), peak allocation 65.3MB (1045 pages)

This patch reduces the default RX and TX ring count from 1024 to 64
when running inside kdump kernel, which leads to a significant memory
saving.

An example log with the patch applied shows the reduced memory
allocation in the kdump kernel:
 dracut-pre-pivot[674]: ======== Report format module_summary: ========
 dracut-pre-pivot[674]: Module qed using 141.8MB (2268 pages), peak allocation 141.8MB (2268 pages)
 <..snip..>
[dracut-pre-pivot[674]: Module qede using 4.8MB (76 pages), peak allocation 4.9MB (78 pages)

Tested crashdump vmcore save via ssh/nfs protocol using underlying qed*
network interface after applying this patch.

[1] OOM log:
------------

 kworker/0:6: page allocation failure: order:6,
 mode:0x60c0c0(GFP_KERNEL|__GFP_COMP|__GFP_ZERO), nodemask=(null)
 kworker/0:6 cpuset=/ mems_allowed=0
 CPU: 0 PID: 145 Comm: kworker/0:6 Not tainted 4.18.0-109.el8.aarch64 #1
 Hardware name: To be filled by O.E.M. Saber/Saber, BIOS 0ACKL025
 01/18/2019
 Workqueue: events work_for_cpu_fn
 Call trace:
  dump_backtrace+0x0/0x188
  show_stack+0x24/0x30
  dump_stack+0x90/0xb4
  warn_alloc+0xf4/0x178
  __alloc_pages_nodemask+0xcac/0xd58
  alloc_pages_current+0x8c/0xf8
  kmalloc_order_trace+0x38/0x108
  qed_iov_alloc+0x40/0x248 [qed]
  qed_resc_alloc+0x224/0x518 [qed]
  qed_slowpath_start+0x254/0x928 [qed]
   __qede_probe+0xf8/0x5e0 [qede]
  qede_probe+0x68/0xd8 [qede]
  local_pci_probe+0x44/0xa8
  work_for_cpu_fn+0x20/0x30
  process_one_work+0x1ac/0x3e8
  worker_thread+0x44/0x448
  kthread+0x130/0x138
  ret_from_fork+0x10/0x18
  Cannot start slowpath
  qede: probe of 0000:05:00.1 failed with error -12

[2]. Memstrack tool: https://github.com/ryncsn/memstrack

Cc: kexec@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: Ariel Elior <aelior@marvell.com>
Cc: GR-everest-linux-l2@marvell.com
Cc: Manish Chopra <manishc@marvell.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Bhupesh Sharma <bhsharma@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qede/qede.h      |  2 ++
 drivers/net/ethernet/qlogic/qede/qede_main.c | 11 +++++++++--
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede.h b/drivers/net/ethernet/qlogic/qede/qede.h
index a80531b5aecc..c132b08cefde 100644
--- a/drivers/net/ethernet/qlogic/qede/qede.h
+++ b/drivers/net/ethernet/qlogic/qede/qede.h
@@ -528,12 +528,14 @@ void qede_update_rx_prod(struct qede_dev *edev, struct qede_rx_queue *rxq);
 #define RX_RING_SIZE		((u16)BIT(RX_RING_SIZE_POW))
 #define NUM_RX_BDS_MAX		(RX_RING_SIZE - 1)
 #define NUM_RX_BDS_MIN		128
+#define NUM_RX_BDS_KDUMP_MIN	63
 #define NUM_RX_BDS_DEF		((u16)BIT(10) - 1)
 
 #define TX_RING_SIZE_POW	13
 #define TX_RING_SIZE		((u16)BIT(TX_RING_SIZE_POW))
 #define NUM_TX_BDS_MAX		(TX_RING_SIZE - 1)
 #define NUM_TX_BDS_MIN		128
+#define NUM_TX_BDS_KDUMP_MIN	63
 #define NUM_TX_BDS_DEF		NUM_TX_BDS_MAX
 
 #define QEDE_MIN_PKT_LEN		64
diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index dab202f343c6..8bb734486bf3 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -29,6 +29,7 @@
  * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  * SOFTWARE.
  */
+#include <linux/crash_dump.h>
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/version.h>
@@ -624,8 +625,14 @@ static struct qede_dev *qede_alloc_etherdev(struct qed_dev *cdev,
 	edev->dp_module = dp_module;
 	edev->dp_level = dp_level;
 	edev->ops = qed_ops;
-	edev->q_num_rx_buffers = NUM_RX_BDS_DEF;
-	edev->q_num_tx_buffers = NUM_TX_BDS_DEF;
+
+	if (is_kdump_kernel()) {
+		edev->q_num_rx_buffers = NUM_RX_BDS_KDUMP_MIN;
+		edev->q_num_tx_buffers = NUM_TX_BDS_KDUMP_MIN;
+	} else {
+		edev->q_num_rx_buffers = NUM_RX_BDS_DEF;
+		edev->q_num_tx_buffers = NUM_TX_BDS_DEF;
+	}
 
 	DP_INFO(edev, "Allocated netdev with %d tx queues and %d rx queues\n",
 		info->num_queues, info->num_queues);
-- 
2.25.1



