Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65AC847B83A
	for <lists+stable@lfdr.de>; Tue, 21 Dec 2021 03:07:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234769AbhLUCGk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 21:06:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235044AbhLUCDx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 21:03:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E1E5C08E6DE;
        Mon, 20 Dec 2021 18:01:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E29261362;
        Tue, 21 Dec 2021 02:01:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AF73C36AE8;
        Tue, 21 Dec 2021 02:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640052117;
        bh=SGMYHhzfsfvmwqYdrIDuyQNfjZxknCgAOPWHrFd+sgk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N+AXDN6WImGbBicP9koTN6qfQcUulVPoI/HMcXk3wjGYDsBe3oUsbj2zUhIpPY8QC
         ARIyCT+TNoWf4i2uEppT6SKLVRhBbfYPVLSSnxWlNtdFDs4FWAcI2zz3wAWMwxuJxw
         LXT65Kz1bRzRb98G69Ydk9MwOwluaKyFvZzV9xxCA74mxy2MVB+rRdqRoaM+7EctvA
         MzfbbcURFc4GM0CO4cuKoI+pjSsly/jvlOz2bCIa4BG+p0NA3UH8oi1alEbK2jSnYX
         6E59DzP9I6xPm8ko1cbws8XXl+Pf6xRTk4nCA7+COfMH1aDfcQvP5AhXZkg6jGqk5I
         BDJggplrimKPg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Alex Xu <alex_y_xu@yahoo.ca>,
        kernel test robot <oliver.sang@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 9/9] Revert "block: reduce kblockd_mod_delayed_work_on() CPU consumption"
Date:   Mon, 20 Dec 2021 21:01:23 -0500
Message-Id: <20211221020123.117380-9-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211221020123.117380-1-sashal@kernel.org>
References: <20211221020123.117380-1-sashal@kernel.org>
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
index 1859490fa4ae1..2407c898ba7d8 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -3233,8 +3233,6 @@ EXPORT_SYMBOL(kblockd_schedule_work_on);
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

