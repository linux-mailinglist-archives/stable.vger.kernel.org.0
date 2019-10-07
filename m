Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B131CD9FD
	for <lists+stable@lfdr.de>; Mon,  7 Oct 2019 02:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbfJGAru (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 20:47:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:50700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726661AbfJGAru (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 20:47:50 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 964882084B;
        Mon,  7 Oct 2019 00:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570409269;
        bh=3Af82QpZqFGfsPV2oGsUfi0K4kHOSH7D74nIbQc1gCg=;
        h=Date:From:To:Subject:From;
        b=vmBltehGaHAZ2tDmroyww9vrWB37X8O+jKLgj8EYhycEu9DdScknCnV6ae66R7H/3
         NxQW7Zpk1GMiJbiYUYZwQGyFzEomH58see3yHxnDu5tm0N7B9PyHMje5rwcXh7affW
         ZTboeYvo5bqiZ/kGAg78jA/N8tc/5cBMSVcQVmLY=
Date:   Sun, 06 Oct 2019 17:47:49 -0700
From:   akpm@linux-foundation.org
To:     ddstreet@ieee.org, henrywolfeburns@gmail.com,
        markus.linnala@gmail.com, mm-commits@vger.kernel.org,
        shakeelb@google.com, stable@vger.kernel.org, vbabka@suse.cz,
        vitalywool@gmail.com
Subject:  [folded-merged]
 z3fold-claim-page-in-the-beginning-of-free-v2.patch removed from -mm tree
Message-ID: <20191007004749.48dRGdy87%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: z3fold-claim-page-in-the-beginning-of-free-v2
has been removed from the -mm tree.  Its filename was
     z3fold-claim-page-in-the-beginning-of-free-v2.patch

This patch was dropped because it was folded into z3fold-claim-page-in-the-beginning-of-free.patch

------------------------------------------------------
From: Vitaly Wool <vitalywool@gmail.com>
Subject: z3fold-claim-page-in-the-beginning-of-free-v2

Link: http://lkml.kernel.org/r/20190928113456.152742cf@bigdell
Signed-off-by: Vitaly Wool <vitalywool@gmail.com>
Reported-by: Markus Linnala <markus.linnala@gmail.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Henry Burns <henrywolfeburns@gmail.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/z3fold.c~z3fold-claim-page-in-the-beginning-of-free-v2
+++ a/mm/z3fold.c
@@ -1047,12 +1047,14 @@ static void z3fold_free(struct z3fold_po
 		return;
 	}
 	if (page_claimed) {
+		/* the page has not been claimed by us */
 		z3fold_page_unlock(zhdr);
 		return;
 	}
 	if (unlikely(PageIsolated(page)) ||
 	    test_and_set_bit(NEEDS_COMPACTING, &page->private)) {
 		z3fold_page_unlock(zhdr);
+		clear_bit(PAGE_CLAIMED, &page->private);
 		return;
 	}
 	if (zhdr->cpu < 0 || !cpu_online(zhdr->cpu)) {
@@ -1062,10 +1064,12 @@ static void z3fold_free(struct z3fold_po
 		zhdr->cpu = -1;
 		kref_get(&zhdr->refcount);
 		do_compact_page(zhdr, true);
+		clear_bit(PAGE_CLAIMED, &page->private);
 		return;
 	}
 	kref_get(&zhdr->refcount);
 	queue_work_on(zhdr->cpu, pool->compact_wq, &zhdr->work);
+	clear_bit(PAGE_CLAIMED, &page->private);
 	z3fold_page_unlock(zhdr);
 }
 
_

Patches currently in -mm which might be from vitalywool@gmail.com are

z3fold-claim-page-in-the-beginning-of-free.patch

