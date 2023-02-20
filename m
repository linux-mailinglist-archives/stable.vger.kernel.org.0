Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94A5769CD12
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:46:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232157AbjBTNqO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:46:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232273AbjBTNqN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:46:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A75FC1E1CE
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:45:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 46A4C60E9D
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:45:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F998C433D2;
        Mon, 20 Feb 2023 13:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676900741;
        bh=0Fg6X6N3jZ/cHnYCbSgyqr2bhgoTh4+W/8T2N+tPOGk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N3U01mzJTj5aZYIyfCzqtVXTIfELICD3WKyD+ALsbmioUcWW9FXGghY093jkQEBOl
         DEqpIW8TrC4+3iN1BiSFPrUQ/FnQiFBzdJ8xQWfRzpwJ7RqF4c2TbpAFakpvNrtxkd
         JsCrANwny2iO3Kq0Gm6AW+5HTffq5+ipTY8Hpw9Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Andrea Righi <andrea.righi@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Huang, Ying" <ying.huang@intel.com>,
        Minchan Kim <minchan@kernel.org>,
        Anchal Agarwal <anchalag@amazon.com>,
        Hugh Dickins <hughd@google.com>,
        Vineeth Remanan Pillai <vpillai@digitalocean.com>,
        Kelley Nielsen <kelleynnn@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luiz Capitulino <luizcap@amazon.com>
Subject: [PATCH 5.4 051/156] mm: swap: properly update readahead statistics in unuse_pte_range()
Date:   Mon, 20 Feb 2023 14:34:55 +0100
Message-Id: <20230220133604.488923548@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133602.515342638@linuxfoundation.org>
References: <20230220133602.515342638@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,LOTS_OF_MONEY,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrea Righi <andrea.righi@canonical.com>

commit ebc5951eea499314f6fbbde20e295f1345c67330 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/swapfile.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

Add missing SOB.

--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1951,10 +1951,14 @@ static int unuse_pte_range(struct vm_are
 
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


