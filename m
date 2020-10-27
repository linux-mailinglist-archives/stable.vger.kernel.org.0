Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D822F29BDC3
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:50:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1812940AbgJ0Qqu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:46:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:33490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1799235AbgJ0Pll (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:41:41 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D16A222E9;
        Tue, 27 Oct 2020 15:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813300;
        bh=vu6tQ4BPjHYNEBWKoF8+6r4eyeStegbWma9YjhNfaiI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rUwf/3RogCEKp9D0EVVlt0kvy+oVKcvZIxfTPanZU9Bf1Bj8uoP4jU8zNNHsfCKHT
         jQj44hvYLzj8cby6VPYGFkjL367oplYs13F+tBWGUrb6cybRX61awipXeCsNdopB3p
         T96Z5tKCBCqSMBSkdLZFkjN0JKgJmv1gGWT0pGY0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 504/757] afs: Fix cell purging with aliases
Date:   Tue, 27 Oct 2020 14:52:34 +0100
Message-Id: <20201027135514.092179291@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 286377f6bdf71568a4cf07104fe44006ae0dba6d ]

When the afs module is removed, one of the things that has to be done is to
purge the cell database.  afs_cell_purge() cancels the management timer and
then starts the cell manager work item to do the purging.  This does a
single run through and then assumes that all cells are now purged - but
this is no longer the case.

With the introduction of alias detection, a later cell in the database can
now be holding an active count on an earlier cell (cell->alias_of).  The
purge scan passes by the earlier cell first, but this can't be got rid of
until it has discarded the alias.  Ordinarily, afs_unuse_cell() would
handle this by setting the management timer to trigger another pass - but
afs_set_cell_timer() doesn't do anything if the namespace is being removed
(net->live == false).  rmmod then hangs in the wait on cells_outstanding in
afs_cell_purge().

Fix this by making afs_set_cell_timer() directly queue the cell manager if
net->live is false.  This causes additional management passes.

Queueing the cell manager increments cells_outstanding to make sure the
wait won't complete until all cells are destroyed.

Fixes: 8a070a964877 ("afs: Detect cell aliases 1 - Cells with root volumes")
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/cell.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/afs/cell.c b/fs/afs/cell.c
index c906000b0ff84..1944be78e9b0d 100644
--- a/fs/afs/cell.c
+++ b/fs/afs/cell.c
@@ -19,6 +19,7 @@ static unsigned __read_mostly afs_cell_gc_delay = 10;
 static unsigned __read_mostly afs_cell_min_ttl = 10 * 60;
 static unsigned __read_mostly afs_cell_max_ttl = 24 * 60 * 60;
 
+static void afs_queue_cell_manager(struct afs_net *);
 static void afs_manage_cell_work(struct work_struct *);
 
 static void afs_dec_cells_outstanding(struct afs_net *net)
@@ -37,6 +38,8 @@ static void afs_set_cell_timer(struct afs_net *net, time64_t delay)
 		atomic_inc(&net->cells_outstanding);
 		if (timer_reduce(&net->cells_timer, jiffies + delay * HZ))
 			afs_dec_cells_outstanding(net);
+	} else {
+		afs_queue_cell_manager(net);
 	}
 }
 
-- 
2.25.1



