Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C20FD409426
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:31:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243832AbhIMO2e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:28:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:46952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345453AbhIMO0c (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:26:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B1C861B5F;
        Mon, 13 Sep 2021 13:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540943;
        bh=p8yyQc5/4w+JVWmWQWdhpaKX6u20yEqXCmCwgkXq114=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xjpxf6tjo7bBwQm0kioNjXuWX53DOgpNKLpTwRiQScJ0FuC9YQDZXuWBHqNPYWHw6
         bcg9htcxcWCOhZVXRbNxQqEcqYSh4+Qr/Yd//Lej7arqzhj6mAEPkDyfipOUAyWLcD
         3JR0eD3zhoFFXpFoXvzV6GmsqBYlEZYfCu2Ked5A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+9937dc42271cd87d4b98@syzkaller.appspotmail.com,
        Christoph Hellwig <hch@lst.de>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 066/334] block: nbd: add sanity check for first_minor
Date:   Mon, 13 Sep 2021 15:12:00 +0200
Message-Id: <20210913131115.641480769@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

[ Upstream commit b1a811633f7321cf1ae2bb76a66805b7720e44c9 ]

Syzbot hit WARNING in internal_create_group(). The problem was in
too big disk->first_minor.

disk->first_minor is initialized by value, which comes from userspace
and there wasn't any sanity checks about value correctness. It can cause
duplicate creation of sysfs files/links, because disk->first_minor will
be passed to MKDEV() which causes truncation to byte. Since maximum
minor value is 0xff, let's check if first_minor is correct minor number.

NOTE: the root case of the reported warning was in wrong error handling
in register_disk(), but we can avoid passing knowingly wrong values to
sysfs API, because sysfs error messages can confuse users. For example:
user passed 1048576 as index, but sysfs complains about duplicate
creation of /dev/block/43:0. It's not obvious how 1048576 becomes 0.
Log and reproducer for above example can be found on syzkaller bug
report page.

Link: https://syzkaller.appspot.com/bug?id=03c2ae9146416edf811958d5fd7acfab75b143d1
Fixes: b0d9111a2d53 ("nbd: use an idr to keep track of nbd devices")
Reported-by: syzbot+9937dc42271cd87d4b98@syzkaller.appspotmail.com
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/nbd.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 7ed888e99f09..93708b1938e8 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -1770,7 +1770,17 @@ static int nbd_dev_add(int index)
 	refcount_set(&nbd->refs, 1);
 	INIT_LIST_HEAD(&nbd->list);
 	disk->major = NBD_MAJOR;
+
+	/* Too big first_minor can cause duplicate creation of
+	 * sysfs files/links, since first_minor will be truncated to
+	 * byte in __device_add_disk().
+	 */
 	disk->first_minor = index << part_shift;
+	if (disk->first_minor > 0xff) {
+		err = -EINVAL;
+		goto out_free_idr;
+	}
+
 	disk->minors = 1 << part_shift;
 	disk->fops = &nbd_fops;
 	disk->private_data = nbd;
-- 
2.30.2



