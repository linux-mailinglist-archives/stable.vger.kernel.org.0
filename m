Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C5CC47B7EA
	for <lists+stable@lfdr.de>; Tue, 21 Dec 2021 03:03:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234623AbhLUCDA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 21:03:00 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:57168 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234747AbhLUCBU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 21:01:20 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 609536136F;
        Tue, 21 Dec 2021 02:01:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08BC6C36AE5;
        Tue, 21 Dec 2021 02:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640052079;
        bh=DkwtmLsAjEEA/XqnOwJPFwAJcrGDIAoAiDiw1KIVdMk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y7KbaJpRbgwAefO+uO2eElN+RmaV8bhqaSa5DEk2T3vSarXb4nrSCw57t/kbUMeha
         UaKVhi6MPz5EPuO5YeMUpRR8cYzb/pK3exKI+Ih+kxURYR4EkXTXy/K56Q3pnCKudu
         Ub2VMBAJpRJWOF9+oBxFksxuyng7ye6C0gRr7KWnTNY6h33o0b8oiNJV0WOOfx9OwG
         CaeYFUExtAQ3RQUJXSj9IWZ6jb7DZbqdR/K0Pk8tbslEcVoFIE4i6a7Se3yJxJol4h
         oCcjiX4T38xdF0zAglJ2zdui+egs4IqlWnmMSQfwy4GKshy9eL1vD10g83bPGggsDx
         aKXz71GOQPfJA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Dexuan Cui <decui@microsoft.com>,
        Ming Lei <ming.lei@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 09/11] block: reduce kblockd_mod_delayed_work_on() CPU consumption
Date:   Mon, 20 Dec 2021 21:00:28 -0500
Message-Id: <20211221020030.117225-9-sashal@kernel.org>
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
index 80f3e729fdd4d..8529cc3f213b9 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -3581,6 +3581,8 @@ EXPORT_SYMBOL(kblockd_schedule_work_on);
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

