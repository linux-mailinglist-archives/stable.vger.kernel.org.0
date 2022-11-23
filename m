Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C73F363585E
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:56:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237186AbiKWJ4S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:56:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237082AbiKWJy5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:54:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B3C91165A1;
        Wed, 23 Nov 2022 01:50:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C348AB81EF3;
        Wed, 23 Nov 2022 09:50:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 036EDC433D7;
        Wed, 23 Nov 2022 09:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669197038;
        bh=6f9kMGYCqPXsi0k0LVBuzTEbJ5fILjVvpxN31nNOmZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NEN9xmE8HYT91cNbV8FNHiw/kLFBH2RAHGFKuUrQ4vUpfZGlsvOMNxEAVbsE2gNlw
         CVBFf9yPVCxWYmsxlWA0NzJ8CrScBNJTrxgGC2FE9/PQgeTcNfWdTG+kApJT9kUOrH
         zbxKWNWA1qxhOmYIIC3m4QB/0cA9Q4XYyz0330Ps=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Matthew Wilcox <willy@infradead.org>,
        David Howells <dhowells@redhat.com>,
        Jeff Layton <jlayton@kernel.org>,
        Jingbo Xu <jefflexu@linux.alibaba.com>,
        linux-cachefs@redhat.com, linux-fsdevel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 181/314] netfs: Fix dodgy maths
Date:   Wed, 23 Nov 2022 09:50:26 +0100
Message-Id: <20221123084633.777016204@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 5e51c627c5acbcf82bb552e17533a79d2a6a2600 ]

Fix the dodgy maths in netfs_rreq_unlock_folios().  start_page could be
inside the folio, in which case the calculation of pgpos will be come up
with a negative number (though for the moment rreq->start is rounded down
earlier and folios would have to get merged whilst locked)

Alter how this works to just frame the tracking in terms of absolute file
positions, rather than offsets from the start of the I/O request.  This
simplifies the maths and makes it easier to follow.

Fix the issue by using folio_pos() and folio_size() to calculate the end
position of the page.

Fixes: 3d3c95046742 ("netfs: Provide readahead and readpage netfs helpers")
Reported-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Jingbo Xu <jefflexu@linux.alibaba.com>
cc: linux-cachefs@redhat.com
cc: linux-fsdevel@vger.kernel.org
Link: https://lore.kernel.org/r/Y2SJw7w1IsIik3nb@casper.infradead.org/
Link: https://lore.kernel.org/r/166757988611.950645.7626959069846893164.stgit@warthog.procyon.org.uk/ # v2
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/netfs/buffered_read.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/netfs/buffered_read.c b/fs/netfs/buffered_read.c
index baf668fb4315..7679a68e8193 100644
--- a/fs/netfs/buffered_read.c
+++ b/fs/netfs/buffered_read.c
@@ -17,9 +17,9 @@ void netfs_rreq_unlock_folios(struct netfs_io_request *rreq)
 {
 	struct netfs_io_subrequest *subreq;
 	struct folio *folio;
-	unsigned int iopos, account = 0;
 	pgoff_t start_page = rreq->start / PAGE_SIZE;
 	pgoff_t last_page = ((rreq->start + rreq->len) / PAGE_SIZE) - 1;
+	size_t account = 0;
 	bool subreq_failed = false;
 
 	XA_STATE(xas, &rreq->mapping->i_pages, start_page);
@@ -39,23 +39,23 @@ void netfs_rreq_unlock_folios(struct netfs_io_request *rreq)
 	 */
 	subreq = list_first_entry(&rreq->subrequests,
 				  struct netfs_io_subrequest, rreq_link);
-	iopos = 0;
 	subreq_failed = (subreq->error < 0);
 
 	trace_netfs_rreq(rreq, netfs_rreq_trace_unlock);
 
 	rcu_read_lock();
 	xas_for_each(&xas, folio, last_page) {
-		unsigned int pgpos, pgend;
+		loff_t pg_end;
 		bool pg_failed = false;
 
 		if (xas_retry(&xas, folio))
 			continue;
 
-		pgpos = (folio_index(folio) - start_page) * PAGE_SIZE;
-		pgend = pgpos + folio_size(folio);
+		pg_end = folio_pos(folio) + folio_size(folio) - 1;
 
 		for (;;) {
+			loff_t sreq_end;
+
 			if (!subreq) {
 				pg_failed = true;
 				break;
@@ -63,11 +63,11 @@ void netfs_rreq_unlock_folios(struct netfs_io_request *rreq)
 			if (test_bit(NETFS_SREQ_COPY_TO_CACHE, &subreq->flags))
 				folio_start_fscache(folio);
 			pg_failed |= subreq_failed;
-			if (pgend < iopos + subreq->len)
+			sreq_end = subreq->start + subreq->len - 1;
+			if (pg_end < sreq_end)
 				break;
 
 			account += subreq->transferred;
-			iopos += subreq->len;
 			if (!list_is_last(&subreq->rreq_link, &rreq->subrequests)) {
 				subreq = list_next_entry(subreq, rreq_link);
 				subreq_failed = (subreq->error < 0);
@@ -75,7 +75,8 @@ void netfs_rreq_unlock_folios(struct netfs_io_request *rreq)
 				subreq = NULL;
 				subreq_failed = false;
 			}
-			if (pgend == iopos)
+
+			if (pg_end == sreq_end)
 				break;
 		}
 
-- 
2.35.1



