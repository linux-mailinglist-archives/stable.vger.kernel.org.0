Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE8529BA43
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:13:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368945AbgJ0P7A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:59:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:55360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1803944AbgJ0Pxg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:53:36 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7955120657;
        Tue, 27 Oct 2020 15:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603814015;
        bh=3gTmu7De9jNcmJSQWiTbk0jKH4hNgGwvznF8vXujAlE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2LXGiYZ4AOYrx8Q6Ud9w+55k7+CTjmrL/FNbxk4bJMTajeLjm6XMPjmAaVFFo9vVE
         HrkNgNlHk3lnOE2V6peZkCyN68krV7WSTpWXdQvH3rTrJg1NGwL2o0wXVaNUqfWYJ8
         tTGCs8uQiO1m6M9upnT4hiy+eE3NRE7LSQXw32VQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Rander Wang <rander.wang@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 716/757] soundwire: cadence: fix race condition between suspend and Slave device alerts
Date:   Tue, 27 Oct 2020 14:56:06 +0100
Message-Id: <20201027135524.086632107@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



