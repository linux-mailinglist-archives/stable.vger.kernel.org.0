Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47A3F86A2D
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 21:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404997AbfHHTIx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 15:08:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:43068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404509AbfHHTIw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 15:08:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D457D2173E;
        Thu,  8 Aug 2019 19:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565291331;
        bh=aBxhkRVwXoJii8tFWAHj3MDQzysyn97ow8IFtXxjJ9I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WSLc9UihNWDMhg+6SAVy75ZbaKQwgYqZoLCGc/3Z6EhSXRiJ6HIRUJmfQ0BwdnixQ
         HdFjSPeTMsBGwnwTAX0S4M4ucC2gpIpLaP32EvYo3g4YfxdipCZCNlWE+3zQZ218fi
         U3UVCMX8uHDjvPr6wVJefhBitR9MUaYGvSCvCf/o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jane Chu <jane.chu@oracle.com>,
        Erwin Tsaur <erwin.tsaur@oracle.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 05/45] libnvdimm/bus: Prevent duplicate device_unregister() calls
Date:   Thu,  8 Aug 2019 21:04:51 +0200
Message-Id: <20190808190454.092926881@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190808190453.827571908@linuxfoundation.org>
References: <20190808190453.827571908@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 8aac0e2338916e273ccbd438a2b7a1e8c61749f5 upstream.

A multithreaded namespace creation/destruction stress test currently
fails with signatures like the following:

    sysfs group 'power' not found for kobject 'dax1.1'
    RIP: 0010:sysfs_remove_group+0x76/0x80
    Call Trace:
     device_del+0x73/0x370
     device_unregister+0x16/0x50
     nd_async_device_unregister+0x1e/0x30 [libnvdimm]
     async_run_entry_fn+0x39/0x160
     process_one_work+0x23c/0x5e0
     worker_thread+0x3c/0x390

    BUG: kernel NULL pointer dereference, address: 0000000000000020
    RIP: 0010:klist_put+0x1b/0x6c
    Call Trace:
     klist_del+0xe/0x10
     device_del+0x8a/0x2c9
     ? __switch_to_asm+0x34/0x70
     ? __switch_to_asm+0x40/0x70
     device_unregister+0x44/0x4f
     nd_async_device_unregister+0x22/0x2d [libnvdimm]
     async_run_entry_fn+0x47/0x15a
     process_one_work+0x1a2/0x2eb
     worker_thread+0x1b8/0x26e

Use the kill_device() helper to atomically resolve the race of multiple
threads issuing kill, device_unregister(), requests.

Reported-by: Jane Chu <jane.chu@oracle.com>
Reported-by: Erwin Tsaur <erwin.tsaur@oracle.com>
Fixes: 4d88a97aa9e8 ("libnvdimm, nvdimm: dimm driver and base libnvdimm device-driver...")
Cc: <stable@vger.kernel.org>
Link: https://github.com/pmem/ndctl/issues/96
Tested-by: Tested-by: Jane Chu <jane.chu@oracle.com>
Link: https://lore.kernel.org/r/156341207846.292348.10435719262819764054.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvdimm/bus.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index ee39e2c1644ae..11cfd23e5aff7 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -528,13 +528,38 @@ EXPORT_SYMBOL(nd_device_register);
 
 void nd_device_unregister(struct device *dev, enum nd_async_mode mode)
 {
+	bool killed;
+
 	switch (mode) {
 	case ND_ASYNC:
+		/*
+		 * In the async case this is being triggered with the
+		 * device lock held and the unregistration work needs to
+		 * be moved out of line iff this is thread has won the
+		 * race to schedule the deletion.
+		 */
+		if (!kill_device(dev))
+			return;
+
 		get_device(dev);
 		async_schedule_domain(nd_async_device_unregister, dev,
 				&nd_async_domain);
 		break;
 	case ND_SYNC:
+		/*
+		 * In the sync case the device is being unregistered due
+		 * to a state change of the parent. Claim the kill state
+		 * to synchronize against other unregistration requests,
+		 * or otherwise let the async path handle it if the
+		 * unregistration was already queued.
+		 */
+		device_lock(dev);
+		killed = kill_device(dev);
+		device_unlock(dev);
+
+		if (!killed)
+			return;
+
 		nd_synchronize();
 		device_unregister(dev);
 		break;
-- 
2.20.1



