Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A95636C726E
	for <lists+stable@lfdr.de>; Thu, 23 Mar 2023 22:39:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231636AbjCWVjm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Mar 2023 17:39:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231307AbjCWVj1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Mar 2023 17:39:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B1A7212B9;
        Thu, 23 Mar 2023 14:39:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A5736628D9;
        Thu, 23 Mar 2023 21:39:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F247AC433D2;
        Thu, 23 Mar 2023 21:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679607561;
        bh=2wm98QIcutJIPgtolx5FVuBVp/ZTzCYN6ELSU1GVJ+E=;
        h=From:To:Cc:Subject:Date:From;
        b=VgfIv3JLWTq1Cz8h4wTsFvDi6OnP3/tmT4HLn/sDHRSwuw1Lh9uv94rv3Uk6+Gg2x
         vdpEUmUvTnYVYjoYEQQwgs3zUDGQGN+cJAdX64WlTWAtSdz9iuCCGnPRYT7+w7FhDV
         YmFMz8UlLL1t00HS+ZDBRTDUDNUY67y9ZHsbXXoG0Z3fVs42+xUfN24H3zjXlyEp2w
         ahesitRXao4kQ9t2c0tl6w+nGOu4h/fVQRi+b2tR67EUc0PoTR0Wf0jzXA4sfKVj89
         OsYxSqKzOiLUjPMTOVwmniCt6Ozt6O8DOFZmaDBww0V4LCP6GRzqgMuHERN44zIUNg
         yFnMpSuswvY6g==
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, stable@vger.kernel.org
Subject: [PATCH] f2fs: get out of a repeat loop when getting a locked data page
Date:   Thu, 23 Mar 2023 14:39:19 -0700
Message-Id: <20230323213919.1876157-1-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=216050

Somehow we're getting a page which has a different mapping.
Let's avoid the infinite loop.

Cc: <stable@vger.kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/data.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index bf51e6e4eb64..80702c93e885 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -1329,18 +1329,14 @@ struct page *f2fs_get_lock_data_page(struct inode *inode, pgoff_t index,
 {
 	struct address_space *mapping = inode->i_mapping;
 	struct page *page;
-repeat:
+
 	page = f2fs_get_read_data_page(inode, index, 0, for_write, NULL);
 	if (IS_ERR(page))
 		return page;
 
 	/* wait for read completion */
 	lock_page(page);
-	if (unlikely(page->mapping != mapping)) {
-		f2fs_put_page(page, 1);
-		goto repeat;
-	}
-	if (unlikely(!PageUptodate(page))) {
+	if (unlikely(page->mapping != mapping || !PageUptodate(page))) {
 		f2fs_put_page(page, 1);
 		return ERR_PTR(-EIO);
 	}
-- 
2.40.0.348.gf938b09366-goog

