Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2DC61ACAAB
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408332AbgDPPhv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:37:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:51510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897809AbgDPNjG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:39:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57C002220A;
        Thu, 16 Apr 2020 13:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044345;
        bh=Q6Ia7usDOLuZ4bedNUL50Ce4q2NYsM6H3bmyAwXYQEc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nbkhM+TYrGKGWLacrS15FPcIaW3jZc641y6CfnC5S0c+T7nrNzhemSocAQ3YPMM3K
         eL6eIA1Hx+1j7Vsw2PR/TXMToMrib+TEr6+Z5lohuDetPuP6D13JrYuHrXi+xMhVOX
         3REDBBNwmKbRMsejci6n8Yo8/r1FOoqnveNPvx4U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.5 180/257] dm writecache: add cond_resched to avoid CPU hangs
Date:   Thu, 16 Apr 2020 15:23:51 +0200
Message-Id: <20200416131348.856133636@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.891903893@linuxfoundation.org>
References: <20200416131325.891903893@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

commit 1edaa447d958bec24c6a79685a5790d98976fd16 upstream.

Initializing a dm-writecache device can take a long time when the
persistent memory device is large.  Add cond_resched() to a few loops
to avoid warnings that the CPU is stuck.

Cc: stable@vger.kernel.org # v4.18+
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-writecache.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -872,6 +872,7 @@ static int writecache_alloc_entries(stru
 		struct wc_entry *e = &wc->entries[b];
 		e->index = b;
 		e->write_in_progress = false;
+		cond_resched();
 	}
 
 	return 0;
@@ -926,6 +927,7 @@ static void writecache_resume(struct dm_
 			e->original_sector = le64_to_cpu(wme.original_sector);
 			e->seq_count = le64_to_cpu(wme.seq_count);
 		}
+		cond_resched();
 	}
 #endif
 	for (b = 0; b < wc->n_blocks; b++) {
@@ -1770,8 +1772,10 @@ static int init_memory(struct dm_writeca
 	pmem_assign(sb(wc)->n_blocks, cpu_to_le64(wc->n_blocks));
 	pmem_assign(sb(wc)->seq_count, cpu_to_le64(0));
 
-	for (b = 0; b < wc->n_blocks; b++)
+	for (b = 0; b < wc->n_blocks; b++) {
 		write_original_sector_seq_count(wc, &wc->entries[b], -1, -1);
+		cond_resched();
+	}
 
 	writecache_flush_all_metadata(wc);
 	writecache_commit_flushed(wc, false);


