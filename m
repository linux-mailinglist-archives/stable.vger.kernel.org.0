Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF23A4638A7
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 16:02:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245361AbhK3PFR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 10:05:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244195AbhK3PA3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 10:00:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79E77C07E5F2;
        Tue, 30 Nov 2021 06:52:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40CAEB81A6A;
        Tue, 30 Nov 2021 14:52:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07FC5C8D188;
        Tue, 30 Nov 2021 14:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283954;
        bh=otRf7DSe9U5QDSY7crYhRRCxFCnRmBu+ownlSsOmhuQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TU7TKYt6AfQkkGEicWZfy3CWF1GoRpymHNQ/l5AqyPYr11E5QsUoJnVNebMoS5+0E
         II/1gqNHOyKg2/9zveURBqTXz9cY5tKku3kSm6SA5bEy5fooUgwNQ04ah6+yXJYSOK
         kxXlp5zxYfhoxpIdtsRq9FMio6P2bwcTmuPG0F4j6iw3Z0buhZsvAs+8SpN7OtWUH4
         Y/isqIbHlaTVImecmxQOUURoRHOwv6yEnCb0nhvjsqIaS6myu0HpIfQRMhPUX/C4CG
         8HgGynedvbLpsIKXZ8cJsw9IuKe4LpIcaAQJ39vTW8GRQ5RZNmnLJfrPB4na9rW6Cl
         AX5wSpPYa8uaA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Enzo Matsumiya <ematsumiya@suse.de>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, kbusch@kernel.org,
        axboe@fb.com, sagi@grimberg.me, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 20/25] nvme-pci: add NO APST quirk for Kioxia device
Date:   Tue, 30 Nov 2021 09:51:50 -0500
Message-Id: <20211130145156.946083-20-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130145156.946083-1-sashal@kernel.org>
References: <20211130145156.946083-1-sashal@kernel.org>
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
index a5b5a2305791d..5fa48d36954ce 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2453,6 +2453,20 @@ static const struct nvme_core_quirk_entry core_quirks[] = {
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

