Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD1430330E
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 05:45:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727342AbhAZEpY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:45:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:59202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727746AbhAYSmy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:42:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C8A8B22E03;
        Mon, 25 Jan 2021 18:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600099;
        bh=EvPL4ASu1PG4XMnHkbH0qSRCqhNArWZOsfFhzsNDX4Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dAvLa8adrO7ggaA1bLxSkDR2oDm+A0+ZkmEqvx4DqZCJSiNIFhOJ7FqBGH7XDHkdh
         lMOUakUmtEmKfrpz+q6EUT56yCDiKATA0xCUS3XarpT7bJJTeJAYhzwom/JdnA9nLM
         LppAxESJCIaH7wWHgP+sgxo4F7yTweiWAApAdBWU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Martin Wilck <mwilck@suse.com>, Christoph Hellwig <hch@lst.de>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 4.19 08/58] dm: avoid filesystem lookup in dm_get_dev_t()
Date:   Mon, 25 Jan 2021 19:39:09 +0100
Message-Id: <20210125183157.060828606@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183156.702907356@linuxfoundation.org>
References: <20210125183156.702907356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

commit 809b1e4945774c9ec5619a8f4e2189b7b3833c0c upstream.

This reverts commit
644bda6f3460 ("dm table: fall back to getting device using name_to_dev_t()")

dm_get_dev_t() is just used to convert an arbitrary 'path' string
into a dev_t. It doesn't presume that the device is present; that
check will be done later, as the only caller is dm_get_device(),
which does a dm_get_table_device() later on, which will properly
open the device.

So if the path string already _is_ in major:minor representation
we can convert it directly, avoiding a recursion into the filesystem
to lookup the block device.

This avoids a hang in multipath_message() when the filesystem is
inaccessible.

Fixes: 644bda6f3460 ("dm table: fall back to getting device using name_to_dev_t()")
Cc: stable@vger.kernel.org
Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-table.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -431,14 +431,23 @@ int dm_get_device(struct dm_target *ti,
 {
 	int r;
 	dev_t dev;
+	unsigned int major, minor;
+	char dummy;
 	struct dm_dev_internal *dd;
 	struct dm_table *t = ti->table;
 
 	BUG_ON(!t);
 
-	dev = dm_get_dev_t(path);
-	if (!dev)
-		return -ENODEV;
+	if (sscanf(path, "%u:%u%c", &major, &minor, &dummy) == 2) {
+		/* Extract the major/minor numbers */
+		dev = MKDEV(major, minor);
+		if (MAJOR(dev) != major || MINOR(dev) != minor)
+			return -EOVERFLOW;
+	} else {
+		dev = dm_get_dev_t(path);
+		if (!dev)
+			return -ENODEV;
+	}
 
 	dd = find_device(&t->devices, dev);
 	if (!dd) {


