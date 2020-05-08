Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92C341CA652
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 10:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbgEHImj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 04:42:39 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:31885 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727805AbgEHImi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 May 2020 04:42:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588927356;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HDqdz7vUW07g8cOkfmGPIO8ov0KvSWCkjJFS1FzKfW0=;
        b=KgELIlqoT/Gzay5TM23oNfJiFXsV2VnmItnz92sU7H84Ih2kF35E25ynK+GPOAMtl/yHqI
        +d6DD5nflh7JjjzrsT7iGzI7HRDPYElzhTusKOP7E4tWXMAra6qe0VL9c4VkSFDwWF2I87
        H/m9/jOCpBcfgI3ufnvnEwAlGwjiIKU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-427-tly-VFRPOxOjTHrhhsV3FQ-1; Fri, 08 May 2020 04:42:32 -0400
X-MC-Unique: tly-VFRPOxOjTHrhhsV3FQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 41EEE8018AB;
        Fri,  8 May 2020 08:42:31 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-113-181.ams2.redhat.com [10.36.113.181])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0F93E5C1B0;
        Fri,  8 May 2020 08:42:28 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-mm@kvack.org, linux-nvdimm@lists.01.org,
        kexec@lists.infradead.org, Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        David Hildenbrand <david@redhat.com>, stable@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v4 1/4] device-dax: Don't leak kernel memory to user space after unloading kmem
Date:   Fri,  8 May 2020 10:42:14 +0200
Message-Id: <20200508084217.9160-2-david@redhat.com>
In-Reply-To: <20200508084217.9160-1-david@redhat.com>
References: <20200508084217.9160-1-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
cannot be used. However, the dax0.0 device is removed, and along its name.

The name of the memory resource now points at freed memory (name of the
device).
  [root@localhost ~]# cat /proc/iomem
  ...
  140000000-33fffffff : Persistent Memory
    140000000-1481fffff : namespace0.0
    150000000-33fffffff : �_�^7_��/_��wR��WQ���^��� ...
    150000000-33fffffff : System RAM

We have to make sure to duplicate the string. While at it, remove the
superfluous setting of the name and fixup a stale comment.

Fixes: 9f960da72b25 ("device-dax: "Hotremove" persistent memory that is used like normal RAM")
Cc: stable@vger.kernel.org # v5.3
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: David Hildenbrand <david@redhat.com>
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
2.25.4

