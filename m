Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CCE024BD8F
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728567AbgHTNIL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 09:08:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:55194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728859AbgHTJiD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:38:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1AB232075E;
        Thu, 20 Aug 2020 09:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916282;
        bh=ltJ5tqzl5xTAw1Q3d6H/ysI2soWO+ei/2sz/UUryBEo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=116dFOSKu9WByi0sREXRBwg6+YuCJmzOD5560+1ZiXjubzgc/UuEq23x+iZZKyCVp
         1XTOP0ATACSjKSG31bltEe9R6ZXFtjDHjsuuyUD+1mXHasB+FT3To7u3WedsZvD8Iz
         I10WW8NZmeK07CqIetK2jaKcGzWBLGjo0MEX1eN8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jia He <justin.he@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        Michal Hocko <mhocko@suse.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Andy Lutomirski <luto@kernel.org>, Baoquan He <bhe@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Chuhong Yuan <hslester96@gmail.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jonathan Cameron <Jonathan.Cameron@Huawei.com>,
        Kaly Xin <Kaly.Xin@arm.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Rich Felker <dalias@libc.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Will Deacon <will@kernel.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.7 075/204] mm/memory_hotplug: fix unpaired mem_hotplug_begin/done
Date:   Thu, 20 Aug 2020 11:19:32 +0200
Message-Id: <20200820091610.097233723@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091606.194320503@linuxfoundation.org>
References: <20200820091606.194320503@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jia He <justin.he@arm.com>

commit b4223a510e2ab1bf0f971d50af7c1431014b25ad upstream.

When check_memblock_offlined_cb() returns failed rc(e.g. the memblock is
online at that time), mem_hotplug_begin/done is unpaired in such case.

Therefore a warning:
 Call Trace:
  percpu_up_write+0x33/0x40
  try_remove_memory+0x66/0x120
  ? _cond_resched+0x19/0x30
  remove_memory+0x2b/0x40
  dev_dax_kmem_remove+0x36/0x72 [kmem]
  device_release_driver_internal+0xf0/0x1c0
  device_release_driver+0x12/0x20
  bus_remove_device+0xe1/0x150
  device_del+0x17b/0x3e0
  unregister_dev_dax+0x29/0x60
  devm_action_release+0x15/0x20
  release_nodes+0x19a/0x1e0
  devres_release_all+0x3f/0x50
  device_release_driver_internal+0x100/0x1c0
  driver_detach+0x4c/0x8f
  bus_remove_driver+0x5c/0xd0
  driver_unregister+0x31/0x50
  dax_pmem_exit+0x10/0xfe0 [dax_pmem]

Fixes: f1037ec0cc8a ("mm/memory_hotplug: fix remove_memory() lockdep splat")
Signed-off-by: Jia He <justin.he@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Dan Williams <dan.j.williams@intel.com>
Cc: <stable@vger.kernel.org>	[5.6+]
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chuhong Yuan <hslester96@gmail.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
Cc: Kaly Xin <Kaly.Xin@arm.com>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rich Felker <dalias@libc.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Link: http://lkml.kernel.org/r/20200710031619.18762-3-justin.he@arm.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/memory_hotplug.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1745,7 +1745,7 @@ static int __ref try_remove_memory(int n
 	 */
 	rc = walk_memory_blocks(start, size, NULL, check_memblock_offlined_cb);
 	if (rc)
-		goto done;
+		return rc;
 
 	/* remove memmap entry */
 	firmware_map_remove(start, start + size, "System RAM");
@@ -1765,9 +1765,8 @@ static int __ref try_remove_memory(int n
 
 	try_offline_node(nid);
 
-done:
 	mem_hotplug_done();
-	return rc;
+	return 0;
 }
 
 /**


