Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24E9368D66
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 15:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733130AbfGON6U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 09:58:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:37666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733127AbfGON6U (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 09:58:20 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0EEF521530;
        Mon, 15 Jul 2019 13:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563199099;
        bh=O/9F1nKaAdS8UIBnIyxQ35h9j/J09OumKIb29035rnQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mmzWr81uZn5u1l0DRxUov0lGUc/FUSXYhFW66mW12d8Q6uuWa3lefjZAm8Y8CIBf1
         vKg3Bb2yYpsEcyq2uAZRZM/EcYtFg2zOWTbT4k+Lk/j8JF2z/6bcL+nbiM10g5i8la
         js9IXvnwllJPU2B6XjSi2oXDzOihKgdrVKrQgvmo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Coly Li <colyli@suse.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-bcache@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 192/249] bcache: fix return value error in bch_journal_read()
Date:   Mon, 15 Jul 2019 09:45:57 -0400
Message-Id: <20190715134655.4076-192-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715134655.4076-1-sashal@kernel.org>
References: <20190715134655.4076-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Coly Li <colyli@suse.de>

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

