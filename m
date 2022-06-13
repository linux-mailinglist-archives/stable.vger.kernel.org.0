Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 732895491B2
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358785AbiFMNH3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:07:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357373AbiFMNGV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:06:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FF5537031;
        Mon, 13 Jun 2022 04:18:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 45523B80E59;
        Mon, 13 Jun 2022 11:18:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2E74C34114;
        Mon, 13 Jun 2022 11:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119103;
        bh=tHIsGFpR7q/TosDWqEXy1dnboeAXtwvPMfpL3sWrWzo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xPSeiv6qlzeGszAGWr+5rzVsCyPWahFw+DjMEO2wL7xImEp/Cb8c9a9jNZbGMGguq
         6zXuNF3EVwuWLxPHncu71y/93WIt6Jw+hLahZcD8Nt9TI4UbEQgHTvacNFBQJDTXQB
         EB92NGoq/jsne/719dt+eTPLBGlj4J1NTzAWq944=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 105/247] afs: Fix infinite loop found by xfstest generic/676
Date:   Mon, 13 Jun 2022 12:10:07 +0200
Message-Id: <20220613094926.141733828@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094922.843438024@linuxfoundation.org>
References: <20220613094922.843438024@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 17eabd42560f4636648ad65ba5b20228071e2363 ]

In AFS, a directory is handled as a file that the client downloads and
parses locally for the purposes of performing lookup and getdents
operations.  The in-kernel afs filesystem has a number of functions that
do this.

A directory file is arranged as a series of 2K blocks divided into
32-byte slots, where a directory entry occupies one or more slots, plus
each block starts with one or more metadata blocks.

When parsing a block, if the last slots are occupied by a dirent that
occupies more than a single slot and the file position points at a slot
that's not the initial one, the logic in afs_dir_iterate_block() that
skips over it won't advance the file pointer to the end of it.  This
will cause an infinite loop in getdents() as it will keep retrying that
block and failing to advance beyond the final entry.

Fix this by advancing the file pointer if the next entry will be beyond
it when we skip a block.

This was found by the generic/676 xfstest but can also be triggered with
something like:

	~/xfstests-dev/src/t_readdir_3 /xfstest.test/z 4000 1

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Marc Dionne <marc.dionne@auristor.com>
Tested-by: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Link: http://lore.kernel.org/r/165391973497.110268.2939296942213894166.stgit@warthog.procyon.org.uk/
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/dir.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index 4579bbda4634..948a808a964d 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -486,8 +486,11 @@ static int afs_dir_iterate_block(struct afs_vnode *dvnode,
 		}
 
 		/* skip if starts before the current position */
-		if (offset < curr)
+		if (offset < curr) {
+			if (next > curr)
+				ctx->pos = blkoff + next * sizeof(union afs_xdr_dirent);
 			continue;
+		}
 
 		/* found the next entry */
 		if (!dir_emit(ctx, dire->u.name, nlen,
-- 
2.35.1



