Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 253034190A
	for <lists+stable@lfdr.de>; Wed, 12 Jun 2019 01:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408209AbfFKXkM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jun 2019 19:40:12 -0400
Received: from mga17.intel.com ([192.55.52.151]:43216 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405380AbfFKXkL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 11 Jun 2019 19:40:11 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Jun 2019 16:40:10 -0700
X-ExtLoop1: 1
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.16])
  by fmsmga005.fm.intel.com with ESMTP; 11 Jun 2019 16:40:10 -0700
Subject: [PATCH 2/6] libnvdimm/bus: Prevent duplicate device_unregister()
 calls
From:   Dan Williams <dan.j.williams@intel.com>
To:     linux-nvdimm@lists.01.org
Cc:     Jane Chu <jane.chu@oracle.com>,
        Erwin Tsaur <erwin.tsaur@oracle.com>, stable@vger.kernel.org,
        peterz@infradead.org, vishal.l.verma@intel.com,
        linux-kernel@vger.kernel.org
Date:   Tue, 11 Jun 2019 16:25:54 -0700
Message-ID: <156029555412.419799.17084493871021141653.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <156029554317.419799.1324389595953183385.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <156029554317.419799.1324389595953183385.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-2-gc94f
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/bus.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index 2dca3034fee0..42713b210f51 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -547,13 +547,38 @@ EXPORT_SYMBOL(nd_device_register);
 
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

