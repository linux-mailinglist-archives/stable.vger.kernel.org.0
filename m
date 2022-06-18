Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A684355075B
	for <lists+stable@lfdr.de>; Sun, 19 Jun 2022 00:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230471AbiFRWqP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Jun 2022 18:46:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbiFRWqP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Jun 2022 18:46:15 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5424BC31;
        Sat, 18 Jun 2022 15:46:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id F10A1CE0861;
        Sat, 18 Jun 2022 22:46:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21A14C3411A;
        Sat, 18 Jun 2022 22:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655592369;
        bh=V7chkL2A5m6qQLgPvjeycpUuzNA+cLG9L2qrqHYLUSg=;
        h=From:To:Cc:Subject:Date:From;
        b=F29zOKh+AdueVTj4VXMYrX/smopNogx5c75t0KuMKQ1eaBz2c5o0eD+vjXtb9XN2j
         VKlbYcFrjCrt0+ML7E8sRmaflzz27K1dWapfGzQhzLwIVbt4tWiXFUuCPBz3RniR9Q
         ySQu2lNEEwlut7osVxn7csDmMLqZa1gKsjalUC6WPvKHWVv3F2W+YHjIocuf5gPmJl
         UVwmWG8Q5Y2iOzTqRAwNsB/K5claNV7Rk1TnLjwO0ORYhoRrR/5aX20lds/zcIUDXd
         D1XECy9bF4vihzSxa4QSzLerg7NFbHcCqxZN2TtaNSP1/2g92FXIP1Uu2FO4r13IbC
         Og7SnABFnTDFg==
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, stable@vger.kernel.org
Subject: [PATCH] f2fs: do not count ENOENT for error case
Date:   Sat, 18 Jun 2022 15:46:06 -0700
Message-Id: <20220618224606.1554706-1-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
MIME-Version: 1.0
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

Otherwise, we can get a wrong cp_error mark.

Cc: <stable@vger.kernel.org>
Fixes: a7b8618aa2f0 ("f2fs: avoid infinite loop to flush node pages")
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/node.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 4181d03a7ef7..095a634436e3 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1450,7 +1450,9 @@ static struct page *__get_node_page(struct f2fs_sb_info *sbi, pgoff_t nid,
 out_err:
 	ClearPageUptodate(page);
 out_put_err:
-	f2fs_handle_page_eio(sbi, page->index, NODE);
+	/* ENOENT comes from read_node_page which is not an error. */
+	if (err != -ENOENT)
+		f2fs_handle_page_eio(sbi, page->index, NODE);
 	f2fs_put_page(page, 1);
 	return ERR_PTR(err);
 }
-- 
2.36.1.476.g0c4daa206d-goog

