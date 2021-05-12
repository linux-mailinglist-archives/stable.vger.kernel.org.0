Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44E0B37C49E
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234178AbhELPcQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:32:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:38784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235519AbhELP2W (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:28:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C91061961;
        Wed, 12 May 2021 15:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832408;
        bh=caLWhmNsmpQMLo9cRt12dehmdp7ybvxI9hU0LGH/rMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nCgSAV96wVEdZqvqqnFITuT5B4YyRNppxgHAiYmiW+sMQE6mvUufMHnzroEdjPqej
         wu5O/cTd6jq6PzuXv7VYwQtjO35adj/tFEkjeAELGR4bVWQYak5eboWTmTLkhvKjkc
         yZYMjX7yuEUfWAc3Z5V+5Y30Lw/mxlB7zDUgQqO4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Kelley <mikelley@microsoft.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 268/530] Drivers: hv: vmbus: Increase wait time for VMbus unload
Date:   Wed, 12 May 2021 16:46:18 +0200
Message-Id: <20210512144828.623938310@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Kelley <mikelley@microsoft.com>

[ Upstream commit 77db0ec8b7764cb9b09b78066ebfd47b2c0c1909 ]

When running in Azure, disks may be connected to a Linux VM with
read/write caching enabled. If a VM panics and issues a VMbus
UNLOAD request to Hyper-V, the response is delayed until all dirty
data in the disk cache is flushed.  In extreme cases, this flushing
can take 10's of seconds, depending on the disk speed and the amount
of dirty data. If kdump is configured for the VM, the current 10 second
timeout in vmbus_wait_for_unload() may be exceeded, and the UNLOAD
complete message may arrive well after the kdump kernel is already
running, causing problems.  Note that no problem occurs if kdump is
not enabled because Hyper-V waits for the cache flush before doing
a reboot through the BIOS/UEFI code.

Fix this problem by increasing the timeout in vmbus_wait_for_unload()
to 100 seconds. Also output periodic messages so that if anyone is
watching the serial console, they won't think the VM is completely
hung.

Fixes: 911e1987efc8 ("Drivers: hv: vmbus: Add timeout to vmbus_wait_for_unload")
Signed-off-by: Michael Kelley <mikelley@microsoft.com>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Link: https://lore.kernel.org/r/1618894089-126662-1-git-send-email-mikelley@microsoft.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/channel_mgmt.c | 30 +++++++++++++++++++++++++-----
 1 file changed, 25 insertions(+), 5 deletions(-)

diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
index 6be9f56cb627..6476bfe193af 100644
--- a/drivers/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -725,6 +725,12 @@ static void init_vp_index(struct vmbus_channel *channel)
 	free_cpumask_var(available_mask);
 }
 
+#define UNLOAD_DELAY_UNIT_MS	10		/* 10 milliseconds */
+#define UNLOAD_WAIT_MS		(100*1000)	/* 100 seconds */
+#define UNLOAD_WAIT_LOOPS	(UNLOAD_WAIT_MS/UNLOAD_DELAY_UNIT_MS)
+#define UNLOAD_MSG_MS		(5*1000)	/* Every 5 seconds */
+#define UNLOAD_MSG_LOOPS	(UNLOAD_MSG_MS/UNLOAD_DELAY_UNIT_MS)
+
 static void vmbus_wait_for_unload(void)
 {
 	int cpu;
@@ -742,12 +748,17 @@ static void vmbus_wait_for_unload(void)
 	 * vmbus_connection.unload_event. If not, the last thing we can do is
 	 * read message pages for all CPUs directly.
 	 *
-	 * Wait no more than 10 seconds so that the panic path can't get
-	 * hung forever in case the response message isn't seen.
+	 * Wait up to 100 seconds since an Azure host must writeback any dirty
+	 * data in its disk cache before the VMbus UNLOAD request will
+	 * complete. This flushing has been empirically observed to take up
+	 * to 50 seconds in cases with a lot of dirty data, so allow additional
+	 * leeway and for inaccuracies in mdelay(). But eventually time out so
+	 * that the panic path can't get hung forever in case the response
+	 * message isn't seen.
 	 */
-	for (i = 0; i < 1000; i++) {
+	for (i = 1; i <= UNLOAD_WAIT_LOOPS; i++) {
 		if (completion_done(&vmbus_connection.unload_event))
-			break;
+			goto completed;
 
 		for_each_online_cpu(cpu) {
 			struct hv_per_cpu_context *hv_cpu
@@ -770,9 +781,18 @@ static void vmbus_wait_for_unload(void)
 			vmbus_signal_eom(msg, message_type);
 		}
 
-		mdelay(10);
+		/*
+		 * Give a notice periodically so someone watching the
+		 * serial output won't think it is completely hung.
+		 */
+		if (!(i % UNLOAD_MSG_LOOPS))
+			pr_notice("Waiting for VMBus UNLOAD to complete\n");
+
+		mdelay(UNLOAD_DELAY_UNIT_MS);
 	}
+	pr_err("Continuing even though VMBus UNLOAD did not complete\n");
 
+completed:
 	/*
 	 * We're crashing and already got the UNLOAD_RESPONSE, cleanup all
 	 * maybe-pending messages on all CPUs to be able to receive new
-- 
2.30.2



