Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC4EC12C545
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:41:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729801AbfL2RfJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:35:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:39184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728389AbfL2RfI (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:35:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 296E2207FF;
        Sun, 29 Dec 2019 17:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640907;
        bh=1VQvL9dRksI4IhYJFs1T/qelYf9r1BRQIl3EuaZdVf4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ScWhn3GGsvmd/iUYzaJHPCKdUNSjF5PRjjjVnIEr/SFDKWGR8ulLQDj1beAZ2B4gi
         LTmKvWi+EixPMW774JFHu4fV79G9MzhlKbQubcJskRb8+29XSWf7Qly3dn6UPSRNrB
         DuIMtEEuV0UWRNk4/5gsyogPopQVLNCRZSK2xM6I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>,
        Omar Sandoval <osandov@fb.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 189/219] btrfs: dont prematurely free work in scrub_missing_raid56_worker()
Date:   Sun, 29 Dec 2019 18:19:51 +0100
Message-Id: <20191229162538.150206652@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162508.458551679@linuxfoundation.org>
References: <20191229162508.458551679@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Omar Sandoval <osandov@fb.com>

[ Upstream commit 57d4f0b863272ba04ba85f86bfdc0f976f0af91c ]

Currently, scrub_missing_raid56_worker() puts and potentially frees
sblock (which embeds the work item) and then submits a bio through
scrub_wr_submit(). This is another potential instance of the bug in
"btrfs: don't prematurely free work in run_ordered_work()". Fix it by
dropping the reference after we submit the bio.

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Signed-off-by: Omar Sandoval <osandov@fb.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/scrub.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 916c39770467..6b6008db3e03 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -2145,14 +2145,13 @@ static void scrub_missing_raid56_worker(struct btrfs_work *work)
 		scrub_write_block_to_dev_replace(sblock);
 	}
 
-	scrub_block_put(sblock);
-
 	if (sctx->is_dev_replace && sctx->flush_all_writes) {
 		mutex_lock(&sctx->wr_lock);
 		scrub_wr_submit(sctx);
 		mutex_unlock(&sctx->wr_lock);
 	}
 
+	scrub_block_put(sblock);
 	scrub_pending_bio_dec(sctx);
 }
 
-- 
2.20.1



