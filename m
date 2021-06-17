Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F02493AB6C7
	for <lists+stable@lfdr.de>; Thu, 17 Jun 2021 17:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233069AbhFQPD7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Jun 2021 11:03:59 -0400
Received: from mga14.intel.com ([192.55.52.115]:4084 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232992AbhFQPD5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Jun 2021 11:03:57 -0400
IronPort-SDR: PgW8vbWx0dOYmwhHmAuaDpqgK1hlDEmDoZYI/Si8YB3O4ie79GWBvzfFqWpIJpEKESH5gcxg3s
 GgFSaP4KfIEw==
X-IronPort-AV: E=McAfee;i="6200,9189,10017"; a="206204845"
X-IronPort-AV: E=Sophos;i="5.83,280,1616482800"; 
   d="scan'208";a="206204845"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2021 08:01:49 -0700
IronPort-SDR: m+D+iwYW9+M+cxiIAwGg0XL2LSOI5Kf4OAb7y4dRZfFuMWBtFi+e+q6tMJaqquw1qeL7U0/lJm
 XkZCtkBLRk0Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,280,1616482800"; 
   d="scan'208";a="479490865"
Received: from mattu-haswell.fi.intel.com ([10.237.72.170])
  by FMSMGA003.fm.intel.com with ESMTP; 17 Jun 2021 08:01:47 -0700
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
To:     <gregkh@linuxfoundation.org>
Cc:     <linux-usb@vger.kernel.org>,
        "Zhangjiantao (Kirin, nanjing)" <water.zhangjiantao@huawei.com>,
        stable@vger.kernel.org, Tao Xue <xuetao09@huawei.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 4/4] xhci: solve a double free problem while doing s4
Date:   Thu, 17 Jun 2021 18:03:54 +0300
Message-Id: <20210617150354.1512157-5-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210617150354.1512157-1-mathias.nyman@linux.intel.com>
References: <20210617150354.1512157-1-mathias.nyman@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Zhangjiantao (Kirin, nanjing)" <water.zhangjiantao@huawei.com>

when system is doing s4, the process of xhci_resume may be as below:
1、xhci_mem_cleanup
2、xhci_init->xhci_mem_init->xhci_mem_cleanup(when memory is not enough).
xhci_mem_cleanup will be executed twice when system is out of memory.
xhci->port_caps is freed in xhci_mem_cleanup,but it isn't set to NULL.
It will be freed twice when xhci_mem_cleanup is called the second time.

We got following bug when system resumes from s4:

kernel BUG at mm/slub.c:309!
Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
CPU: 0 PID: 5929 Tainted: G S   W   5.4.96-arm64-desktop #1
pc : __slab_free+0x5c/0x424
lr : kfree+0x30c/0x32c

Call trace:
 __slab_free+0x5c/0x424
 kfree+0x30c/0x32c
 xhci_mem_cleanup+0x394/0x3cc
 xhci_mem_init+0x9ac/0x1070
 xhci_init+0x8c/0x1d0
 xhci_resume+0x1cc/0x5fc
 xhci_plat_resume+0x64/0x70
 platform_pm_thaw+0x28/0x60
 dpm_run_callback+0x54/0x24c
 device_resume+0xd0/0x200
 async_resume+0x24/0x60
 async_run_entry_fn+0x44/0x110
 process_one_work+0x1f0/0x490
 worker_thread+0x5c/0x450
 kthread+0x158/0x160
 ret_from_fork+0x10/0x24

Original patch that caused this issue was backported to 4.4 stable,
so this should be backported to 4.4 stabe as well.

Fixes: cf0ee7c60c89 ("xhci: Fix memory leak when caching protocol extended capability PSI tables - take 2")
Cc: stable@vger.kernel.org # v4.4+
Signed-off-by: Jiantao Zhang <water.zhangjiantao@huawei.com>
Signed-off-by: Tao Xue <xuetao09@huawei.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci-mem.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index 2f6da35e7977..0e312066c5c6 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -1924,6 +1924,7 @@ void xhci_mem_cleanup(struct xhci_hcd *xhci)
 	xhci->hw_ports = NULL;
 	xhci->rh_bw = NULL;
 	xhci->ext_caps = NULL;
+	xhci->port_caps = NULL;
 
 	xhci->page_size = 0;
 	xhci->page_shift = 0;
-- 
2.25.1

