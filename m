Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98C4068236F
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 05:40:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbjAaEkS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 23:40:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbjAaEjO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 23:39:14 -0500
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8946710F9;
        Mon, 30 Jan 2023 20:38:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1675139940; x=1706675940;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KzxtKnvbi8Q7EeBQQOVpXwZCQQNURGL1YCOaytw/sBY=;
  b=jED0HrnIRKb4aH5qkNnQCPTd6JofJNViJdyugWtAsxceKpTQ1DR8tvHY
   2aUzJqQMPkgw7OkwiO6nvKPNbKjoOQcvRv3L0BnRUID1bfJq8wo5xO35o
   JgPX7lHhVjYcw+STTtISsu1L2PclW55bFMcWTa8h4EDtjDEs+PqYqnYTe
   c=;
X-IronPort-AV: E=Sophos;i="5.97,259,1669075200"; 
   d="scan'208";a="287996743"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1box-1dm6-7f722725.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2023 04:38:59 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1box-1dm6-7f722725.us-east-1.amazon.com (Postfix) with ESMTPS id 388A89ACF7;
        Tue, 31 Jan 2023 04:38:58 +0000 (UTC)
Received: from EX19D002UWA004.ant.amazon.com (10.13.138.230) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Tue, 31 Jan 2023 04:38:57 +0000
Received: from EX13MTAUEB002.ant.amazon.com (10.43.60.12) by
 EX19D002UWA004.ant.amazon.com (10.13.138.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.24;
 Tue, 31 Jan 2023 04:38:57 +0000
Received: from dev-dsk-risbhat-2b-8bdc64cd.us-west-2.amazon.com
 (10.189.73.169) by mail-relay.amazon.com (10.43.60.234) with Microsoft SMTP
 Server id 15.0.1497.45 via Frontend Transport; Tue, 31 Jan 2023 04:38:56
 +0000
Received: by dev-dsk-risbhat-2b-8bdc64cd.us-west-2.amazon.com (Postfix, from userid 22673075)
        id 9D103271E; Tue, 31 Jan 2023 04:38:56 +0000 (UTC)
From:   Rishabh Bhatnagar <risbhat@amazon.com>
To:     <stable@vger.kernel.org>, <gregkh@linuxfoundation.org>
CC:     <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <mhocko@suse.co>, Michal Hocko <mhocko@suse.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tom Herbert <tom@quantonium.net>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        Rishabh Bhatnagar <risbhat@amazon.com>
Subject: [PATCH stable 4.14 1/1] mm: kvmalloc does not fallback to vmalloc for incompatible gfp flags
Date:   Tue, 31 Jan 2023 04:38:15 +0000
Message-ID: <20230131043815.14989-2-risbhat@amazon.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230131043815.14989-1-risbhat@amazon.com>
References: <20230131043815.14989-1-risbhat@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-11.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Hocko <mhocko@suse.com>

Commit ce91f6ee5b3bbbad8caff61b1c46d845c8db19bf upstream.

kvmalloc warned about incompatible gfp_mask to catch abusers (mostly
GFP_NOFS) with an intention that this will motivate authors of the code
to fix those.  Linus argues that this just motivates people to do even
more hacks like

	if (gfp == GFP_KERNEL)
		kvmalloc
	else
		kmalloc

I haven't seen this happening much (Linus pointed to bucket_lock special
cases an atomic allocation but my git foo hasn't found much more) but it
is true that we can grow those in future.  Therefore Linus suggested to
simply not fallback to vmalloc for incompatible gfp flags and rather
stick with the kmalloc path.

Link: http://lkml.kernel.org/r/20180601115329.27807-1-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tom Herbert <tom@quantonium.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Rishabh Bhatnagar <risbhat@amazon.com>
---
Changelog:
- Removed lib/bucket_locks.c diff as not present in 4.14

 mm/util.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/util.c b/mm/util.c
index 84e775f5216f..7d80c8119dce 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -400,7 +400,8 @@ EXPORT_SYMBOL(vm_mmap);
  * __GFP_RETRY_MAYFAIL is supported, and it should be used only if kmalloc is
  * preferable to the vmalloc fallback, due to visible performance drawbacks.
  *
- * Any use of gfp flags outside of GFP_KERNEL should be consulted with mm people.
+ * Please note that any use of gfp flags outside of GFP_KERNEL is careful to not
+ * fall back to vmalloc.
  */
 void *kvmalloc_node(size_t size, gfp_t flags, int node)
 {
@@ -411,7 +412,8 @@ void *kvmalloc_node(size_t size, gfp_t flags, int node)
 	 * vmalloc uses GFP_KERNEL for some internal allocations (e.g page tables)
 	 * so the given set of flags has to be compatible.
 	 */
-	WARN_ON_ONCE((flags & GFP_KERNEL) != GFP_KERNEL);
+	if ((flags & GFP_KERNEL) != GFP_KERNEL)
+		return kmalloc_node(size, flags, node);
 
 	/*
 	 * We want to attempt a large physically contiguous block first because
-- 
2.38.1

