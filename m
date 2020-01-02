Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33A8412EE8A
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:40:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731426AbgABWjQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:39:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:54930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731075AbgABWjQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:39:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6421217F4;
        Thu,  2 Jan 2020 22:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578004755;
        bh=0Uf6/eakuHv0RxJRP5QLczbHPxCFOinkZd+1IggRG1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q3I7NqlDUHxrhGBGt/YFutU/QVfipgzKlOnbr+yzkpvE4Z/2FIKGPsZrmWl22WK6E
         tHSXRzsxtDslY1vnR+w5+GaQP3yoIqhs6qC+vzzM1auU2BgQqBN0m990uCuXEOLhwB
         LsANSmVDhghmVnsUMtcAVZmm5hsGbifLEhWGBSZs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Coly Li <colyli@suse.de>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 114/137] bcache: at least try to shrink 1 node in bch_mca_scan()
Date:   Thu,  2 Jan 2020 23:08:07 +0100
Message-Id: <20200102220602.500489232@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220546.618583146@linuxfoundation.org>
References: <20200102220546.618583146@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Coly Li <colyli@suse.de>

[ Upstream commit 9fcc34b1a6dd4b8e5337e2b6ef45e428897eca6b ]

In bch_mca_scan(), the number of shrinking btree node is calculated
by code like this,
	unsigned long nr = sc->nr_to_scan;

        nr /= c->btree_pages;
        nr = min_t(unsigned long, nr, mca_can_free(c));
variable sc->nr_to_scan is number of objects (here is bcache B+tree
nodes' number) to shrink, and pointer variable sc is sent from memory
management code as parametr of a callback.

If sc->nr_to_scan is smaller than c->btree_pages, after the above
calculation, variable 'nr' will be 0 and nothing will be shrunk. It is
frequeently observed that only 1 or 2 is set to sc->nr_to_scan and make
nr to be zero. Then bch_mca_scan() will do nothing more then acquiring
and releasing mutex c->bucket_lock.

This patch checkes whether nr is 0 after the above calculation, if 0
is the result then set 1 to variable 'n'. Then at least bch_mca_scan()
will try to shrink a single B+tree node.

Signed-off-by: Coly Li <colyli@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/bcache/btree.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 05aa3ac1381b..5c93582c71cc 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -686,6 +686,8 @@ static unsigned long bch_mca_scan(struct shrinker *shrink,
 	 * IO can always make forward progress:
 	 */
 	nr /= c->btree_pages;
+	if (nr == 0)
+		nr = 1;
 	nr = min_t(unsigned long, nr, mca_can_free(c));
 
 	i = 0;
-- 
2.20.1



