Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C78AEEF86
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:22:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388581AbfKDV5Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 16:57:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:53660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388576AbfKDV5Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:57:25 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D378214D8;
        Mon,  4 Nov 2019 21:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904644;
        bh=Wnu7Z2OKcnzbqlOid24zXeShG/t1Wp8CuboYXR7f6/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QFf6rGZ5k/WAM4crPwFqZYA6fDeoMnNnMSsaTx9AHOuFfe7I4AjGkK5E2w+F2xcCM
         5uH6bbBlOqY+NzBnoiBK8r9f1n70TKrVZYxwZjDc+iWyzgrbiMDeSLXXIu5RzSXoPO
         MjtjBgde3USz7NUX0YdeFuuTmhtqjF3Mr7I1plY8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Nikos Tsironis <ntsironis@arrikto.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 002/149] dm snapshot: introduce account_start_copy() and account_end_copy()
Date:   Mon,  4 Nov 2019 22:43:15 +0100
Message-Id: <20191104212126.900348411@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212126.090054740@linuxfoundation.org>
References: <20191104212126.090054740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit a2f83e8b0c82c9500421a26c49eb198b25fcdea3 ]

This simple refactoring moves code for modifying the semaphore cow_count
into separate functions to prepare for changes that will extend these
methods to provide for a more sophisticated mechanism for COW
throttling.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reviewed-by: Nikos Tsironis <ntsironis@arrikto.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-snap.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 36805b12661e1..d9216afbd490f 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -1399,6 +1399,16 @@ static void snapshot_dtr(struct dm_target *ti)
 	kfree(s);
 }
 
+static void account_start_copy(struct dm_snapshot *s)
+{
+	down(&s->cow_count);
+}
+
+static void account_end_copy(struct dm_snapshot *s)
+{
+	up(&s->cow_count);
+}
+
 /*
  * Flush a list of buffers.
  */
@@ -1594,7 +1604,7 @@ static void copy_callback(int read_err, unsigned long write_err, void *context)
 		rb_link_node(&pe->out_of_order_node, parent, p);
 		rb_insert_color(&pe->out_of_order_node, &s->out_of_order_tree);
 	}
-	up(&s->cow_count);
+	account_end_copy(s);
 }
 
 /*
@@ -1618,7 +1628,7 @@ static void start_copy(struct dm_snap_pending_exception *pe)
 	dest.count = src.count;
 
 	/* Hand over to kcopyd */
-	down(&s->cow_count);
+	account_start_copy(s);
 	dm_kcopyd_copy(s->kcopyd_client, &src, 1, &dest, 0, copy_callback, pe);
 }
 
@@ -1638,7 +1648,7 @@ static void start_full_bio(struct dm_snap_pending_exception *pe,
 	pe->full_bio = bio;
 	pe->full_bio_end_io = bio->bi_end_io;
 
-	down(&s->cow_count);
+	account_start_copy(s);
 	callback_data = dm_kcopyd_prepare_callback(s->kcopyd_client,
 						   copy_callback, pe);
 
-- 
2.20.1



