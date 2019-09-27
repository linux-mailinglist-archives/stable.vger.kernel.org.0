Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 451B8C08D8
	for <lists+stable@lfdr.de>; Fri, 27 Sep 2019 17:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727416AbfI0Pqe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Sep 2019 11:46:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53852 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727289AbfI0Pqe (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Sep 2019 11:46:34 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EF3208980E5;
        Fri, 27 Sep 2019 15:46:33 +0000 (UTC)
Received: from t460s.redhat.com (ovpn-116-169.ams2.redhat.com [10.36.116.169])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BBB3D60BF3;
        Fri, 27 Sep 2019 15:46:29 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-mm@kvack.org, xen-devel@lists.xenproject.org,
        David Hildenbrand <david@redhat.com>,
        =?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>, stable@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>
Subject: [PATCH v1] xen/balloon: Set pages PageOffline() in balloon_add_region()
Date:   Fri, 27 Sep 2019 17:46:28 +0200
Message-Id: <20190927154628.8480-1-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.67]); Fri, 27 Sep 2019 15:46:34 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We are missing a __SetPageOffline(), which is why we can get
!PageOffline() pages onto the balloon list, where
alloc_xenballooned_pages() will complain:

page:ffffea0003e7ffc0 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0
flags: 0xffffe00001000(reserved)
raw: 000ffffe00001000 dead000000000100 dead000000000200 0000000000000000
raw: 0000000000000000 0000000000000000 00000001ffffffff 0000000000000000
page dumped because: VM_BUG_ON_PAGE(!PageOffline(page))
------------[ cut here ]------------
kernel BUG at include/linux/page-flags.h:744!
invalid opcode: 0000 [#1] SMP NOPTI

Reported-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Tested-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Fixes: 77c4adf6a6df ("xen/balloon: mark inflated pages PG_offline")
Cc: stable@vger.kernel.org # v5.1+
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 drivers/xen/balloon.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
index 05b1f7e948ef..29f6256363db 100644
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -687,6 +687,7 @@ static void __init balloon_add_region(unsigned long start_pfn,
 		/* totalram_pages and totalhigh_pages do not
 		   include the boot-time balloon extension, so
 		   don't subtract from it. */
+		__SetPageOffline(page);
 		__balloon_append(page);
 	}
 
-- 
2.21.0

