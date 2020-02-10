Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 717CA1577E4
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:03:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728924AbgBJMkZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:40:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:40296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729725AbgBJMkZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:40:25 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E027B20842;
        Mon, 10 Feb 2020 12:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338425;
        bh=4QML1bwa7pCPpS2zEuTpwZs3ISXs9jTMOsaVH/HWu74=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gTov/a+5rheCwEpsP5P1avYrZEgffEj/z27b0kSENU9aKy0sJxNDx13KoUBIQ/iN2
         blvqrSGUY04rZ0AO3t4KAhhv9Dk/kKWsLMFMOQwzjK5Ws3q4GTfN/7OwTiDwFZ94Pm
         Ss+yZ9sPo3BKCzDYBCYJWZlUFo8FSg7IZ1xHg8OI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zdenek Kabelac <zkabelac@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.5 146/367] dm thin: fix use-after-free in metadata_pre_commit_callback
Date:   Mon, 10 Feb 2020 04:30:59 -0800
Message-Id: <20200210122438.330873917@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Snitzer <snitzer@redhat.com>

commit a4a8d286586d4b28c8517a51db8d86954aadc74b upstream.

dm-thin uses struct pool to hold the state of the pool. There may be
multiple pool_c's pointing to a given pool, each pool_c represents a
loaded target. pool_c's may be created and destroyed arbitrarily and the
pool contains a reference count of pool_c's pointing to it.

Since commit 694cfe7f31db3 ("dm thin: Flush data device before
committing metadata") a pointer to pool_c is passed to
dm_pool_register_pre_commit_callback and this function stores it in
pmd->pre_commit_context. If this pool_c is freed, but pool is not
(because there is another pool_c referencing it), we end up in a
situation where pmd->pre_commit_context structure points to freed
pool_c. It causes a crash in metadata_pre_commit_callback.

Fix this by moving the dm_pool_register_pre_commit_callback() from
pool_ctr() to pool_preresume(). This way the in-core thin-pool metadata
is only ever armed with callback data whose lifetime matches the
active thin-pool target.

In should be noted that this fix preserves the ability to load a
thin-pool table that uses a different data block device (that contains
the same data) -- though it is unclear if that capability is still
useful and/or needed.

Fixes: 694cfe7f31db3 ("dm thin: Flush data device before committing metadata")
Cc: stable@vger.kernel.org
Reported-by: Zdenek Kabelac <zkabelac@redhat.com>
Reported-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-thin.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -3408,10 +3408,6 @@ static int pool_ctr(struct dm_target *ti
 	if (r)
 		goto out_flags_changed;
 
-	dm_pool_register_pre_commit_callback(pt->pool->pmd,
-					     metadata_pre_commit_callback,
-					     pt);
-
 	pt->callbacks.congested_fn = pool_is_congested;
 	dm_table_add_target_callbacks(ti->table, &pt->callbacks);
 
@@ -3574,6 +3570,9 @@ static int pool_preresume(struct dm_targ
 	if (r)
 		return r;
 
+	dm_pool_register_pre_commit_callback(pool->pmd,
+					     metadata_pre_commit_callback, pt);
+
 	r = maybe_resize_data_dev(ti, &need_commit1);
 	if (r)
 		return r;


