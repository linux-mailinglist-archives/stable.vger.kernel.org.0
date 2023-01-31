Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CEBA683030
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 16:00:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232575AbjAaPAc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 10:00:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232455AbjAaPAK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Jan 2023 10:00:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEDFA1DBAE;
        Tue, 31 Jan 2023 07:00:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6BA7B6155C;
        Tue, 31 Jan 2023 15:00:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17405C4339C;
        Tue, 31 Jan 2023 15:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675177208;
        bh=KgPu11W9K9teAZpNvLupPUTrxwKuy9OLtdD/HC0mjhk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b+MCLDeoPGDLPvoOQxJzU+quZbZZOj/t9N0WIIXD4K0K/QudVSxv0xu/bGVmEuZaK
         bAJQcasn+ADnkhr8CCMLPKImIHhkOFnSrQQrYAdn8aejuNYDRYOzZoSV95kkDov/dc
         ECoq1ekHd/Mcvzi3I935F35t8DCw/lJc7WBdoh9HiG5yJrfvt0zE2KhFVzDD96zum2
         83BuihbUpZoxdUGn2eoLUE4b+fndCKrDYPzbGRiMt8nar22xjGJ28PofM9XJzij5P0
         6iRA73PfHGVxD/k1brQKQ3ZCidSlpU7flsLfaBeNGmncXpR2qWXTkGRlS8m13BWhO8
         x1O7QjuBJyEQQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andreas Gruenbacher <agruenba@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, rpeterso@redhat.com,
        cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 6.1 10/20] Revert "gfs2: stop using generic_writepages in gfs2_ail1_start_one"
Date:   Tue, 31 Jan 2023 09:59:36 -0500
Message-Id: <20230131145946.1249850-10-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230131145946.1249850-1-sashal@kernel.org>
References: <20230131145946.1249850-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 95ecbd0f162fc06ef4c4045a66f653f47b62a2d3 ]

Commit b2b0a5e97855 switched from generic_writepages() to
filemap_fdatawrite_wbc() in gfs2_ail1_start_one() on the path to
replacing ->writepage() with ->writepages() and eventually eliminating
the former.  Function gfs2_ail1_start_one() is called from
gfs2_log_flush(), our main function for flushing the filesystem log.

Unfortunately, at least as implemented today, ->writepage() and
->writepages() are entirely different operations for journaled data
inodes: while the former creates and submits transactions covering the
data to be written, the latter flushes dirty buffers out to disk.

With gfs2_ail1_start_one() now calling ->writepages(), we end up
creating filesystem transactions while we are in the course of a log
flush, which immediately deadlocks on the sdp->sd_log_flush_lock
semaphore.

Work around that by going back to how things used to work before commit
b2b0a5e97855 for now; figuring out a superior solution will take time we
don't have available right now.  However ...

Since the removal of generic_writepages() is imminent, open-code it
here.  We're already inside a blk_start_plug() ...  blk_finish_plug()
section here, so skip that part of the original generic_writepages().

This reverts commit b2b0a5e978552e348f85ad9c7568b630a5ede659.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Acked-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/log.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index 723639376ae2..61323deb80bc 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -80,6 +80,15 @@ void gfs2_remove_from_ail(struct gfs2_bufdata *bd)
 	brelse(bd->bd_bh);
 }
 
+static int __gfs2_writepage(struct page *page, struct writeback_control *wbc,
+		       void *data)
+{
+	struct address_space *mapping = data;
+	int ret = mapping->a_ops->writepage(page, wbc);
+	mapping_set_error(mapping, ret);
+	return ret;
+}
+
 /**
  * gfs2_ail1_start_one - Start I/O on a transaction
  * @sdp: The superblock
@@ -131,7 +140,7 @@ __acquires(&sdp->sd_ail_lock)
 		if (!mapping)
 			continue;
 		spin_unlock(&sdp->sd_ail_lock);
-		ret = filemap_fdatawrite_wbc(mapping, wbc);
+		ret = write_cache_pages(mapping, wbc, __gfs2_writepage, mapping);
 		if (need_resched()) {
 			blk_finish_plug(plug);
 			cond_resched();
-- 
2.39.0

