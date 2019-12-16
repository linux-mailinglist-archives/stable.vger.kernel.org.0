Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7457212171F
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:34:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728540AbfLPSdd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:33:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:51870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730114AbfLPSJ2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:09:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE59A206EC;
        Mon, 16 Dec 2019 18:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519767;
        bh=1H4ky51eCvfkA+t3HWKdQkyac9iCEkW5S//8SSJUL58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lp5Samxdfr0IyWlEE+Pdkf3s/7ceLg6mkwZ+dGumGR+S5MViwS7tJxXEtiME1m80s
         J84zWjrF80GSm4czKemiSVJowGtMxDFU99gNImy/aHGfgTbnYzB0287SLRSvJrcKtQ
         7H8hiWsE3sGLOkBjOeUonV3jrlYWxqwHEpjwx0/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.3 059/180] btrfs: Avoid getting stuck during cyclic writebacks
Date:   Mon, 16 Dec 2019 18:48:19 +0100
Message-Id: <20191216174828.761022157@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174806.018988360@linuxfoundation.org>
References: <20191216174806.018988360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tejun Heo <tj@kernel.org>

commit f7bddf1e27d18fbc7d3e3056ba449cfbe4e20b0a upstream.

During a cyclic writeback, extent_write_cache_pages() uses done_index
to update the writeback_index after the current run is over.  However,
instead of current index + 1, it gets to to the current index itself.

Unfortunately, this, combined with returning on EOF instead of looping
back, can lead to the following pathlogical behavior.

1. There is a single file which has accumulated enough dirty pages to
   trigger balance_dirty_pages() and the writer appending to the file
   with a series of short writes.

2. balance_dirty_pages kicks in, wakes up background writeback and sleeps.

3. Writeback kicks in and the cursor is on the last page of the dirty
   file.  Writeback is started or skipped if already in progress.  As
   it's EOF, extent_write_cache_pages() returns and the cursor is set
   to done_index which is pointing to the last page.

4. Writeback is done.  Nothing happens till balance_dirty_pages
   finishes, at which point we go back to #1.

This can almost completely stall out writing back of the file and keep
the system over dirty threshold for a long time which can mess up the
whole system.  We encountered this issue in production with a package
handling application which can reliably reproduce the issue when
running under tight memory limits.

Reading the comment in the error handling section, this seems to be to
avoid accidentally skipping a page in case the write attempt on the
page doesn't succeed.  However, this concern seems bogus.

On each page, the code either:

* Skips and moves onto the next page.

* Fails issue and sets done_index to index + 1.

* Successfully issues and continue to the next page if budget allows
  and not EOF.

IOW, as long as it's not EOF and there's budget, the code never
retries writing back the same page.  Only when a page happens to be
the last page of a particular run, we end up retrying the page, which
can't possibly guarantee anything data integrity related.  Besides,
cyclic writes are only used for non-syncing writebacks meaning that
there's no data integrity implication to begin with.

Fix it by always setting done_index past the current page being
processed.

Note that this problem exists in other writepages too.

CC: stable@vger.kernel.org # 4.19+
Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/extent_io.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4117,7 +4117,7 @@ retry:
 		for (i = 0; i < nr_pages; i++) {
 			struct page *page = pvec.pages[i];
 
-			done_index = page->index;
+			done_index = page->index + 1;
 			/*
 			 * At this point we hold neither the i_pages lock nor
 			 * the page lock: the page may be truncated or
@@ -4152,16 +4152,6 @@ retry:
 
 			ret = __extent_writepage(page, wbc, epd);
 			if (ret < 0) {
-				/*
-				 * done_index is set past this page,
-				 * so media errors will not choke
-				 * background writeout for the entire
-				 * file. This has consequences for
-				 * range_cyclic semantics (ie. it may
-				 * not be suitable for data integrity
-				 * writeout).
-				 */
-				done_index = page->index + 1;
 				done = 1;
 				break;
 			}


