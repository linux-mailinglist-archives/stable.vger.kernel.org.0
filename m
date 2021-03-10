Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5256C333E61
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:36:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233654AbhCJN0B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:26:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:47264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233289AbhCJNZS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:25:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BFF5064FDC;
        Wed, 10 Mar 2021 13:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382717;
        bh=TvNSHLl+C7ZTcKM+N6l3V2JitAAwCQT/LFrSkASm0rw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zHa9y6Y+KYg/qWcuZbjlq8+hcZIvxFWNrjDlZOfok7SAGWI5/YABO34vPO1hLxWPt
         HlpQK/gfBKFNp3VcG+0NYcsjdRGYpha5ls/bNRtdHliEhlTDxkmlrDCh/BZ2ngRDdE
         22SNtd+b/pUYbay+TMn55Tsz61Nm65e7hyCoLlmc=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.9 01/11] btrfs: raid56: simplify tracking of Q stripe presence
Date:   Wed, 10 Mar 2021 14:25:00 +0100
Message-Id: <20210310132320.441895184@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310132320.393957501@linuxfoundation.org>
References: <20210310132320.393957501@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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
@@ -1179,22 +1179,19 @@ static noinline void finish_rmw(struct b
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
@@ -1238,7 +1235,7 @@ static noinline void finish_rmw(struct b
 		SetPageUptodate(p);
 		pointers[stripe++] = kmap(p);
 
-		if (q_stripe != -1) {
+		if (has_qstripe) {
 
 			/*
 			 * raid6, add the qstripe and call the
@@ -2306,8 +2303,7 @@ static noinline void finish_parity_scrub
 	int nr_data = rbio->nr_data;
 	int stripe;
 	int pagenr;
-	int p_stripe = -1;
-	int q_stripe = -1;
+	bool has_qstripe;
 	struct page *p_page = NULL;
 	struct page *q_page = NULL;
 	struct bio_list bio_list;
@@ -2317,14 +2313,12 @@ static noinline void finish_parity_scrub
 
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
@@ -2346,7 +2340,7 @@ static noinline void finish_parity_scrub
 		goto cleanup;
 	SetPageUptodate(p_page);
 
-	if (q_stripe != -1) {
+	if (has_qstripe) {
 		q_page = alloc_page(GFP_NOFS | __GFP_HIGHMEM);
 		if (!q_page) {
 			__free_page(p_page);
@@ -2369,8 +2363,7 @@ static noinline void finish_parity_scrub
 		/* then add the parity stripe */
 		pointers[stripe++] = kmap(p_page);
 
-		if (q_stripe != -1) {
-
+		if (has_qstripe) {
 			/*
 			 * raid6, add the qstripe and call the
 			 * library function to fill in our p/q


