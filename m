Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 152881A5180
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 14:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728228AbgDKMP7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 08:15:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:50148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728222AbgDKMP7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 08:15:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88EF520787;
        Sat, 11 Apr 2020 12:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586607359;
        bh=9/F1HgN1yJlGKSkllksxsM4rLDTTAM51nN0ITD+mQ4A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Htw6t2qu9PYhmekiuW2t2rdqtu1t83oMGRDWEl3is8X3MZZhFyOqBDEi3Nvg2GcsI
         CgjT6UcmAwuEKIscYfWSFz0ceVvhUPn5NtqBIsvpLiKWRW2+JAY1pbLRvDOK8ZQnK1
         QKqeuiFO/X2Q0UIJDYy7PJZKANDutXQzvi9PiRQ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Kaike Wan <kaike.wan@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 4.19 41/54] IB/hfi1: Fix memory leaks in sysfs registration and unregistration
Date:   Sat, 11 Apr 2020 14:09:23 +0200
Message-Id: <20200411115512.696605410@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200411115508.284500414@linuxfoundation.org>
References: <20200411115508.284500414@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kaike Wan <kaike.wan@intel.com>

commit 5c15abc4328ad696fa61e2f3604918ed0c207755 upstream.

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

Cc: <stable@vger.kernel.org>
Fixes: 0cb2aa690c7e ("IB/hfi1: Add sysfs interface for affinity setup")
Link: https://lore.kernel.org/r/20200326163807.21129.27371.stgit@awfm-01.aw.intel.com
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Kaike Wan <kaike.wan@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/hfi1/sysfs.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/drivers/infiniband/hw/hfi1/sysfs.c
+++ b/drivers/infiniband/hw/hfi1/sysfs.c
@@ -861,8 +861,13 @@ bail:
 	for (i = 0; i < ARRAY_SIZE(hfi1_attributes); ++i)
 		device_remove_file(&dev->dev, hfi1_attributes[i]);
 
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
@@ -875,6 +880,10 @@ void hfi1_verbs_unregister_sysfs(struct
 	struct hfi1_pportdata *ppd;
 	int i;
 
+	/* Unwind operations in hfi1_verbs_register_sysfs() */
+	for (i = 0; i < dd->num_sdma; i++)
+		kobject_put(&dd->per_sdma[i].kobj);
+
 	for (i = 0; i < dd->num_pports; i++) {
 		ppd = &dd->pport[i];
 


