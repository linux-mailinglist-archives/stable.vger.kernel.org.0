Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8CD36CC2B5
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233273AbjC1OsC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:48:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233200AbjC1Ory (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:47:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E0FCBDD1
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:47:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B169B81D78
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:47:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9681C4339E;
        Tue, 28 Mar 2023 14:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680014837;
        bh=OjCHyWVB1kb32huPEFPJqNwW1O4zE+vHGvq+hU5r4Kg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=opSlqdS2aulIJblp1/75zlkv/4ViIIQKsOGL7R4eXtIMqK5sZ6PCU41ThOor667Oy
         +AJknv1rPp0S1FFrmPAJD1yjqJih6TFObQyVxC//gECTlqxgmhDs0Us2r8NCBrkE4r
         IFrVE/OtrdNiWJmZE7x02EUTMlUJNyD3tuCaUGME=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Al Viro <viro@zeniv.linux.org.uk>,
        Dario Lesca <d.lesca@solinos.it>,
        David Critch <dcritch@redhat.com>,
        Jeff Layton <jlayton@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 040/240] nfsd: dont replace page in rq_pages if its a continuation of last page
Date:   Tue, 28 Mar 2023 16:40:03 +0200
Message-Id: <20230328142621.260573786@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 27c934dd8832dd40fd34776f916dc201e18b319b ]

The splice read calls nfsd_splice_actor to put the pages containing file
data into the svc_rqst->rq_pages array. It's possible however to get a
splice result that only has a partial page at the end, if (e.g.) the
filesystem hands back a short read that doesn't cover the whole page.

nfsd_splice_actor will plop the partial page into its rq_pages array and
return. Then later, when nfsd_splice_actor is called again, the
remainder of the page may end up being filled out. At this point,
nfsd_splice_actor will put the page into the array _again_ corrupting
the reply. If this is done enough times, rq_next_page will overrun the
array and corrupt the trailing fields -- the rq_respages and
rq_next_page pointers themselves.

If we've already added the page to the array in the last pass, don't add
it to the array a second time when dealing with a splice continuation.
This was originally handled properly in nfsd_splice_actor, but commit
91e23b1c3982 ("NFSD: Clean up nfsd_splice_actor()") removed the check
for it.

Fixes: 91e23b1c3982 ("NFSD: Clean up nfsd_splice_actor()")
Cc: Al Viro <viro@zeniv.linux.org.uk>
Reported-by: Dario Lesca <d.lesca@solinos.it>
Tested-by: David Critch <dcritch@redhat.com>
Link: https://bugzilla.redhat.com/show_bug.cgi?id=2150630
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/vfs.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index bb1e85586dfdd..5308070a47f38 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -937,8 +937,15 @@ nfsd_splice_actor(struct pipe_inode_info *pipe, struct pipe_buffer *buf,
 	struct page *last_page;
 
 	last_page = page + (offset + sd->len - 1) / PAGE_SIZE;
-	for (page += offset / PAGE_SIZE; page <= last_page; page++)
+	for (page += offset / PAGE_SIZE; page <= last_page; page++) {
+		/*
+		 * Skip page replacement when extending the contents
+		 * of the current page.
+		 */
+		if (page == *(rqstp->rq_next_page - 1))
+			continue;
 		svc_rqst_replace_page(rqstp, page);
+	}
 	if (rqstp->rq_res.page_len == 0)	// first call
 		rqstp->rq_res.page_base = offset % PAGE_SIZE;
 	rqstp->rq_res.page_len += sd->len;
-- 
2.39.2



