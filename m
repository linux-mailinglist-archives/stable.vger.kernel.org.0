Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB1421CAD5
	for <lists+stable@lfdr.de>; Sun, 12 Jul 2020 19:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729315AbgGLRrv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Jul 2020 13:47:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:38540 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728882AbgGLRrv (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 12 Jul 2020 13:47:51 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 7B229AD4B;
        Sun, 12 Jul 2020 17:47:51 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>,
        Ken Raeburn <raeburn@redhat.com>, stable@vger.kernel.org
Subject: [PATCH 1/2] bcache: avoid nr_stripes overflow in bcache_device_init()
Date:   Mon, 13 Jul 2020 01:47:35 +0800
Message-Id: <20200712174736.9840-1-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

For some block devices which large capacity (e.g. 8TB) but small io_opt
size (e.g. 8 sectors), in bcache_device_init() the stripes number calcu-
lated by,
	DIV_ROUND_UP_ULL(sectors, d->stripe_size);
might be overflow to the unsigned int bcache_device->nr_stripes.

This patch uses an unsigned long variable to store DIV_ROUND_UP_ULL()
and after the value is checked to be available in unsigned int range,
sets it to bache_device->nr_stripes. Then the overflow is avoided.

Reported-by: Ken Raeburn <raeburn@redhat.com>
Signed-off-by: Coly Li <colyli@suse.de>
Link: https://bugzilla.redhat.com/show_bug.cgi?id=1783075
Cc: stable@vger.kernel.org
---
 drivers/md/bcache/super.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index a239fcaec70b..0c25ebc035b1 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -886,19 +886,19 @@ static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
 	struct request_queue *q;
 	const size_t max_stripes = min_t(size_t, INT_MAX,
 					 SIZE_MAX / sizeof(atomic_t));
-	size_t n;
+	unsigned long n;
 	int idx;
 
 	if (!d->stripe_size)
 		d->stripe_size = 1 << 31;
 
-	d->nr_stripes = DIV_ROUND_UP_ULL(sectors, d->stripe_size);
-
-	if (!d->nr_stripes || d->nr_stripes > max_stripes) {
-		pr_err("nr_stripes too large or invalid: %u (start sector beyond end of disk?)\n",
-			(unsigned int)d->nr_stripes);
+	n = DIV_ROUND_UP_ULL(sectors, d->stripe_size);
+	if (!n || n > max_stripes) {
+		pr_err("nr_stripes too large or invalid: %lu (start sector beyond end of disk?)\n",
+			n);
 		return -ENOMEM;
 	}
+	d->nr_stripes = n;
 
 	n = d->nr_stripes * sizeof(atomic_t);
 	d->stripe_sectors_dirty = kvzalloc(n, GFP_KERNEL);
-- 
2.26.2

