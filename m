Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9166261957
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 20:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732068AbgIHSMc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 14:12:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:56676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731486AbgIHQLn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:11:43 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A99F824732;
        Tue,  8 Sep 2020 15:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579656;
        bh=F+HJT3z47l9MMpYOM5nYzvVzHczYxmyGfAXOYLN7if0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vP3Srr8hsztz+7NGiKCQTpePtmcrR+DoRmRkwVnkDz6/nQQcMrQw/UzXx/R9x64Bw
         M7vME6YA2MHkagu/7qP1KQkT+iMpE/VfTqJVYMLfyn7k+ZloDtNJl8MIMFC+X77JGu
         i+xt4YQ1FsiXMzLWPm8cWL2SWV183mIMPKx/n97U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.8 167/186] dm integrity: fix error reporting in bitmap mode after creation
Date:   Tue,  8 Sep 2020 17:25:09 +0200
Message-Id: <20200908152249.753474532@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

commit e27fec66f0a94e35a35548bd0b29ae616e62ec62 upstream.

The dm-integrity target did not report errors in bitmap mode just after
creation. The reason is that the function integrity_recalc didn't clean up
ic->recalc_bitmap as it proceeded with recalculation.

Fix this by updating the bitmap accordingly -- the double shift serves
to rounddown.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: 468dfca38b1a ("dm integrity: add a bitmap mode")
Cc: stable@vger.kernel.org # v5.2+
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-integrity.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -2487,6 +2487,7 @@ next_chunk:
 	range.logical_sector = le64_to_cpu(ic->sb->recalc_sector);
 	if (unlikely(range.logical_sector >= ic->provided_data_sectors)) {
 		if (ic->mode == 'B') {
+			block_bitmap_op(ic, ic->recalc_bitmap, 0, ic->provided_data_sectors, BITMAP_OP_CLEAR);
 			DEBUG_print("queue_delayed_work: bitmap_flush_work\n");
 			queue_delayed_work(ic->commit_wq, &ic->bitmap_flush_work, 0);
 		}
@@ -2564,6 +2565,17 @@ next_chunk:
 		goto err;
 	}
 
+	if (ic->mode == 'B') {
+		sector_t start, end;
+		start = (range.logical_sector >>
+			 (ic->sb->log2_sectors_per_block + ic->log2_blocks_per_bitmap_bit)) <<
+			(ic->sb->log2_sectors_per_block + ic->log2_blocks_per_bitmap_bit);
+		end = ((range.logical_sector + range.n_sectors) >>
+		       (ic->sb->log2_sectors_per_block + ic->log2_blocks_per_bitmap_bit)) <<
+			(ic->sb->log2_sectors_per_block + ic->log2_blocks_per_bitmap_bit);
+		block_bitmap_op(ic, ic->recalc_bitmap, start, end - start, BITMAP_OP_CLEAR);
+	}
+
 advance_and_next:
 	cond_resched();
 


