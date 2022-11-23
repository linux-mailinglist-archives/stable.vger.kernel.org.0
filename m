Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 235E1635881
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236557AbiKWJ6x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:58:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236563AbiKWJ6O (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:58:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D4CC10B50
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:52:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05848B81EEB
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:52:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52512C433C1;
        Wed, 23 Nov 2022 09:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669197142;
        bh=DVzPFYmPxRKKl19tDbqvP0y3Z//i1XNc7JEovN0SF9w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rQgDO4mLpXaJIELWYQDM+Sa6B730KeJ9mNqi1pZEY5FxU4v8x4udiUzR4Ei9H6RJg
         5Bblaur4v7HGiTM9W6USHGD+Jso+8yAuj0pVuVtXTYoWzFmMqc3HIu8MMQ6ttj5qEF
         4f3T8hlo4rzoQevcNBu1OeJJMbM2DFk6+lgqzY8g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, David Howells <dhowells@redhat.com>,
        Gao Xiang <hsiangkao@linux.alibaba.com>,
        Jia Zhu <zhujia.zj@bytedance.com>,
        Jingbo Xu <jefflexu@linux.alibaba.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 168/314] erofs: fix missing xas_retry() in fscache mode
Date:   Wed, 23 Nov 2022 09:50:13 +0100
Message-Id: <20221123084633.181666314@linuxfoundation.org>
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

From: Jingbo Xu <jefflexu@linux.alibaba.com>

[ Upstream commit 37020bbb71d911431e16c2c940b97cf86ae4f2f6 ]

The xarray iteration only holds the RCU read lock and thus may encounter
XA_RETRY_ENTRY if there's process modifying the xarray concurrently.
This will cause oops when referring to the invalid entry.

Fix this by adding the missing xas_retry(), which will make the
iteration wind back to the root node if XA_RETRY_ENTRY is encountered.

Fixes: d435d53228dd ("erofs: change to use asynchronous io for fscache readpage/readahead")
Suggested-by: David Howells <dhowells@redhat.com>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Reviewed-by: Jia Zhu <zhujia.zj@bytedance.com>
Signed-off-by: Jingbo Xu <jefflexu@linux.alibaba.com>
Link: https://lore.kernel.org/r/20221114121943.29987-1-jefflexu@linux.alibaba.com
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/fscache.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/erofs/fscache.c b/fs/erofs/fscache.c
index 79af25f0a56c..46ab2b3f9a3c 100644
--- a/fs/erofs/fscache.c
+++ b/fs/erofs/fscache.c
@@ -69,11 +69,15 @@ static void erofs_fscache_rreq_unlock_folios(struct netfs_io_request *rreq)
 
 	rcu_read_lock();
 	xas_for_each(&xas, folio, last_page) {
-		unsigned int pgpos =
-			(folio_index(folio) - start_page) * PAGE_SIZE;
-		unsigned int pgend = pgpos + folio_size(folio);
+		unsigned int pgpos, pgend;
 		bool pg_failed = false;
 
+		if (xas_retry(&xas, folio))
+			continue;
+
+		pgpos = (folio_index(folio) - start_page) * PAGE_SIZE;
+		pgend = pgpos + folio_size(folio);
+
 		for (;;) {
 			if (!subreq) {
 				pg_failed = true;
-- 
2.35.1



