Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 087B614B93E
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:33:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733083AbgA1O3f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:29:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:58180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387507AbgA1O3e (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:29:34 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DAE6A2468F;
        Tue, 28 Jan 2020 14:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221773;
        bh=sbUtdqQ70k6dULsK6EFRiFeRzi1RS4x+BpqnYqMhc9k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ksc02caMglDJVUUtdf8TVqaoWnVLJE9K0vVnGPIFWz/fL9t4NGKYukTN/Tiq7heyQ
         DuteDP/C7zjVDb6p3WDQeFdCoGa4uLyLRJy0ZgohwyefjSWQj5Dh3YveOo1SfWA+yJ
         MMjYVe/nFcueoAyBLJNLe7n56L79HPHwF2VtL9eI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mukesh Ojha <mojha@codeaurora.org>,
        Oscar Salvador <osalvador@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>
Subject: [PATCH 4.19 75/92] drivers/base/memory.c: clean up relics in function parameters
Date:   Tue, 28 Jan 2020 15:08:43 +0100
Message-Id: <20200128135819.027417564@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135809.344954797@linuxfoundation.org>
References: <20200128135809.344954797@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baoquan He <bhe@redhat.com>

commit 063b8a4cee8088224bcdb79bcd08db98df16178e upstream.

The input parameter 'phys_index' of memory_block_action() is actually the
section number, but not the phys_index of memory_block.  This is a relic
from the past when one memory block could only contain one section.
Rename it to start_section_nr.

And also in remove_memory_section(), the 'node_id' and 'phys_device'
arguments are not used by anyone.  Remove them.

Link: http://lkml.kernel.org/r/20190329144250.14315-2-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Mukesh Ojha <mojha@codeaurora.org>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/memory.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -230,13 +230,14 @@ static bool pages_correctly_probed(unsig
  * OK to have direct references to sparsemem variables in here.
  */
 static int
-memory_block_action(unsigned long phys_index, unsigned long action, int online_type)
+memory_block_action(unsigned long start_section_nr, unsigned long action,
+		    int online_type)
 {
 	unsigned long start_pfn;
 	unsigned long nr_pages = PAGES_PER_SECTION * sections_per_block;
 	int ret;
 
-	start_pfn = section_nr_to_pfn(phys_index);
+	start_pfn = section_nr_to_pfn(start_section_nr);
 
 	switch (action) {
 	case MEM_ONLINE:
@@ -250,7 +251,7 @@ memory_block_action(unsigned long phys_i
 		break;
 	default:
 		WARN(1, KERN_WARNING "%s(%ld, %ld) unknown action: "
-		     "%ld\n", __func__, phys_index, action, action);
+		     "%ld\n", __func__, start_section_nr, action, action);
 		ret = -EINVAL;
 	}
 
@@ -747,8 +748,7 @@ unregister_memory(struct memory_block *m
 	device_unregister(&memory->dev);
 }
 
-static int remove_memory_section(unsigned long node_id,
-			       struct mem_section *section, int phys_device)
+static int remove_memory_section(struct mem_section *section)
 {
 	struct memory_block *mem;
 
@@ -780,7 +780,7 @@ int unregister_memory_section(struct mem
 	if (!present_section(section))
 		return -EINVAL;
 
-	return remove_memory_section(0, section, 0);
+	return remove_memory_section(section);
 }
 #endif /* CONFIG_MEMORY_HOTREMOVE */
 


