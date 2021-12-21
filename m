Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC0147B7F1
	for <lists+stable@lfdr.de>; Tue, 21 Dec 2021 03:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234692AbhLUCDH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 21:03:07 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33912 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234810AbhLUCBZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 21:01:25 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0EC3B8110D;
        Tue, 21 Dec 2021 02:01:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C952CC36AF0;
        Tue, 21 Dec 2021 02:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640052082;
        bh=g1NGzMGkKMRfKbLAs/7Ekn9DQHmhNZjVFBdLxPKVvsk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=drtrZ4OoDS0ueCGAuzL5YKzsjy+iJEbons3STNtt5U/H3ZL2ndWR/Y1Pt6rzY8WbF
         yxxT4PJ8mY2ZsbXdQ1a8CjH5sEbyjTcVRbrrb3q8GvO4SDwlrN194I0tYC7XGByTDQ
         G3bUR2rw6KhLO4vB8FCdMUmLTJ7obxD5EXOqIrfoSg5g1k9qrlPEjoeEIwGF9m5djc
         kzP3+5ZLljar7z8+UkMpgx6YzxaCw4MJZxqWiZ0QXjmhYdcN+QKaiQIDvBDryCmJbJ
         a97/Sd6/hlSDsUZMHGtaCUlvdMMYpOIRncFMdqxF7es4Et6YOuKMfnARsR7IyjdBo9
         rps/Q7TSwfoJA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Alex Xu <alex_y_xu@yahoo.ca>,
        kernel test robot <oliver.sang@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 11/11] Revert "block: reduce kblockd_mod_delayed_work_on() CPU consumption"
Date:   Mon, 20 Dec 2021 21:00:30 -0500
Message-Id: <20211221020030.117225-11-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211221020030.117225-1-sashal@kernel.org>
References: <20211221020030.117225-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 87959fa16cfbcf76245c11559db1940069621274 ]

This reverts commit cb2ac2912a9ca7d3d26291c511939a41361d2d83.

Alex and the kernel test robot report that this causes a significant
performance regression with BFQ. I can reproduce that result, so let's
revert this one as we're close to -rc6 and we there's no point in trying
to rush a fix.

Link: https://lore.kernel.org/linux-block/1639853092.524jxfaem2.none@localhost/
Link: https://lore.kernel.org/lkml/20211219141852.GH14057@xsang-OptiPlex-9020/
Reported-by: Alex Xu (Hello71) <alex_y_xu@yahoo.ca>
Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 8529cc3f213b9..80f3e729fdd4d 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -3581,8 +3581,6 @@ EXPORT_SYMBOL(kblockd_schedule_work_on);
 int kblockd_mod_delayed_work_on(int cpu, struct delayed_work *dwork,
 				unsigned long delay)
 {
-	if (!delay)
-		return queue_work_on(cpu, kblockd_workqueue, &dwork->work);
 	return mod_delayed_work_on(cpu, kblockd_workqueue, dwork, delay);
 }
 EXPORT_SYMBOL(kblockd_mod_delayed_work_on);
-- 
2.34.1

