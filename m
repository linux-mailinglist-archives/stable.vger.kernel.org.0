Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C67A594D3F
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:34:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242779AbiHPAry (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:47:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348224AbiHPAqO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:46:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5424194E59;
        Mon, 15 Aug 2022 13:44:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E8BFDB811A0;
        Mon, 15 Aug 2022 20:44:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24C9EC433C1;
        Mon, 15 Aug 2022 20:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596271;
        bh=5IEb6acwQmYQthvmIkjzgYaEeuiFuIMa3jBkhoCvLuA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BaHVYEMRGq7GckSXZ+LN9Fy6Sy7XFpySbU86/l4KwwO1uoeme+FIzA55uJb6MIvpd
         t/EwyyuddGXEeC8fqn9r10fOfqBaF/iEIGmW3edjX/NaAkWpePqh+xsMWmlkNeNib0
         ZTnVgOJw0vCAt65JVI1b29OK6Yp7Wh1FbGbBjkOM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Jeff Layton <jlayton@kernel.org>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 1009/1157] cifs: Fix memory leak when using fscache
Date:   Mon, 15 Aug 2022 20:06:05 +0200
Message-Id: <20220815180520.207005048@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit c6f62f81b488d00afaa86bae26c6ce9ab12c709e ]

If we hit the 'index == next_cached' case, we leak a refcount on the
struct page.  Fix this by using readahead_folio() which takes care of
the refcount for you.

Fixes: 0174ee9947bd ("cifs: Implement cache I/O by accessing the cache directly")
Cc: David Howells <dhowells@redhat.com>
Cc: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/file.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index e64cda7a7610..6985710e14c2 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -4459,10 +4459,10 @@ static void cifs_readahead(struct readahead_control *ractl)
 				 * TODO: Send a whole batch of pages to be read
 				 * by the cache.
 				 */
-				page = readahead_page(ractl);
-				last_batch_size = 1 << thp_order(page);
+				struct folio *folio = readahead_folio(ractl);
+				last_batch_size = folio_nr_pages(folio);
 				if (cifs_readpage_from_fscache(ractl->mapping->host,
-							       page) < 0) {
+							       &folio->page) < 0) {
 					/*
 					 * TODO: Deal with cache read failure
 					 * here, but for the moment, delegate
@@ -4470,7 +4470,7 @@ static void cifs_readahead(struct readahead_control *ractl)
 					 */
 					caching = false;
 				}
-				unlock_page(page);
+				folio_unlock(folio);
 				next_cached++;
 				cache_nr_pages--;
 				if (cache_nr_pages == 0)
-- 
2.35.1



