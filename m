Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2D5E261447
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 18:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731502AbgIHQLw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 12:11:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:56084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731494AbgIHQLn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:11:43 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3DD7D24730;
        Tue,  8 Sep 2020 15:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579653;
        bh=+zm7Fp+zxwREOLfIDfp8EndrVnZmnnp2r5XmiTl5G6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jGO+xrw4ZXwZbVLZgI9KAJxK7QwPekH77kbegJTBjf/MYwqwWVzTq/ghDaYvkSa5e
         8137S1KU5m8LQCNa3APczPaPoxCVxzrWRvii/n4MdDjv33PdgjOUzWqx3pj0t61eEn
         4kR3M8MCWhCkSo65D8c06+Bpcrc/N8z1b8tWrEWg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Marzinski <bmarzins@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.8 166/186] dm mpath: fix racey management of PG initialization
Date:   Tue,  8 Sep 2020 17:25:08 +0200
Message-Id: <20200908152249.710294557@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Snitzer <snitzer@redhat.com>

commit c322ee9320eaa4013ca3620b1130992916b19b31 upstream.

Commit 935fcc56abc3 ("dm mpath: only flush workqueue when needed")
changed flush_multipath_work() to avoid needless workqueue
flushing (of a multipath global workqueue). But that change didn't
realize the surrounding flush_multipath_work() code should also only
run if 'pg_init_in_progress' is set.

Fix this by only doing all of flush_multipath_work()'s PG init related
work if 'pg_init_in_progress' is set.

Otherwise multipath_wait_for_pg_init_completion() will run
unconditionally but the preceeding flush_workqueue(kmpath_handlerd)
may not. This could lead to deadlock (though only if kmpath_handlerd
never runs a corresponding work to decrement 'pg_init_in_progress').

It could also be, though highly unlikely, that the kmpath_handlerd
work that does PG init completes before 'pg_init_in_progress' is set,
and then an intervening DM table reload's multipath_postsuspend()
triggers flush_multipath_work().

Fixes: 935fcc56abc3 ("dm mpath: only flush workqueue when needed")
Cc: stable@vger.kernel.org
Reported-by: Ben Marzinski <bmarzins@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-mpath.c |   22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1247,17 +1247,25 @@ static void multipath_wait_for_pg_init_c
 static void flush_multipath_work(struct multipath *m)
 {
 	if (m->hw_handler_name) {
-		set_bit(MPATHF_PG_INIT_DISABLED, &m->flags);
-		smp_mb__after_atomic();
+		unsigned long flags;
+
+		if (!atomic_read(&m->pg_init_in_progress))
+			goto skip;
+
+		spin_lock_irqsave(&m->lock, flags);
+		if (atomic_read(&m->pg_init_in_progress) &&
+		    !test_and_set_bit(MPATHF_PG_INIT_DISABLED, &m->flags)) {
+			spin_unlock_irqrestore(&m->lock, flags);
 
-		if (atomic_read(&m->pg_init_in_progress))
 			flush_workqueue(kmpath_handlerd);
-		multipath_wait_for_pg_init_completion(m);
+			multipath_wait_for_pg_init_completion(m);
 
-		clear_bit(MPATHF_PG_INIT_DISABLED, &m->flags);
-		smp_mb__after_atomic();
+			spin_lock_irqsave(&m->lock, flags);
+			clear_bit(MPATHF_PG_INIT_DISABLED, &m->flags);
+		}
+		spin_unlock_irqrestore(&m->lock, flags);
 	}
-
+skip:
 	if (m->queue_mode == DM_TYPE_BIO_BASED)
 		flush_work(&m->process_queued_bios);
 	flush_work(&m->trigger_event);


