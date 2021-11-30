Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6774A463894
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 16:02:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244134AbhK3PFH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 10:05:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238189AbhK3O6e (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:58:34 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95536C061394;
        Tue, 30 Nov 2021 06:51:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 19D7ECE1A4B;
        Tue, 30 Nov 2021 14:51:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C954CC53FC1;
        Tue, 30 Nov 2021 14:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283891;
        bh=ZpQXlrXTrOMjinSQiwHRhHYMK+Ldcr0wzM0499Y6v9w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ap8qrMjo8Ff3DUD4EOAWABmDFptH7yIheTspxqbmV9WChV67Q6MM/RMxuFdQQ4/Gs
         ioSzSSIU4fNFluPDVIsWuuvUo6fx0FH5ZQAPlT7Ku8byUB5QMsP+9aKpLyGj2xAzxi
         7G4rtinUhdjINr/CM5iEOnGaabPCXmDjgQ/lZv/qX+rQ/V6jMlHbM5TvmDcNT3RLUN
         rtOoL9/jU8PiAKi6eJ2VyzntyxlqE0FizkHgxyt+7pexHakpS/kTYAnzRAnV7iN8z+
         zGnO+Io9fuZ7GYaDqkCArOofC27ziFEhkBSq7atYa4RqveG3bcTMzp2nTwEdBoElsn
         FDR9ompGOStmA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Enzo Matsumiya <ematsumiya@suse.de>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, kbusch@kernel.org,
        axboe@fb.com, sagi@grimberg.me, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 32/43] nvme-pci: add NO APST quirk for Kioxia device
Date:   Tue, 30 Nov 2021 09:50:09 -0500
Message-Id: <20211130145022.945517-32-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130145022.945517-1-sashal@kernel.org>
References: <20211130145022.945517-1-sashal@kernel.org>
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
index 99b5152482fe4..c76f3a7fb1d18 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2663,6 +2663,20 @@ static const struct nvme_core_quirk_entry core_quirks[] = {
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

