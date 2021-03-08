Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2EC0330DAE
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 13:32:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230327AbhCHMbg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 07:31:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:40666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229899AbhCHMb2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 07:31:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8685364EBC;
        Mon,  8 Mar 2021 12:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615206688;
        bh=JWcP2Ez3OrVt5pwP1x7P4o15l+tIK0bYpn4uFy4OUO8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EJb6PHs0IvnFJ3XE0woLLFzg80Y6sbz+FYdPt8UhXlXq/aphGbH16yrv4oURWiriH
         SeIYGiffxBvZ0nSuIfIu4K9pGRGGxSMJY62Ebm6Gfd7dDHm7nX9KI/2aB3lSxRpDHU
         1Pp3E31fyAvszh5QqAdmXruyZGhb4H+P7XNSijgo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 03/22] btrfs: raid56: simplify tracking of Q stripe presence
Date:   Mon,  8 Mar 2021 13:30:20 +0100
Message-Id: <20210308122714.563884205@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210308122714.391917404@linuxfoundation.org>
References: <20210308122714.391917404@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Sterba <dsterba@suse.com>

commit c17af96554a8a8777cbb0fd53b8497250e548b43 upstream.

There are temporary variables tracking the index of P and Q stripes, but
none of them is really used as such, merely for determining if the Q
stripe is present. This leads to compiler warnings with
-Wunused-but-set-variable and has been reported several times.

fs/btrfs/raid56.c: In function ‘finish_rmw’:
fs/btrfs/raid56.c:1199:6: warning: variable ‘p_stripe’ set but not used [-Wunused-but-set-variable]
 1199 |  int p_stripe = -1;
      |      ^~~~~~~~
fs/btrfs/raid56.c: In function ‘finish_parity_scrub’:
fs/btrfs/raid56.c:2356:6: warning: variable ‘p_stripe’ set but not used [-Wunused-but-set-variable]
 2356 |  int p_stripe = -1;
      |      ^~~~~~~~

Replace the two variables with one that has a clear meaning and also get
rid of the warnings. The logic that verifies that there are only 2
valid cases is unchanged.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/raid56.c |   37 +++++++++++++++----------------------
 1 file changed, 15 insertions(+), 22 deletions(-)

--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -1198,22 +1198,19 @@ static noinline void finish_rmw(struct b
 	int nr_data = rbio->nr_data;
 	int stripe;
 	int pagenr;
-	int p_stripe = -1;
-	int q_stripe = -1;
+	bool has_qstripe;
 	struct bio_list bio_list;
 	struct bio *bio;
 	int ret;
 
 	bio_list_init(&bio_list);
 
-	if (rbio->real_stripes - rbio->nr_data == 1) {
-		p_stripe = rbio->real_stripes - 1;
-	} else if (rbio->real_stripes - rbio->nr_data == 2) {
-		p_stripe = rbio->real_stripes - 2;
-		q_stripe = rbio->real_stripes - 1;
-	} else {
+	if (rbio->real_stripes - rbio->nr_data == 1)
+		has_qstripe = false;
+	else if (rbio->real_stripes - rbio->nr_data == 2)
+		has_qstripe = true;
+	else
 		BUG();
-	}
 
 	/* at this point we either have a full stripe,
 	 * or we've read the full stripe from the drive.
@@ -1257,7 +1254,7 @@ static noinline void finish_rmw(struct b
 		SetPageUptodate(p);
 		pointers[stripe++] = kmap(p);
 
-		if (q_stripe != -1) {
+		if (has_qstripe) {
 
 			/*
 			 * raid6, add the qstripe and call the
@@ -2355,8 +2352,7 @@ static noinline void finish_parity_scrub
 	int nr_data = rbio->nr_data;
 	int stripe;
 	int pagenr;
-	int p_stripe = -1;
-	int q_stripe = -1;
+	bool has_qstripe;
 	struct page *p_page = NULL;
 	struct page *q_page = NULL;
 	struct bio_list bio_list;
@@ -2366,14 +2362,12 @@ static noinline void finish_parity_scrub
 
 	bio_list_init(&bio_list);
 
-	if (rbio->real_stripes - rbio->nr_data == 1) {
-		p_stripe = rbio->real_stripes - 1;
-	} else if (rbio->real_stripes - rbio->nr_data == 2) {
-		p_stripe = rbio->real_stripes - 2;
-		q_stripe = rbio->real_stripes - 1;
-	} else {
+	if (rbio->real_stripes - rbio->nr_data == 1)
+		has_qstripe = false;
+	else if (rbio->real_stripes - rbio->nr_data == 2)
+		has_qstripe = true;
+	else
 		BUG();
-	}
 
 	if (bbio->num_tgtdevs && bbio->tgtdev_map[rbio->scrubp]) {
 		is_replace = 1;
@@ -2395,7 +2389,7 @@ static noinline void finish_parity_scrub
 		goto cleanup;
 	SetPageUptodate(p_page);
 
-	if (q_stripe != -1) {
+	if (has_qstripe) {
 		q_page = alloc_page(GFP_NOFS | __GFP_HIGHMEM);
 		if (!q_page) {
 			__free_page(p_page);
@@ -2418,8 +2412,7 @@ static noinline void finish_parity_scrub
 		/* then add the parity stripe */
 		pointers[stripe++] = kmap(p_page);
 
-		if (q_stripe != -1) {
-
+		if (has_qstripe) {
 			/*
 			 * raid6, add the qstripe and call the
 			 * library function to fill in our p/q


