Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D927149FC04
	for <lists+stable@lfdr.de>; Fri, 28 Jan 2022 15:46:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349404AbiA1Op7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jan 2022 09:45:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:26305 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349400AbiA1Op7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jan 2022 09:45:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643381158;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=HFyK9YSPqzN8UFNpZeb69roURTWWg8qSsNbo2x59knA=;
        b=d/V8v1bvClSoMbBpuZY4h2QTcquUZey/6mC5tcwWz8vA3TOz0tZdIt20uE7nfepc7LCuV5
        oT6iZZ3bx5HP5+4BqvjdXn+FY6bhMNCSrfnogvzs5LEGizKQ5gqfP0RxxksYjk3BJ97IZD
        FwbVHuMZzxQ/cK2ZyB8a/pJiVRcPLCs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-1-0TLvl7ZXOlOCj-4oqSTr-g-1; Fri, 28 Jan 2022 09:45:55 -0500
X-MC-Unique: 0TLvl7ZXOlOCj-4oqSTr-g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BC69C814246;
        Fri, 28 Jan 2022 14:45:53 +0000 (UTC)
Received: from t480s.redhat.com (unknown [10.39.193.182])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D923C7B9E3;
        Fri, 28 Jan 2022 14:45:41 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-mm@kvack.org, David Hildenbrand <david@redhat.com>,
        stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.com>,
        Oscar Salvador <osalvador@suse.de>
Subject: [PATCH v1] drivers/base/memory: add memory block to memory group after registration succeeded
Date:   Fri, 28 Jan 2022 15:45:40 +0100
Message-Id: <20220128144540.153902-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If register_memory() fails, we freed the memory block but already added
the memory block to the group list, not good. Let's defer adding the
block to the memory group to after registering the memory block device.

We do handle it properly during unregister_memory(), but that's not
called when the registration fails.

Fixes: 028fc57a1c36 ("drivers/base/memory: introduce "memory groups" to logically group memory blocks")
Cc: stable@vger.kernel.org # v5.15+
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 drivers/base/memory.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 365cd4a7f239..60c38f9cf1a7 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -663,14 +663,16 @@ static int init_memory_block(unsigned long block_id, unsigned long state,
 	mem->nr_vmemmap_pages = nr_vmemmap_pages;
 	INIT_LIST_HEAD(&mem->group_next);
 
+	ret = register_memory(mem);
+	if (ret)
+		return ret;
+
 	if (group) {
 		mem->group = group;
 		list_add(&mem->group_next, &group->memory_blocks);
 	}
 
-	ret = register_memory(mem);
-
-	return ret;
+	return 0;
 }
 
 static int add_memory_block(unsigned long base_section_nr)
-- 
2.34.1

