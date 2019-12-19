Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15093126BD9
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:59:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727726AbfLSS7s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:59:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:47742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730289AbfLSSw4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:52:56 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B342420674;
        Thu, 19 Dec 2019 18:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781576;
        bh=Nox2nDepk2UQKD7bAqVj6N2AFjwhMtazOEae/HJoPu0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xBwpiX44YX+UyBnOq61TzEf6W6uvXOGHPC7bY+PRQiRVg2x51RVsIcL4fWsj2OkF8
         oJGNjFFhQjqRcTn72x1B7NPoZshANGygf2FvNJmlf3Qkcx2mQAobyHcRvjMdL8dfn/
         rvjeLZTrqj4sAfG+4VOvFa/5Y8TfRLi6qgAkFjOA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Drew Hastings <dhastings@crucialwebhost.com>,
        Martin Wilck <mwilck@suse.de>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 4.19 42/47] dm mpath: remove harmful bio-based optimization
Date:   Thu, 19 Dec 2019 19:34:56 +0100
Message-Id: <20191219182949.452976698@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219182857.659088743@linuxfoundation.org>
References: <20191219182857.659088743@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Snitzer <snitzer@redhat.com>

commit dbaf971c9cdf10843071a60dcafc1aaab3162354 upstream.

Removes the branching for edge-case where no SCSI device handler
exists.  The __map_bio_fast() method was far too limited, by only
selecting a new pathgroup or path IFF there was a path failure, fix this
be eliminating it in favor of __map_bio().  __map_bio()'s extra SCSI
device handler specific MPATHF_PG_INIT_REQUIRED test is not in the fast
path anyway.

This change restores full path selector functionality for bio-based
configurations that don't haave a SCSI device handler.  But it should be
noted that the path selectors do have an impact on performance for
certain networks that are extremely fast (and don't require frequent
switching).

Fixes: 8d47e65948dd ("dm mpath: remove unnecessary NVMe branching in favor of scsi_dh checks")
Cc: stable@vger.kernel.org
Reported-by: Drew Hastings <dhastings@crucialwebhost.com>
Suggested-by: Martin Wilck <mwilck@suse.de>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-mpath.c |   37 +------------------------------------
 1 file changed, 1 insertion(+), 36 deletions(-)

--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -609,45 +609,10 @@ static struct pgpath *__map_bio(struct m
 	return pgpath;
 }
 
-static struct pgpath *__map_bio_fast(struct multipath *m, struct bio *bio)
-{
-	struct pgpath *pgpath;
-	unsigned long flags;
-
-	/* Do we need to select a new pgpath? */
-	/*
-	 * FIXME: currently only switching path if no path (due to failure, etc)
-	 * - which negates the point of using a path selector
-	 */
-	pgpath = READ_ONCE(m->current_pgpath);
-	if (!pgpath)
-		pgpath = choose_pgpath(m, bio->bi_iter.bi_size);
-
-	if (!pgpath) {
-		if (test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags)) {
-			/* Queue for the daemon to resubmit */
-			spin_lock_irqsave(&m->lock, flags);
-			bio_list_add(&m->queued_bios, bio);
-			spin_unlock_irqrestore(&m->lock, flags);
-			queue_work(kmultipathd, &m->process_queued_bios);
-
-			return ERR_PTR(-EAGAIN);
-		}
-		return NULL;
-	}
-
-	return pgpath;
-}
-
 static int __multipath_map_bio(struct multipath *m, struct bio *bio,
 			       struct dm_mpath_io *mpio)
 {
-	struct pgpath *pgpath;
-
-	if (!m->hw_handler_name)
-		pgpath = __map_bio_fast(m, bio);
-	else
-		pgpath = __map_bio(m, bio);
+	struct pgpath *pgpath = __map_bio(m, bio);
 
 	if (IS_ERR(pgpath))
 		return DM_MAPIO_SUBMITTED;


