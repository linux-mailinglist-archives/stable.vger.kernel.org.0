Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8015F7390E
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728820AbfGXTg0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:36:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:36060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728151AbfGXTgW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:36:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 086CF20449;
        Wed, 24 Jul 2019 19:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563996982;
        bh=bS0+cZVBNXT5EHX0ujiCyDSgPNBBhbRO0aYOZsxFEcA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RS4xcazwpiQtsh5z3XSVYRc4o0HANoionLRhT2FpKYWmG46iS+WE2JdIpQxEfNLXJ
         daIWs1a1+vI+k6mq8rvHvQwMzQQKzomvCzxiiI2IkP47v3Pmjlr++ihb1ihwEGZsj4
         2wr2IDwNaA0mbFCwj6J+XCxM7NJKOO2HebzKecTk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Coly Li <colyli@suse.de>,
        Shenghui Wang <shhuiw@foxmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.2 282/413] bcache: Revert "bcache: free heap cache_set->flush_btree in bch_journal_free"
Date:   Wed, 24 Jul 2019 21:19:33 +0200
Message-Id: <20190724191756.459354778@linuxfoundation.org>
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

From: Coly Li <colyli@suse.de>

commit ba82c1ac1667d6efb91a268edb13fc9cdaecec9b upstream.

This reverts commit 6268dc2c4703aabfb0b35681be709acf4c2826c6.

This patch depends on commit c4dc2497d50d ("bcache: fix high CPU
occupancy during journal") which is reverted in previous patch. So
revert this one too.

Fixes: 6268dc2c4703 ("bcache: free heap cache_set->flush_btree in bch_journal_free")
Signed-off-by: Coly Li <colyli@suse.de>
Cc: stable@vger.kernel.org
Cc: Shenghui Wang <shhuiw@foxmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/bcache/journal.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -843,7 +843,6 @@ void bch_journal_free(struct cache_set *
 	free_pages((unsigned long) c->journal.w[1].data, JSET_BITS);
 	free_pages((unsigned long) c->journal.w[0].data, JSET_BITS);
 	free_fifo(&c->journal.pin);
-	free_heap(&c->flush_btree);
 }
 
 int bch_journal_alloc(struct cache_set *c)


