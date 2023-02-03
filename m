Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 870AE689C0A
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 15:40:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233122AbjBCOkD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 09:40:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231233AbjBCOkC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 09:40:02 -0500
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C5AC61864
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 06:39:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1675435201; x=1706971201;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=/z8zaOWXshQBWh3Ap3JlSE+vh2cQl3avpvAy3DAqrE4=;
  b=hc2QS4htf3JP7P9v5Pekc5gZxSul14dVfHwDWpONSqYXHcYSFQdHaLWF
   cVOzPmRCd+YO8gzeaygUMMsoK1MdrIiJQTm5vwGyd1EWH1ezoBax5y1xK
   M+Z19r/wPxXQJaj0Jr8nt6ao/Pw7Nef0hcK6vBRbMkXgT8Uwv59uweT1+
   g=;
X-IronPort-AV: E=Sophos;i="5.97,270,1669075200"; 
   d="scan'208";a="295087778"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-366646a6.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2023 14:36:57 +0000
Received: from EX13MTAUEE001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1a-m6i4x-366646a6.us-east-1.amazon.com (Postfix) with ESMTPS id 4D09DA105F;
        Fri,  3 Feb 2023 14:36:55 +0000 (UTC)
Received: from EX19D028UEC003.ant.amazon.com (10.252.137.159) by
 EX13MTAUEE001.ant.amazon.com (10.43.62.200) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Fri, 3 Feb 2023 14:36:51 +0000
Received: from dev-dsk-luizcap-1d-37beaf15.us-east-1.amazon.com (10.43.162.56)
 by EX19D028UEC003.ant.amazon.com (10.252.137.159) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.24; Fri, 3 Feb 2023 14:36:49 +0000
From:   Luiz Capitulino <luizcap@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <gregkh@linuxfoundation.org>,
        Andrea Righi <andrea.righi@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Huang, Ying" <ying.huang@intel.com>,
        Minchan Kim <minchan@kernel.org>,
        Anchal Agarwal <anchalag@amazon.com>,
        Hugh Dickins <hughd@google.com>,
        "Vineeth Remanan Pillai" <vpillai@digitalocean.com>,
        Kelley Nielsen <kelleynnn@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luiz Capitulino <luizcap@amazon.com>
Subject: [RESEND stable 5.4] mm: swap: properly update readahead statistics in unuse_pte_range()
Date:   Fri, 3 Feb 2023 14:36:22 +0000
Message-ID: <20230203143622.55262-1-luizcap@amazon.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.56]
X-ClientProxiedBy: EX13D39UWB002.ant.amazon.com (10.43.161.116) To
 EX19D028UEC003.ant.amazon.com (10.252.137.159)
X-Spam-Status: No, score=-11.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,LOTS_OF_MONEY,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrea Righi <andrea.righi@canonical.com>

Commit ebc5951eea499314f6fbbde20e295f1345c67330 upstream.

[ This fixes a performance issue we're seeing in AWS instances when
  running swapoff and using the global readahead algorithm. For a
  particular instance configuration, Without this fix I/O throughput
  is very low during swapoff (about 15 MB/s) with this patch is
  reaches 500 MB/s. Tested swapoff with different workloads with
  this patch applied. 5.10 onwards already have this fix ]

In unuse_pte_range() we blindly swap-in pages without checking if the
swap entry is already present in the swap cache.

By doing this, the hit/miss ratio used by the swap readahead heuristic
is not properly updated and this leads to non-optimal performance during
swapoff.

Tracing the distribution of the readahead size returned by the swap
readahead heuristic during swapoff shows that a small readahead size is
used most of the time as if we had only misses (this happens both with
cluster and vma readahead), for example:

r::swapin_nr_pages(unsigned long offset):unsigned long:$retval
        COUNT      EVENT
        36948      $retval = 8
        44151      $retval = 4
        49290      $retval = 1
        527771     $retval = 2

Checking if the swap entry is present in the swap cache, instead, allows
to properly update the readahead statistics and the heuristic behaves in a
better way during swapoff, selecting a bigger readahead size:

r::swapin_nr_pages(unsigned long offset):unsigned long:$retval
        COUNT      EVENT
        1618       $retval = 1
        4960       $retval = 2
        41315      $retval = 4
        103521     $retval = 8

In terms of swapoff performance the result is the following:

Testing environment
===================

 - Host:
   CPU: 1.8GHz Intel Core i7-8565U (quad-core, 8MB cache)
   HDD: PC401 NVMe SK hynix 512GB
   MEM: 16GB

 - Guest (kvm):
   8GB of RAM
   virtio block driver
   16GB swap file on ext4 (/swapfile)

Test case
=========
 - allocate 85% of memory
 - `systemctl hibernate` to force all the pages to be swapped-out to the
   swap file
 - resume the system
 - measure the time that swapoff takes to complete:
   # /usr/bin/time swapoff /swapfile

Result (swapoff time)
======
                  5.6 vanilla   5.6 w/ this patch
                  -----------   -----------------
cluster-readahead      22.09s              12.19s
    vma-readahead      18.20s              15.33s

Conclusion
==========

The specific use case this patch is addressing is to improve swapoff
performance in cloud environments when a VM has been hibernated, resumed
and all the memory needs to be forced back to RAM by disabling swap.

This change allows to better exploits the advantages of the readahead
heuristic during swapoff and this improvement allows to to speed up the
resume process of such VMs.

[andrea.righi@canonical.com: update changelog]
  Link: http://lkml.kernel.org/r/20200418084705.GA147642@xps-13
Signed-off-by: Andrea Righi <andrea.righi@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Anchal Agarwal <anchalag@amazon.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Vineeth Remanan Pillai <vpillai@digitalocean.com>
Cc: Kelley Nielsen <kelleynnn@gmail.com>
Link: http://lkml.kernel.org/r/20200416180132.GB3352@xps-13
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luiz Capitulino <luizcap@amazon.com>
---
 mm/swapfile.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

Add missing SOB.

diff --git a/mm/swapfile.c b/mm/swapfile.c
index f6964212c6c8..fe5995c38ea4 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1950,10 +1950,14 @@ static int unuse_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
 
 		pte_unmap(pte);
 		swap_map = &si->swap_map[offset];
-		vmf.vma = vma;
-		vmf.address = addr;
-		vmf.pmd = pmd;
-		page = swapin_readahead(entry, GFP_HIGHUSER_MOVABLE, &vmf);
+		page = lookup_swap_cache(entry, vma, addr);
+		if (!page) {
+			vmf.vma = vma;
+			vmf.address = addr;
+			vmf.pmd = pmd;
+			page = swapin_readahead(entry, GFP_HIGHUSER_MOVABLE,
+						&vmf);
+		}
 		if (!page) {
 			if (*swap_map == 0 || *swap_map == SWAP_MAP_BAD)
 				goto try_next;
-- 
2.38.1

