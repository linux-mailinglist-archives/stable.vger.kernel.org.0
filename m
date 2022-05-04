Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02D7851A851
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355515AbiEDRKY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:10:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355756AbiEDRIu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:08:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93133515A5;
        Wed,  4 May 2022 09:54:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0BBBCB827A5;
        Wed,  4 May 2022 16:54:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FD6EC385A4;
        Wed,  4 May 2022 16:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683269;
        bh=bRQrtA7Sj1ZggibkRz6ZFK9KJkXGdhVaf5iHCb6wSws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eXY4ksjVQkqH97LIz4owDIvDmY777u3yRqnXpOa/t/zCijpG8fiqjKicaj+O5RxST
         MHvCiwD/yyIkwqdwzmEwKY/UYQ7s0ZLAE5a6+BlIEqlr/Bdtwl7RgfUCB/Uz05hQeB
         1Rfw1c5RvodkQjnwqeHdmw1KXxUr9WCawQ7JjHSQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 119/177] gfs2: Prevent endless loops in gfs2_file_buffered_write
Date:   Wed,  4 May 2022 18:45:12 +0200
Message-Id: <20220504153103.816946873@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153053.873100034@linuxfoundation.org>
References: <20220504153053.873100034@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 554c577cee95bdc1d03d9f457e57dc96eb791845 ]

Currently, instead of performing a short write,
iomap_file_buffered_write will fail when part of its iov iterator cannot
be read.  In contrast, gfs2_file_buffered_write will loop around if it
can read part of the iov iterator, so we can end up in an endless loop.

This should be fixed in iomap_file_buffered_write (and also
generic_perform_write), but this comes a bit late in the 5.16
development cycle, so work around it in the filesystem by
trimming the iov iterator to the known-good size for now.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/file.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 247b8d95b5ef..97e2793e22d7 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -1021,6 +1021,7 @@ static ssize_t gfs2_file_buffered_write(struct kiocb *iocb,
 	struct gfs2_sbd *sdp = GFS2_SB(inode);
 	struct gfs2_holder *statfs_gh = NULL;
 	size_t prev_count = 0, window_size = 0;
+	size_t orig_count = iov_iter_count(from);
 	size_t read = 0;
 	ssize_t ret;
 
@@ -1065,6 +1066,7 @@ static ssize_t gfs2_file_buffered_write(struct kiocb *iocb,
 	if (inode == sdp->sd_rindex)
 		gfs2_glock_dq_uninit(statfs_gh);
 
+	from->count = orig_count - read;
 	if (should_fault_in_pages(ret, from, &prev_count, &window_size)) {
 		size_t leftover;
 
@@ -1072,6 +1074,7 @@ static ssize_t gfs2_file_buffered_write(struct kiocb *iocb,
 		leftover = fault_in_iov_iter_readable(from, window_size);
 		gfs2_holder_disallow_demote(gh);
 		if (leftover != window_size) {
+			from->count = min(from->count, window_size - leftover);
 			if (!gfs2_holder_queued(gh)) {
 				if (read)
 					goto out_uninit;
-- 
2.35.1



