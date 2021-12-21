Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D93747B800
	for <lists+stable@lfdr.de>; Tue, 21 Dec 2021 03:03:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234860AbhLUCDc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 21:03:32 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:35626 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233396AbhLUCB5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 21:01:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 441B9B8110C;
        Tue, 21 Dec 2021 02:01:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C657C36AE8;
        Tue, 21 Dec 2021 02:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640052115;
        bh=IQOUy7pd0b2kdeoOCEqbMMZczKQ+ef6VBIgu+uHcf50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dj1Cd/TdFRLV0x7u9CLB4LxR9GLj/MSdpEZ/VN2/joXFD4onlM6FJODMz8GaskeYW
         b/3vLoJ8FE+Syz4c897lHX1mF/79yERSK6SBzgSIvn7gke0P2xZcxEzyyXaiO6yPaU
         o0oHvdYH33nUFf04VyCn4frPhA4xBrHJgiHkQIuvieG3E+7pHZDuy8ks49iGF6IO8E
         sN7fArlMXZ1nprsOxzMn1ifgFVhpnAaZOb56/e0Ei4HdjrpXhgQw6twcO7Iy5kvJkb
         mQ9j+vIQniQD1XfAgsT/RseiXTFX3yGCxtbHNHCptqBK0TII1pgsCl69D/7U5pY9Ka
         fG8OGXEYPkRjQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Dexuan Cui <decui@microsoft.com>,
        Ming Lei <ming.lei@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 7/9] block: reduce kblockd_mod_delayed_work_on() CPU consumption
Date:   Mon, 20 Dec 2021 21:01:21 -0500
Message-Id: <20211221020123.117380-7-sashal@kernel.org>
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
index 2407c898ba7d8..1859490fa4ae1 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -3233,6 +3233,8 @@ EXPORT_SYMBOL(kblockd_schedule_work_on);
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

