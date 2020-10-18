Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A24CC2919C5
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 21:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728420AbgJRTTo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 15:19:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:58678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728391AbgJRTTn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:19:43 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C59B6222EB;
        Sun, 18 Oct 2020 19:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603048782;
        bh=3gTmu7De9jNcmJSQWiTbk0jKH4hNgGwvznF8vXujAlE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fK6XKlU8wC3hkbaD/X3/RNQueZj45FBZQa6P+3A0WIouyoCMY6CnX8qLtI/w/1gTv
         DGYtm4ar+L/LPD12mDy2Oym4nMNMo0X1nkxgiqRY8Xx0mRIdu7c8Lh7W3VCTrAIo0J
         r/pJhu8E2QzkeeBCKi6Q8pTl0HxBgNB2fbLeh6Wg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Rander Wang <rander.wang@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.9 079/111] soundwire: cadence: fix race condition between suspend and Slave device alerts
Date:   Sun, 18 Oct 2020 15:17:35 -0400
Message-Id: <20201018191807.4052726-79-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018191807.4052726-1-sashal@kernel.org>
References: <20201018191807.4052726-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit d2068da5c85697b5880483dd7beaba98e0b62e02 ]

In system suspend stress cases, the SOF CI reports timeouts. The root
cause is that an alert is generated while the system suspends. The
interrupt handling generates transactions on the bus that will never
be handled because the interrupts are disabled in parallel.

As a result, the transaction never completes and times out on resume.
This error doesn't seem too problematic since it happens in a work
queue, and the system recovers without issues.

Nevertheless, this race condition should not happen. When doing a
system suspend, or when disabling interrupts, we should make sure the
current transaction can complete, and prevent new work from being
queued.

BugLink: https://github.com/thesofproject/linux/issues/2344
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@linux.intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Acked-by: Jaroslav Kysela <perex@perex.cz>
Link: https://lore.kernel.org/r/20200817222340.18042-1-yung-chuan.liao@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/cadence_master.c | 24 +++++++++++++++++++++++-
 drivers/soundwire/cadence_master.h |  1 +
 2 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/drivers/soundwire/cadence_master.c b/drivers/soundwire/cadence_master.c
index 24eafe0aa1c3e..1330ffc475960 100644
--- a/drivers/soundwire/cadence_master.c
+++ b/drivers/soundwire/cadence_master.c
@@ -791,7 +791,16 @@ irqreturn_t sdw_cdns_irq(int irq, void *dev_id)
 			     CDNS_MCP_INT_SLAVE_MASK, 0);
 
 		int_status &= ~CDNS_MCP_INT_SLAVE_MASK;
-		schedule_work(&cdns->work);
+
+		/*
+		 * Deal with possible race condition between interrupt
+		 * handling and disabling interrupts on suspend.
+		 *
+		 * If the master is in the process of disabling
+		 * interrupts, don't schedule a workqueue
+		 */
+		if (cdns->interrupt_enabled)
+			schedule_work(&cdns->work);
 	}
 
 	cdns_writel(cdns, CDNS_MCP_INTSTAT, int_status);
@@ -924,6 +933,19 @@ int sdw_cdns_enable_interrupt(struct sdw_cdns *cdns, bool state)
 		slave_state = cdns_readl(cdns, CDNS_MCP_SLAVE_INTSTAT1);
 		cdns_writel(cdns, CDNS_MCP_SLAVE_INTSTAT1, slave_state);
 	}
+	cdns->interrupt_enabled = state;
+
+	/*
+	 * Complete any on-going status updates before updating masks,
+	 * and cancel queued status updates.
+	 *
+	 * There could be a race with a new interrupt thrown before
+	 * the 3 mask updates below are complete, so in the interrupt
+	 * we use the 'interrupt_enabled' status to prevent new work
+	 * from being queued.
+	 */
+	if (!state)
+		cancel_work_sync(&cdns->work);
 
 	cdns_writel(cdns, CDNS_MCP_SLAVE_INTMASK0, slave_intmask0);
 	cdns_writel(cdns, CDNS_MCP_SLAVE_INTMASK1, slave_intmask1);
diff --git a/drivers/soundwire/cadence_master.h b/drivers/soundwire/cadence_master.h
index 7638858397df9..15b0834030866 100644
--- a/drivers/soundwire/cadence_master.h
+++ b/drivers/soundwire/cadence_master.h
@@ -129,6 +129,7 @@ struct sdw_cdns {
 
 	bool link_up;
 	unsigned int msg_count;
+	bool interrupt_enabled;
 
 	struct work_struct work;
 
-- 
2.25.1

