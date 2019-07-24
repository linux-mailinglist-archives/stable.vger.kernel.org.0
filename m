Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37AEF7455B
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 07:41:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404699AbfGYFlp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 01:41:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:56572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404736AbfGYFlo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 01:41:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C02622C7D;
        Thu, 25 Jul 2019 05:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564033304;
        bh=n0MQC/8XsC7homZ2nSmclkxOg6rP27Bzh8F2sa/T2tI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YkObk3HUyyw+AS8cK5o41rINz6BgyHFVBVcNfhJbiucKtCgP68CnPacd9EHa0GotE
         EfNWhkhyVOPqY89iqynLkKYZiCxMvZDcaW1txEcajqUUsLPzhTHuH8DSzX4B8FbSfs
         KssShOBIMrVEJ+La9ZNxYuE/CMgcGMSObfLZiLjU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Coly Li <colyli@suse.de>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 125/271] bcache: check CACHE_SET_IO_DISABLE bit in bch_journal()
Date:   Wed, 24 Jul 2019 21:19:54 +0200
Message-Id: <20190724191705.986718330@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191655.268628197@linuxfoundation.org>
References: <20190724191655.268628197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 383ff2183ad16a8842d1fbd9dd3e1cbd66813e64 ]

When too many I/O errors happen on cache set and CACHE_SET_IO_DISABLE
bit is set, bch_journal() may continue to work because the journaling
bkey might be still in write set yet. The caller of bch_journal() may
believe the journal still work but the truth is in-memory journal write
set won't be written into cache device any more. This behavior may
introduce potential inconsistent metadata status.

This patch checks CACHE_SET_IO_DISABLE bit at the head of bch_journal(),
if the bit is set, bch_journal() returns NULL immediately to notice
caller to know journal does not work.

Signed-off-by: Coly Li <colyli@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/bcache/journal.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index f880e5eba8dd..8d4d63b51553 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -810,6 +810,10 @@ atomic_t *bch_journal(struct cache_set *c,
 	struct journal_write *w;
 	atomic_t *ret;
 
+	/* No journaling if CACHE_SET_IO_DISABLE set already */
+	if (unlikely(test_bit(CACHE_SET_IO_DISABLE, &c->flags)))
+		return NULL;
+
 	if (!CACHE_SYNC(&c->sb))
 		return NULL;
 
-- 
2.20.1



