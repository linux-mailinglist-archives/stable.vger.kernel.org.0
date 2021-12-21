Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11B5C47B79A
	for <lists+stable@lfdr.de>; Tue, 21 Dec 2021 03:01:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234523AbhLUCAm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 21:00:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233670AbhLUB7r (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 20:59:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DFDFC06173F;
        Mon, 20 Dec 2021 17:59:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA8096134A;
        Tue, 21 Dec 2021 01:59:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BDFBC36AE9;
        Tue, 21 Dec 2021 01:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640051986;
        bh=yDmdNC0HoR1IwjTR1JRCbmCO+bCirtEJeqJxF7ONdbk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZfF0RjYV/Ixo30kfo559Fm2kAa5yxZ0VKTgVSYYO4up9bOKBrZcGIV62RtKdN/Cyk
         QqL1jADPsB6WWYjAACiDUD4+WwQ9MYS9iPD+F25knnkp1vrCod6ZZT8/IV8oX2VAla
         hpJDOFLA823ixUedMFzMnr/692R1RrJbK2LFNv54ZXznNydtctm0kDGcu75H+J751Q
         2luAG926g4Y5i6gINzX/lPiUF7sZXCUXM9yiSA/mUZT01QgjpFTvsQoGqrdLPSRy61
         cpMVn/f9SmqleQesYjZmzlu7XrS12kLqeCTMLM2GzidzeP/R3GFbVr86F7ZSGvSu8k
         oqtKRDBz9cP0A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Dexuan Cui <decui@microsoft.com>,
        Ming Lei <ming.lei@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 15/19] block: reduce kblockd_mod_delayed_work_on() CPU consumption
Date:   Mon, 20 Dec 2021 20:59:10 -0500
Message-Id: <20211221015914.116767-15-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211221015914.116767-1-sashal@kernel.org>
References: <20211221015914.116767-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit cb2ac2912a9ca7d3d26291c511939a41361d2d83 ]

Dexuan reports that he's seeing spikes of very heavy CPU utilization when
running 24 disks and using the 'none' scheduler. This happens off the
sched restart path, because SCSI requires the queue to be restarted async,
and hence we're hammering on mod_delayed_work_on() to ensure that the work
item gets run appropriately.

Avoid hammering on the timer and just use queue_work_on() if no delay
has been specified.

Reported-and-tested-by: Dexuan Cui <decui@microsoft.com>
Link: https://lore.kernel.org/linux-block/BYAPR21MB1270C598ED214C0490F47400BF719@BYAPR21MB1270.namprd21.prod.outlook.com/
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/block/blk-core.c b/block/blk-core.c
index 26664f2a139eb..4f4e286198660 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1657,6 +1657,8 @@ EXPORT_SYMBOL(kblockd_schedule_work);
 int kblockd_mod_delayed_work_on(int cpu, struct delayed_work *dwork,
 				unsigned long delay)
 {
+	if (!delay)
+		return queue_work_on(cpu, kblockd_workqueue, &dwork->work);
 	return mod_delayed_work_on(cpu, kblockd_workqueue, dwork, delay);
 }
 EXPORT_SYMBOL(kblockd_mod_delayed_work_on);
-- 
2.34.1

