Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70EA647B7D1
	for <lists+stable@lfdr.de>; Tue, 21 Dec 2021 03:03:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234960AbhLUCBr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 21:01:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234398AbhLUCA1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 21:00:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FE49C061D72;
        Mon, 20 Dec 2021 18:00:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E48761357;
        Tue, 21 Dec 2021 02:00:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12C32C36AEA;
        Tue, 21 Dec 2021 02:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640052026;
        bh=AEeKT5YSm44+7l8+jeZY06YNivoG6R4z989xA8Eh1ME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B/cclYCUmKG+FxXUnQvPj/PytVwTosfaDt/9ZkOSSSdnd4rtNDfs07PpwFUXhAoN7
         FNK3BkZaTQtDHqlXDCpNQp26Xp/eihBLccooq4nQrwRDIWDnzFkx4dK7hgZWBCArh1
         Nwe2n6CNjgtXew7COmDNoaQH1jriCzFnN4DsXzBgjpAWuMdSKpMTyWtEhUzthNZHbD
         pcEeC5c8avcVDHW6PXygi+ZW3gnPAJ/L/pUTDeIqTPCTEFNFnV4FgsLJW6dwWO/5+I
         c4Ct6NzqQPxdzzEzgCWlY1ZtFLbgSuTdiq3bMtGxi78QUcDgFOUv0oN5W0haZ/PByA
         DAW6DDQZLYxjw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Dexuan Cui <decui@microsoft.com>,
        Ming Lei <ming.lei@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 12/14] block: reduce kblockd_mod_delayed_work_on() CPU consumption
Date:   Mon, 20 Dec 2021 20:59:50 -0500
Message-Id: <20211221015952.117052-12-sashal@kernel.org>
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
index 5808baa950c35..78b7a21cf1d69 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1669,6 +1669,8 @@ EXPORT_SYMBOL(kblockd_schedule_work_on);
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

