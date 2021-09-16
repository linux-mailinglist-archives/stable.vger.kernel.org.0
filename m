Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F0E240E5FC
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345953AbhIPRRE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:17:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:34166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346545AbhIPRFS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:05:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 08CC161B1C;
        Thu, 16 Sep 2021 16:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810112;
        bh=Cck+dXftzkLrcA22ZZHAK/uDUVPfUpcQBGQdQ6b1Aho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FcchjMTEsod9Gu1wXjWq7+DQ08tHdIZtIKlm9jfr7YcJXpZw9Bv9qHSaZd75Q4lC3
         VjCf0+caqD6V/c/shhdJxrE3lIUxRBXCOLR54iLzkQzIiQIjof5G5RV45s9JaPIO3M
         JFbS/GyhiP6PGhuXJqQfOSYu3HP5EHdQK7CTFKBU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.14 003/432] io_uring: place fixed tables under memcg limits
Date:   Thu, 16 Sep 2021 17:55:52 +0200
Message-Id: <20210916155810.938190192@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

commit 0bea96f59ba40e63c0ae93ad6a02417b95f22f4d upstream.

Fixed tables may be large enough, place all of them together with
allocated tags under memcg limits.

Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/b3ac9f5da9821bb59837b5fe25e8ef4be982218c.1629451684.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7126,14 +7126,14 @@ static void **io_alloc_page_table(size_t
 	size_t init_size = size;
 	void **table;
 
-	table = kcalloc(nr_tables, sizeof(*table), GFP_KERNEL);
+	table = kcalloc(nr_tables, sizeof(*table), GFP_KERNEL_ACCOUNT);
 	if (!table)
 		return NULL;
 
 	for (i = 0; i < nr_tables; i++) {
 		unsigned int this_size = min_t(size_t, size, PAGE_SIZE);
 
-		table[i] = kzalloc(this_size, GFP_KERNEL);
+		table[i] = kzalloc(this_size, GFP_KERNEL_ACCOUNT);
 		if (!table[i]) {
 			io_free_page_table(table, init_size);
 			return NULL;


