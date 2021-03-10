Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E61B333E67
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:36:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233686AbhCJN0E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:26:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:46746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233301AbhCJNZT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:25:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 34BB06500E;
        Wed, 10 Mar 2021 13:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382719;
        bh=GTkDIsWZYLIlBE7QKAAma1929RS+G5varp3cUWHkM6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ac3m1iacgKmZEeu5SCk+mD6Aw3JaKondljCvha+LH6hY0KNDVqFeNBarP/mqUJU9K
         nWnjbEb7vQr4h7Tsm8gx7KKZWLVhWUAdvhoo+AsBiiW9JgOUJof5NCmJZEQA6//UC/
         x5Wb58rg+3WWAnUN3cVpokXa5iiAamf9H7oraRHI=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.9 02/11] btrfs: fix raid6 qstripe kmap
Date:   Wed, 10 Mar 2021 14:25:01 +0100
Message-Id: <20210310132320.469905282@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310132320.393957501@linuxfoundation.org>
References: <20210310132320.393957501@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Ira Weiny <ira.weiny@intel.com>

commit d70cef0d46729808dc53f145372c02b145c92604 upstream.

When a qstripe is required an extra page is allocated and mapped.  There
were 3 problems:

1) There is no corresponding call of kunmap() for the qstripe page.
2) There is no reason to map the qstripe page more than once if the
   number of bits set in rbio->dbitmap is greater than one.
3) There is no reason to map the parity page and unmap it each time
   through the loop.

The page memory can continue to be reused with a single mapping on each
iteration by raid6_call.gen_syndrome() without remapping.  So map the
page for the duration of the loop.

Similarly, improve the algorithm by mapping the parity page just 1 time.

Fixes: 5a6ac9eacb49 ("Btrfs, raid56: support parity scrub on raid56")
CC: stable@vger.kernel.org # 4.4.x: c17af96554a8: btrfs: raid56: simplify tracking of Q stripe presence
CC: stable@vger.kernel.org # 4.4.x
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/raid56.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -2341,16 +2341,21 @@ static noinline void finish_parity_scrub
 	SetPageUptodate(p_page);
 
 	if (has_qstripe) {
+		/* RAID6, allocate and map temp space for the Q stripe */
 		q_page = alloc_page(GFP_NOFS | __GFP_HIGHMEM);
 		if (!q_page) {
 			__free_page(p_page);
 			goto cleanup;
 		}
 		SetPageUptodate(q_page);
+		pointers[rbio->real_stripes - 1] = kmap(q_page);
 	}
 
 	atomic_set(&rbio->error, 0);
 
+	/* Map the parity stripe just once */
+	pointers[nr_data] = kmap(p_page);
+
 	for_each_set_bit(pagenr, rbio->dbitmap, rbio->stripe_npages) {
 		struct page *p;
 		void *parity;
@@ -2360,16 +2365,8 @@ static noinline void finish_parity_scrub
 			pointers[stripe] = kmap(p);
 		}
 
-		/* then add the parity stripe */
-		pointers[stripe++] = kmap(p_page);
-
 		if (has_qstripe) {
-			/*
-			 * raid6, add the qstripe and call the
-			 * library function to fill in our p/q
-			 */
-			pointers[stripe++] = kmap(q_page);
-
+			/* RAID6, call the library function to fill in our P/Q */
 			raid6_call.gen_syndrome(rbio->real_stripes, PAGE_SIZE,
 						pointers);
 		} else {
@@ -2390,12 +2387,14 @@ static noinline void finish_parity_scrub
 
 		for (stripe = 0; stripe < nr_data; stripe++)
 			kunmap(page_in_rbio(rbio, stripe, pagenr, 0));
-		kunmap(p_page);
 	}
 
+	kunmap(p_page);
 	__free_page(p_page);
-	if (q_page)
+	if (q_page) {
+		kunmap(q_page);
 		__free_page(q_page);
+	}
 
 writeback:
 	/*


