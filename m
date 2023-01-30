Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 552476814FE
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 16:28:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237969AbjA3P2t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 10:28:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237807AbjA3P2s (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 10:28:48 -0500
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C6F823D8E
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 07:28:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1675092528; x=1706628528;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=04Exuipt3zJ72HWMfAk1JCDpOucci18ywiHodx0vDNk=;
  b=fUnbCEKy547EWPbfNRo+nE+JqrVOydR6LqYV0cFU55nv3gNj5oNfcxhN
   ttEitQBsjZEqG787hUrz2jBVwWDiuSM9xD4JXnPu5WzotnE7nrKVTCuYW
   1vIr7M1zX7U54CTuGncyj0KlGKBe5z4aBIp47pI9FK1gm5qUurEwrB1Ez
   U=;
X-IronPort-AV: E=Sophos;i="5.97,258,1669075200"; 
   d="scan'208";a="287789718"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-d2040ec1.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2023 15:28:43 +0000
Received: from EX13MTAUEE001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-m6i4x-d2040ec1.us-west-2.amazon.com (Postfix) with ESMTPS id AF8EB41FF1;
        Mon, 30 Jan 2023 15:28:41 +0000 (UTC)
Received: from EX19D028UEC003.ant.amazon.com (10.252.137.159) by
 EX13MTAUEE001.ant.amazon.com (10.43.62.226) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Mon, 30 Jan 2023 15:28:38 +0000
Received: from dev-dsk-luizcap-1d-37beaf15.us-east-1.amazon.com
 (10.43.161.198) by EX19D028UEC003.ant.amazon.com (10.252.137.159) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.24; Mon, 30 Jan
 2023 15:28:36 +0000
From:   Luiz Capitulino <luizcap@amazon.com>
To:     <stable@vger.kernel.org>
CC:     Andrea Righi <andrea.righi@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Minchan Kim" <minchan@kernel.org>,
        Anchal Agarwal <anchalag@amazon.com>,
        Hugh Dickins <hughd@google.com>,
        Vineeth Remanan Pillai <vpillai@digitalocean.com>,
        Kelley Nielsen <kelleynnn@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATH stable 5.4] mm: swap: properly update readahead statistics in unuse_pte_range()
Date:   Mon, 30 Jan 2023 15:28:23 +0000
Message-ID: <20230130152823.65880-1-luizcap@amazon.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.198]
X-ClientProxiedBy: EX13D44UWB002.ant.amazon.com (10.43.161.192) To
 EX19D028UEC003.ant.amazon.com (10.252.137.159)
X-Spam-Status: No, score=-11.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,LOTS_OF_MONEY,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
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
---
 mm/swapfile.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

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

