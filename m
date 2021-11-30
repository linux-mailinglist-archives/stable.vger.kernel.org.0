Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91D68463751
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 15:49:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232757AbhK3OxF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 09:53:05 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:57298 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242676AbhK3OwW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:52:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A6835CE1A53;
        Tue, 30 Nov 2021 14:49:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 450BAC53FC7;
        Tue, 30 Nov 2021 14:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283741;
        bh=MIVBc3yxEwa8fYigT0Ew3Zw9j7BxdjWFHttWgDurcbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lkwuPNK3SQkFwpH71lNqcvT2kuPDf7wmJhGMxB1FqbegV4XlTGNLD7rCj03gFtP44
         LVVcWSgAOxf00WY7n+Yn42pRNsBoVEbBQaGARd3wu3y7lHvXIQqpBAG2NH+rzWHBRQ
         17y7uhHD4x2+4OkOatzszgvFr9hwNT6fST+Kvbhffor5zQlk3nl/ZDG2eX65BFMN18
         wcRKQwP/G4RTuSYmurSqwVvSYA9KH1NwyC8xPMnX6td7smkzHLjY2+ZUWdWKW9sfyn
         jy0zECHgr8vPq2xgDVLuS8+3ZSQ2etne1rPwSx1wg1HZlM7hCfORa5I6CtoArCG5kx
         kHtUKQRMDaX3g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Enzo Matsumiya <ematsumiya@suse.de>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, kbusch@kernel.org,
        axboe@fb.com, sagi@grimberg.me, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 45/68] nvme-pci: add NO APST quirk for Kioxia device
Date:   Tue, 30 Nov 2021 09:46:41 -0500
Message-Id: <20211130144707.944580-45-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130144707.944580-1-sashal@kernel.org>
References: <20211130144707.944580-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Enzo Matsumiya <ematsumiya@suse.de>

[ Upstream commit 5a6254d55e2a9f7919ead8580d7aa0c7a382b26a ]

This particular Kioxia device times out and aborts I/O during any load,
but it's more easily observable with discards (fstrim).

The device gets to a state that is also not possible to use
"nvme set-feature" to disable APST.
Booting with nvme_core.default_ps_max_latency=0 solves the issue.

We had a dozen or so of these devices behaving this same way in
customer environments.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index f8dd664b2eda5..4ff75d7031110 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2468,6 +2468,20 @@ static const struct nvme_core_quirk_entry core_quirks[] = {
 		.vid = 0x14a4,
 		.fr = "22301111",
 		.quirks = NVME_QUIRK_SIMPLE_SUSPEND,
+	},
+	{
+		/*
+		 * This Kioxia CD6-V Series / HPE PE8030 device times out and
+		 * aborts I/O during any load, but more easily reproducible
+		 * with discards (fstrim).
+		 *
+		 * The device is left in a state where it is also not possible
+		 * to use "nvme set-feature" to disable APST, but booting with
+		 * nvme_core.default_ps_max_latency=0 works.
+		 */
+		.vid = 0x1e0f,
+		.mn = "KCD6XVUL6T40",
+		.quirks = NVME_QUIRK_NO_APST,
 	}
 };
 
-- 
2.33.0

