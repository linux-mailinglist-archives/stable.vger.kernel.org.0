Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA00738A4
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:31:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388512AbfGXTbk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:31:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:52758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388508AbfGXTbk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:31:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2B20229F4;
        Wed, 24 Jul 2019 19:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563996699;
        bh=CqXxNtD2vspp+3QgYdEnCTTV27NiT+7gb4tIhi/978E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eHSn6HCJ+QcTyPvb8QRnk+NgnVkcnUcVHChikb4S5A7AQTMjjG2N3egf1PNwuCSjP
         Dc+dyJClkyFQtQ9aDLe58UyLBkQf55I/bNE1eIj0MpA6cZmcnHCplagL3NB/epuQeh
         DTp/fUvyySLP9wMwzBogFAHbjyFPUMZHvl+r/Xq0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Coly Li <colyli@suse.de>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 186/413] bcache: fix return value error in bch_journal_read()
Date:   Wed, 24 Jul 2019 21:17:57 +0200
Message-Id: <20190724191748.036726271@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 0ae49cb7aa005ed18fe8f4d6ccf73019b78ac7b2 ]

When everything is OK in bch_journal_read(), finally the return value
is returned by,
	return ret;
which assumes ret will be 0 here. This assumption is wrong when all
journal buckets as are full and filled with valid journal entries. In
such cache the last location referencess read_bucket() sets 'ret' to
1, which means new jset added into jset list. The jset list is list
'journal' in caller run_cache_set().

Return 1 to run_cache_set() means something wrong and the cache set
won't start, but indeed everything is OK.

This patch changes the line at end of bch_journal_read() to directly
return 0 since everything if verything is good. Then a bogus error
is fixed.

Signed-off-by: Coly Li <colyli@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/bcache/journal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index 12dae9348147..4e5fc05720fc 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -268,7 +268,7 @@ int bch_journal_read(struct cache_set *c, struct list_head *list)
 					    struct journal_replay,
 					    list)->j.seq;
 
-	return ret;
+	return 0;
 #undef read_bucket
 }
 
-- 
2.20.1



