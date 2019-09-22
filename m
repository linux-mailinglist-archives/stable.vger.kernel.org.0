Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8358EBA3EE
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 20:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389748AbfIVSqA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 14:46:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:41846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389732AbfIVSp7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:45:59 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5343920665;
        Sun, 22 Sep 2019 18:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569177959;
        bh=iupxWFpcY6/cgaLlrAWuYCcnrImMYlOV5CQiGwgF2WE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MMap3sWSttfOfZOEuvjJL/3AO9UgMgf29aD3254eduzo7ywV9QC2XPM0HTjbEDEXf
         TEP3iEOJRNlzumakaGB+cdYoGmIudvPABGI/H+CAlAc/CewdKID6/CVXDLpa2+anxo
         MuyskYMZdmiMjv/cg5Sk4XgcR0K/1ctAPPwrPs0o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sudeep Holla <sudeep.holla@arm.com>,
        Jim Quinlan <james.quinlan@broadcom.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.3 063/203] firmware: arm_scmi: Check if platform has released shmem before using
Date:   Sun, 22 Sep 2019 14:41:29 -0400
Message-Id: <20190922184350.30563-63-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184350.30563-1-sashal@kernel.org>
References: <20190922184350.30563-1-sashal@kernel.org>
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
index b5bc4c7a8fab2..b49c9e6f4bf10 100644
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

