Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20A26BA9B8
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389030AbfIVTSi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 15:18:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:56090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408063AbfIVSzJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:55:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 174392190F;
        Sun, 22 Sep 2019 18:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178508;
        bh=Oh+7ZXgLTx07OWwHyaxKMRlgpijwLPFXyLLpXRu+Qls=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JUPIxofgexyBi23WOw9gk7krGjDVkObAoLW5aGPHwHtn2WWIZxmW9kLBuD3Au/Fr4
         REsXz+j4LuxmDJarpgbME/1RBJ7OVawrGU5HqcjRqK/DOfNntOUOEUc9BraeU2cYLK
         K8yK1Jl8QKGM1g7QBSFH6fFaZ12vQC9LYP8Zy/sQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sudeep Holla <sudeep.holla@arm.com>,
        Jim Quinlan <james.quinlan@broadcom.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 040/128] firmware: arm_scmi: Check if platform has released shmem before using
Date:   Sun, 22 Sep 2019 14:52:50 -0400
Message-Id: <20190922185418.2158-40-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922185418.2158-1-sashal@kernel.org>
References: <20190922185418.2158-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sudeep Holla <sudeep.holla@arm.com>

[ Upstream commit 9dc34d635c67e57051853855c43249408641a5ab ]

Sometimes platfom may take too long to respond to the command and OS
might timeout before platform transfer the ownership of the shared
memory region to the OS with the response.

Since the mailbox channel associated with the channel is freed and new
commands are dispatch on the same channel, OS needs to wait until it
gets back the ownership. If not, either OS may end up overwriting the
platform response for the last command(which is fine as OS timed out
that command) or platform might overwrite the payload for the next
command with the response for the old.

The latter is problematic as platform may end up interpretting the
response as the payload. In order to avoid such race, let's wait until
the OS gets back the ownership before we prepare the shared memory with
the payload for the next command.

Reported-by: Jim Quinlan <james.quinlan@broadcom.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/driver.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index 8f952f2f1a292..09119e3f5c018 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -271,6 +271,14 @@ static void scmi_tx_prepare(struct mbox_client *cl, void *m)
 	struct scmi_chan_info *cinfo = client_to_scmi_chan_info(cl);
 	struct scmi_shared_mem __iomem *mem = cinfo->payload;
 
+	/*
+	 * Ideally channel must be free by now unless OS timeout last
+	 * request and platform continued to process the same, wait
+	 * until it releases the shared memory, otherwise we may endup
+	 * overwriting its response with new message payload or vice-versa
+	 */
+	spin_until_cond(ioread32(&mem->channel_status) &
+			SCMI_SHMEM_CHAN_STAT_CHANNEL_FREE);
 	/* Mark channel busy + clear error */
 	iowrite32(0x0, &mem->channel_status);
 	iowrite32(t->hdr.poll_completion ? 0 : SCMI_SHMEM_FLAG_INTR_ENABLED,
-- 
2.20.1

