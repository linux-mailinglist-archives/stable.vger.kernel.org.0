Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B88B1E2D69
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403959AbgEZTJx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:09:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:39052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403950AbgEZTJx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:09:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD51520873;
        Tue, 26 May 2020 19:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590520192;
        bh=7IACNEB+1M0tSKpRru+93NDuVZNrVl4F0ZbxYmbGCuc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yqsR9p7O2zu885T+8Yl6Y9mDce6tjqQo6CUR2YrNHOOSGujBL8nbWABgc5IFM02dR
         bh3dnK867ZtVBej8rkfN6YXB0oWKKzmE3acwT6LdWMqfLBAh+mlz/4148HQxk1BrTP
         R3ic1ke0ak/QpRYKQoNTNA2ycEyBygRSYOoI14zI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 094/111] device-dax: dont leak kernel memory to user space after unloading kmem
Date:   Tue, 26 May 2020 20:53:52 +0200
Message-Id: <20200526183941.834174383@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183932.245016380@linuxfoundation.org>
References: <20200526183932.245016380@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
 drivers/dax/kmem.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -22,6 +22,7 @@ int dev_dax_kmem_probe(struct device *de
 	resource_size_t kmem_size;
 	resource_size_t kmem_end;
 	struct resource *new_res;
+	const char *new_res_name;
 	int numa_node;
 	int rc;
 
@@ -48,11 +49,16 @@ int dev_dax_kmem_probe(struct device *de
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
 
@@ -63,12 +69,12 @@ int dev_dax_kmem_probe(struct device *de
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
@@ -83,6 +89,7 @@ static int dev_dax_kmem_remove(struct de
 	struct resource *res = dev_dax->dax_kmem_res;
 	resource_size_t kmem_start = res->start;
 	resource_size_t kmem_size = resource_size(res);
+	const char *res_name = res->name;
 	int rc;
 
 	/*
@@ -102,6 +109,7 @@ static int dev_dax_kmem_remove(struct de
 	/* Release and free dax resources */
 	release_resource(res);
 	kfree(res);
+	kfree(res_name);
 	dev_dax->dax_kmem_res = NULL;
 
 	return 0;


