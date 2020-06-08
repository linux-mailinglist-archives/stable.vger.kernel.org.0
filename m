Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF5B61F2D05
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:30:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728862AbgFIAaQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:30:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:37070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730119AbgFHXPz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:15:55 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ACE242076A;
        Mon,  8 Jun 2020 23:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658154;
        bh=RyU8bCmCzVxSV2P47dF/Ddb+fy18hma9gz8vKz6FU4k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i9/1dbXIPdp39E9OwOyyPDCNsWx1RMQtvSu4w8JY168NaNjgKA7aGG3jocoAtfWyI
         BI12xEQxIl+fdlB13lw2LzoNUV9qwQRDMcRINzhHaD9iW31bse4zkdzp5eD9jnvDES
         ax7s4S5MTgb3aJWWj4BtGdTquH+0RtmvgX7BYP5s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-nvdimm@lists.01.org
Subject: [PATCH AUTOSEL 5.6 186/606] device-dax: don't leak kernel memory to user space after unloading kmem
Date:   Mon,  8 Jun 2020 19:05:11 -0400
Message-Id: <20200608231211.3363633-186-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Hildenbrand <david@redhat.com>

commit 60858c00e5f018eda711a3aa84cf62214ef62d61 upstream.

Assume we have kmem configured and loaded:

  [root@localhost ~]# cat /proc/iomem
  ...
  140000000-33fffffff : Persistent Memory$
    140000000-1481fffff : namespace0.0
    150000000-33fffffff : dax0.0
      150000000-33fffffff : System RAM

Assume we try to unload kmem. This force-unloading will work, even if
memory cannot get removed from the system.

  [root@localhost ~]# rmmod kmem
  [   86.380228] removing memory fails, because memory [0x0000000150000000-0x0000000157ffffff] is onlined
  ...
  [   86.431225] kmem dax0.0: DAX region [mem 0x150000000-0x33fffffff] cannot be hotremoved until the next reboot

Now, we can reconfigure the namespace:

  [root@localhost ~]# ndctl create-namespace --force --reconfig=namespace0.0 --mode=devdax
  [  131.409351] nd_pmem namespace0.0: could not reserve region [mem 0x140000000-0x33fffffff]dax
  [  131.410147] nd_pmem: probe of namespace0.0 failed with error -16namespace0.0 --mode=devdax
  ...

This fails as expected due to the busy memory resource, and the memory
cannot be used.  However, the dax0.0 device is removed, and along its
name.

The name of the memory resource now points at freed memory (name of the
device):

  [root@localhost ~]# cat /proc/iomem
  ...
  140000000-33fffffff : Persistent Memory
    140000000-1481fffff : namespace0.0
    150000000-33fffffff : �_�^7_��/_��wR��WQ���^��� ...
    150000000-33fffffff : System RAM

We have to make sure to duplicate the string.  While at it, remove the
superfluous setting of the name and fixup a stale comment.

Fixes: 9f960da72b25 ("device-dax: "Hotremove" persistent memory that is used like normal RAM")
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: <stable@vger.kernel.org>	[5.3]
Link: http://lkml.kernel.org/r/20200508084217.9160-2-david@redhat.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dax/kmem.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index 3d0a7e702c94..1e678bdf5aed 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -22,6 +22,7 @@ int dev_dax_kmem_probe(struct device *dev)
 	resource_size_t kmem_size;
 	resource_size_t kmem_end;
 	struct resource *new_res;
+	const char *new_res_name;
 	int numa_node;
 	int rc;
 
@@ -48,11 +49,16 @@ int dev_dax_kmem_probe(struct device *dev)
 	kmem_size &= ~(memory_block_size_bytes() - 1);
 	kmem_end = kmem_start + kmem_size;
 
-	/* Region is permanently reserved.  Hot-remove not yet implemented. */
-	new_res = request_mem_region(kmem_start, kmem_size, dev_name(dev));
+	new_res_name = kstrdup(dev_name(dev), GFP_KERNEL);
+	if (!new_res_name)
+		return -ENOMEM;
+
+	/* Region is permanently reserved if hotremove fails. */
+	new_res = request_mem_region(kmem_start, kmem_size, new_res_name);
 	if (!new_res) {
 		dev_warn(dev, "could not reserve region [%pa-%pa]\n",
 			 &kmem_start, &kmem_end);
+		kfree(new_res_name);
 		return -EBUSY;
 	}
 
@@ -63,12 +69,12 @@ int dev_dax_kmem_probe(struct device *dev)
 	 * unknown to us that will break add_memory() below.
 	 */
 	new_res->flags = IORESOURCE_SYSTEM_RAM;
-	new_res->name = dev_name(dev);
 
 	rc = add_memory(numa_node, new_res->start, resource_size(new_res));
 	if (rc) {
 		release_resource(new_res);
 		kfree(new_res);
+		kfree(new_res_name);
 		return rc;
 	}
 	dev_dax->dax_kmem_res = new_res;
@@ -83,6 +89,7 @@ static int dev_dax_kmem_remove(struct device *dev)
 	struct resource *res = dev_dax->dax_kmem_res;
 	resource_size_t kmem_start = res->start;
 	resource_size_t kmem_size = resource_size(res);
+	const char *res_name = res->name;
 	int rc;
 
 	/*
@@ -102,6 +109,7 @@ static int dev_dax_kmem_remove(struct device *dev)
 	/* Release and free dax resources */
 	release_resource(res);
 	kfree(res);
+	kfree(res_name);
 	dev_dax->dax_kmem_res = NULL;
 
 	return 0;
-- 
2.25.1

