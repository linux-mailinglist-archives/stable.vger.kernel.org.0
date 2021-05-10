Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69211378563
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235147AbhEJLAN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:00:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:52212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234130AbhEJKz5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:55:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 734906192F;
        Mon, 10 May 2021 10:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643449;
        bh=2ub5n051EsQOnH9xKRr0nIKieuG9JUyj2Fy7ivBWcgw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vkAb0bBiwF2y4wK9PzkyE4YDK63+qrXCk2Ies72iU3LwPlFlgV9CdlMAlBk7WLRsf
         W3ERuqIKxlVssmpytVWtbKOuB7k3tJBhOP4k3hC7B7l0tTO2LfxAVblfCEFFsAJoWS
         TadMABEhMVkNrlgZT3augspGX4OVvLQ6Dq1RFW6E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Loic Poulain <loic.poulain@linaro.org>,
        Bhaumik Bhatt <bbhatt@codeaurora.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 5.11 005/342] bus: mhi: pci_generic: Remove WQ_MEM_RECLAIM flag from state workqueue
Date:   Mon, 10 May 2021 12:16:35 +0200
Message-Id: <20210510102010.278312471@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Loic Poulain <loic.poulain@linaro.org>

commit 0fccbf0a3b690b162f53b13ed8bc442ea33437dc upstream.

A recent change created a dedicated workqueue for the state-change work
with WQ_HIGHPRI (no strong reason for that) and WQ_MEM_RECLAIM flags,
but the state-change work (mhi_pm_st_worker) does not guarantee forward
progress under memory pressure, and will even wait on various memory
allocations when e.g. creating devices, loading firmware, etc... The
work is then not part of a memory reclaim path...

Moreover, this causes a warning in check_flush_dependency() since we end
up in code that flushes a non-reclaim workqueue:

[   40.969601] workqueue: WQ_MEM_RECLAIM mhi_hiprio_wq:mhi_pm_st_worker [mhi] is flushing !WQ_MEM_RECLAIM events_highpri:flush_backlog
[   40.969612] WARNING: CPU: 4 PID: 158 at kernel/workqueue.c:2607 check_flush_dependency+0x11c/0x140
[   40.969733] Call Trace:
[   40.969740]  __flush_work+0x97/0x1d0
[   40.969745]  ? wake_up_process+0x15/0x20
[   40.969749]  ? insert_work+0x70/0x80
[   40.969750]  ? __queue_work+0x14a/0x3e0
[   40.969753]  flush_work+0x10/0x20
[   40.969756]  rollback_registered_many+0x1c9/0x510
[   40.969759]  unregister_netdevice_queue+0x94/0x120
[   40.969761]  unregister_netdev+0x1d/0x30
[   40.969765]  mhi_net_remove+0x1a/0x40 [mhi_net]
[   40.969770]  mhi_driver_remove+0x124/0x250 [mhi]
[   40.969776]  device_release_driver_internal+0xf0/0x1d0
[   40.969778]  device_release_driver+0x12/0x20
[   40.969782]  bus_remove_device+0xe1/0x150
[   40.969786]  device_del+0x17b/0x3e0
[   40.969791]  mhi_destroy_device+0x9a/0x100 [mhi]
[   40.969796]  ? mhi_unmap_single_use_bb+0x50/0x50 [mhi]
[   40.969799]  device_for_each_child+0x5e/0xa0
[   40.969804]  mhi_pm_st_worker+0x921/0xf50 [mhi]

Fixes: 8f7039787687 ("bus: mhi: core: Move to using high priority workqueue")
Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
Reviewed-by: Bhaumik Bhatt <bbhatt@codeaurora.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/1614161930-8513-1-git-send-email-loic.poulain@linaro.org
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bus/mhi/core/init.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/bus/mhi/core/init.c
+++ b/drivers/bus/mhi/core/init.c
@@ -896,8 +896,7 @@ int mhi_register_controller(struct mhi_c
 	INIT_WORK(&mhi_cntrl->st_worker, mhi_pm_st_worker);
 	init_waitqueue_head(&mhi_cntrl->state_event);
 
-	mhi_cntrl->hiprio_wq = alloc_ordered_workqueue
-				("mhi_hiprio_wq", WQ_MEM_RECLAIM | WQ_HIGHPRI);
+	mhi_cntrl->hiprio_wq = alloc_ordered_workqueue("mhi_hiprio_wq", WQ_HIGHPRI);
 	if (!mhi_cntrl->hiprio_wq) {
 		dev_err(mhi_cntrl->cntrl_dev, "Failed to allocate workqueue\n");
 		ret = -ENOMEM;


