Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 251873C47CD
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236468AbhGLGfK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:35:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:55532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237109AbhGLGeJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:34:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 56A8961158;
        Mon, 12 Jul 2021 06:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071424;
        bh=V+1jT8dQ4yqVyUYSiGrM5IoWp0DqNd8wD2MMeZNawdE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mq7meqjxd8EIf2G7ZlvPwgESp0zOk2x6SUrK110kMtx2Q6ci+7nBOiPcvbAfM0qP6
         2PK+JRZ0OVNruY4FFL/HkhB8RPg6Vthqwo8QTnUR5/5OEWbJzhxqo+Z5bEnS4doDBD
         dT3kFXSzfAKq7f2cQqPfR2aAKukE6ycuGzV+t2Sg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jiantao Zhang <water.zhangjiantao@huawei.com>,
        Tao Xue <xuetao09@huawei.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.10 026/593] xhci: solve a double free problem while doing s4
Date:   Mon, 12 Jul 2021 08:03:06 +0200
Message-Id: <20210712060846.062008987@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhangjiantao (Kirin, nanjing) <water.zhangjiantao@huawei.com>

commit b31d9d6d7abbf6483b871b6370bc31c930d53f54 upstream.

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
Link: https://lore.kernel.org/r/20210617150354.1512157-5-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci-mem.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -1938,6 +1938,7 @@ no_bw:
 	xhci->hw_ports = NULL;
 	xhci->rh_bw = NULL;
 	xhci->ext_caps = NULL;
+	xhci->port_caps = NULL;
 
 	xhci->page_size = 0;
 	xhci->page_shift = 0;


