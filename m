Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7902E17FBBA
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:16:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731750AbgCJNNm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:13:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:36780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731178AbgCJNNl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:13:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D944C208E4;
        Tue, 10 Mar 2020 13:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583846021;
        bh=5UrEbg6O6cqlF0WHPx5YdbVlyxrCwoZCF9Tox1OgqFI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YqfS4LLTaq3Qa8cD0kdYGCUJTOQKmEUsFWlHi7C8QRDCtD2HbjGpyM0iCCR7afnWn
         bzgVH5SEWWYikvgAFUNZ393EzSyRqs8rV+pyL+yOZTiiZfSADGhTh8YwypJ4VTP6Y2
         eNdOSEPQm0c0FUzcjCYejHjjenHvIrMzM5iBdvxo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 4.19 57/86] dm writecache: verify watermark during resume
Date:   Tue, 10 Mar 2020 13:45:21 +0100
Message-Id: <20200310124533.876145425@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310124530.808338541@linuxfoundation.org>
References: <20200310124530.808338541@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

commit 41c526c5af46d4c4dab7f72c99000b7fac0b9702 upstream.

Verify the watermark upon resume - so that if the target is reloaded
with lower watermark, it will start the cleanup process immediately.

Fixes: 48debafe4f2f ("dm: add writecache target")
Cc: stable@vger.kernel.org # 4.18+
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-writecache.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -631,6 +631,12 @@ static void writecache_add_to_freelist(s
 	wc->freelist_size++;
 }
 
+static inline void writecache_verify_watermark(struct dm_writecache *wc)
+{
+	if (unlikely(wc->freelist_size + wc->writeback_size <= wc->freelist_high_watermark))
+		queue_work(wc->writeback_wq, &wc->writeback_work);
+}
+
 static struct wc_entry *writecache_pop_from_freelist(struct dm_writecache *wc)
 {
 	struct wc_entry *e;
@@ -652,8 +658,8 @@ static struct wc_entry *writecache_pop_f
 		list_del(&e->lru);
 	}
 	wc->freelist_size--;
-	if (unlikely(wc->freelist_size + wc->writeback_size <= wc->freelist_high_watermark))
-		queue_work(wc->writeback_wq, &wc->writeback_work);
+
+	writecache_verify_watermark(wc);
 
 	return e;
 }
@@ -967,6 +973,8 @@ erase_this:
 		writecache_commit_flushed(wc, false);
 	}
 
+	writecache_verify_watermark(wc);
+
 	wc_unlock(wc);
 }
 


