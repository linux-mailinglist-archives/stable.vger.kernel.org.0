Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04E8412F0AA
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:54:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728578AbgABWym (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:54:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:37672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728287AbgABWUV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:20:21 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E32692253D;
        Thu,  2 Jan 2020 22:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003620;
        bh=X+Do8u5S6VNWIX901s2stI315wdsbjiGl6J8hVjzR6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kyPrkMmWqLvNC/AVRakl0cvVPcOpizbFeR0/cF+FvCVKSvgfkSuGMs8ox39fz/Dbi
         ZTfdJ7NMpVxUyeg+bZ0SJY8Z7UuDhdFnTrVMjafzXpeURPesCbZxLpOj0QpEbvB6dX
         wwvGgQYW5om0ECh114vGVIFaVc0OxIEySxnCYDcc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Coly Li <colyli@suse.de>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 044/114] bcache: at least try to shrink 1 node in bch_mca_scan()
Date:   Thu,  2 Jan 2020 23:06:56 +0100
Message-Id: <20200102220033.534038277@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220029.183913184@linuxfoundation.org>
References: <20200102220029.183913184@linuxfoundation.org>
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
index 45f684689c35..bb40bd66a10e 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -713,6 +713,8 @@ static unsigned long bch_mca_scan(struct shrinker *shrink,
 	 * IO can always make forward progress:
 	 */
 	nr /= c->btree_pages;
+	if (nr == 0)
+		nr = 1;
 	nr = min_t(unsigned long, nr, mca_can_free(c));
 
 	i = 0;
-- 
2.20.1



