Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4660D47B7DA
	for <lists+stable@lfdr.de>; Tue, 21 Dec 2021 03:03:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232965AbhLUCCR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 21:02:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234525AbhLUCAm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 21:00:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDBF1C0698CA;
        Mon, 20 Dec 2021 18:00:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A807BB810FE;
        Tue, 21 Dec 2021 02:00:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7446C36AEA;
        Tue, 21 Dec 2021 02:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640052029;
        bh=qOAVejSBa6t0oHnuYlDkHxhRtBvuV/HzJXtKtVR9wUI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BxO1m2PCMGQpV4FbmG/iUZngX97MAE5ZxvA9bE7EdJoShakGhzo1SZILWwrvoZrIk
         SYcjWKrKJi/upoW3gtzhM0yJz0eU/G5RaVhBMI9MOLgb15pUCDsF8bBTTkV/7/5gIW
         w2LN9IgsKkvyAPws+uqxded8aVDQN8CbHxPuc2llcNhwwmce5sitmEjjQELeQi5srC
         aRsejkFiopvvwhC6tiKXf+vxEnIJz2pKBN2PKMEKDL+I8yXpbzKs7qfmZnH3tk8KqN
         +iFxRn5is4BO+sZUIfopgdxYxDFQIma7iusOxALFLIzlxFQ5HFkg0Rc00wuiY5OC8S
         q9tl4xYd/789w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Alex Xu <alex_y_xu@yahoo.ca>,
        kernel test robot <oliver.sang@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 14/14] Revert "block: reduce kblockd_mod_delayed_work_on() CPU consumption"
Date:   Mon, 20 Dec 2021 20:59:52 -0500
Message-Id: <20211221015952.117052-14-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211221015952.117052-1-sashal@kernel.org>
References: <20211221015952.117052-1-sashal@kernel.org>
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
index 78b7a21cf1d69..5808baa950c35 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1669,8 +1669,6 @@ EXPORT_SYMBOL(kblockd_schedule_work_on);
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

