Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3928119446A
	for <lists+stable@lfdr.de>; Thu, 26 Mar 2020 17:38:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728479AbgCZQiL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Mar 2020 12:38:11 -0400
Received: from mga03.intel.com ([134.134.136.65]:60687 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728466AbgCZQiL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Mar 2020 12:38:11 -0400
IronPort-SDR: 9sjhlLCWP2DMddv6l6qYIdOMt1MKO9Ip647cMfyEbIrXVijUTyfQKoZn94ooY5dGgVaszw7l4c
 5ifsFWUen0AA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2020 09:38:10 -0700
IronPort-SDR: EHKqFC6CjE3V7XlYPP7FNdfHfXjSMoHMqgwWne15AkBnAP3dzhcrQViuWMpwfBraOknDm4P7PK
 rdNxG3mxjl3w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,309,1580803200"; 
   d="scan'208";a="240723731"
Received: from sedona.ch.intel.com ([10.2.136.157])
  by fmsmga008.fm.intel.com with ESMTP; 26 Mar 2020 09:38:09 -0700
Received: from awfm-01.aw.intel.com (awfm-01.aw.intel.com [10.228.212.213])
        by sedona.ch.intel.com (8.14.3/8.14.3/Standard MailSET/Hub) with ESMTP id 02QGc97R004629;
        Thu, 26 Mar 2020 09:38:09 -0700
Received: from awfm-01.aw.intel.com (localhost [127.0.0.1])
        by awfm-01.aw.intel.com (8.14.7/8.14.7) with ESMTP id 02QGc7jT021328;
        Thu, 26 Mar 2020 12:38:07 -0400
Subject: [PATCH for-rc 1/2] IB/hfi1: Fix memory leaks in sysfs registration
 and unregistration
From:   Dennis Dalessandro <dennis.dalessandro@intel.com>
To:     jgg@ziepe.ca, dledford@redhat.com
Cc:     linux-rdma@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        stable@vger.kernel.org, Kaike Wan <kaike.wan@intel.com>
Date:   Thu, 26 Mar 2020 12:38:07 -0400
Message-ID: <20200326163807.21129.27371.stgit@awfm-01.aw.intel.com>
In-Reply-To: <20200326163619.21129.13002.stgit@awfm-01.aw.intel.com>
References: <20200326163619.21129.13002.stgit@awfm-01.aw.intel.com>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kaike Wan <kaike.wan@intel.com>

When the hfi1 driver is unloaded, kmemleak will report the following
issue:

unreferenced object 0xffff8888461a4c08 (size 8):
comm "kworker/0:0", pid 5, jiffies 4298601264 (age 2047.134s)
hex dump (first 8 bytes):
73 64 6d 61 30 00 ff ff sdma0...
backtrace:
[<00000000311a6ef5>] kvasprintf+0x62/0xd0
[<00000000ade94d9f>] kobject_set_name_vargs+0x1c/0x90
[<0000000060657dbb>] kobject_init_and_add+0x5d/0xb0
[<00000000346fe72b>] 0xffffffffa0c5ecba
[<000000006cfc5819>] 0xffffffffa0c866b9
[<0000000031c65580>] 0xffffffffa0c38e87
[<00000000e9739b3f>] local_pci_probe+0x41/0x80
[<000000006c69911d>] work_for_cpu_fn+0x16/0x20
[<00000000601267b5>] process_one_work+0x171/0x380
[<0000000049a0eefa>] worker_thread+0x1d1/0x3f0
[<00000000909cf2b9>] kthread+0xf8/0x130
[<0000000058f5f874>] ret_from_fork+0x35/0x40

This patch fixes the issue by:
- Releasing dd->per_sdma[i].kobject in hfi1_unregister_sysfs().
  - This will fix the memory leak.
- Calling kobject_put() to unwind operations only for those entries in
   dd->per_sdma[] whose operations have succeeded (including the current
   one that has just failed) in hfi1_verbs_register_sysfs().

Fixes: 0cb2aa690c7e ("IB/hfi1: Add sysfs interface for affinity setup")
Cc: <stable@vger.kernel.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Kaike Wan <kaike.wan@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
---
 drivers/infiniband/hw/hfi1/sysfs.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/sysfs.c b/drivers/infiniband/hw/hfi1/sysfs.c
index 90f62c4..f1bcecf 100644
--- a/drivers/infiniband/hw/hfi1/sysfs.c
+++ b/drivers/infiniband/hw/hfi1/sysfs.c
@@ -853,8 +853,13 @@ int hfi1_verbs_register_sysfs(struct hfi1_devdata *dd)
 
 	return 0;
 bail:
-	for (i = 0; i < dd->num_sdma; i++)
-		kobject_del(&dd->per_sdma[i].kobj);
+	/*
+	 * The function kobject_put() will call kobject_del() if the kobject
+	 * has been added successfully. The sysfs files created under the
+	 * kobject directory will also be removed during the process.
+	 */
+	for (; i >= 0; i--)
+		kobject_put(&dd->per_sdma[i].kobj);
 
 	return ret;
 }
@@ -867,6 +872,10 @@ void hfi1_verbs_unregister_sysfs(struct hfi1_devdata *dd)
 	struct hfi1_pportdata *ppd;
 	int i;
 
+	/* Unwind operations in hfi1_verbs_register_sysfs() */
+	for (i = 0; i < dd->num_sdma; i++)
+		kobject_put(&dd->per_sdma[i].kobj);
+
 	for (i = 0; i < dd->num_pports; i++) {
 		ppd = &dd->pport[i];
 

