Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 343C7323DFB
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:25:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236497AbhBXNVK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:21:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:59908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236037AbhBXNMw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 08:12:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6582164DD3;
        Wed, 24 Feb 2021 12:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171334;
        bh=5VdOYbHd3n1TGvFYWBW2iyUbe2wxn98SJo9zrpDrw+I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CVMU3i1/7I79ZCMv3/RmQC4iMu6AhIR3u+F6soHXi1vsC+/NUj2NjS5slgXbRXdUe
         aqxgXKrNLvKpKPv9B+cN3hVA6KKq4+3eQnqCpMEbU0u/G8iz0zET80xcvU7BiH+alW
         376EySr4aI5Ne3HkG98Z5pqjqcD77ClBOnZBxe1UJdogll0qN+DPnD//x5OD6mBNrm
         +Wo2pKBKbzN9LcP3y1/VRv+lhQGLetA29e9H9CMLaOcC1icSE9OqWMm2XqFUkHb4o9
         PE68HCBzhGnKQV+TqsqJBViFHHY9JphSfsN8zJujDOdm/PC3uVMJxotDaFKpAWa5Q2
         IadWjEeCcMnNw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>,
        Juan Vazquez <juvazq@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-hyperv@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 15/16] Drivers: hv: vmbus: Resolve race condition in vmbus_onoffer_rescind()
Date:   Wed, 24 Feb 2021 07:55:12 -0500
Message-Id: <20210224125514.483935-15-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125514.483935-1-sashal@kernel.org>
References: <20210224125514.483935-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>

[ Upstream commit e4d221b42354b2e2ddb9187a806afb651eee2cda ]

An erroneous or malicious host could send multiple rescind messages for
a same channel.  In vmbus_onoffer_rescind(), the guest maps the channel
ID to obtain a pointer to the channel object and it eventually releases
such object and associated data.  The host could time rescind messages
and lead to an use-after-free.  Add a new flag to the channel structure
to make sure that only one instance of vmbus_onoffer_rescind() can get
the reference to the channel object.

Reported-by: Juan Vazquez <juvazq@microsoft.com>
Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Link: https://lore.kernel.org/r/20201209070827.29335-6-parri.andrea@gmail.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/channel_mgmt.c | 12 ++++++++++++
 include/linux/hyperv.h    |  1 +
 2 files changed, 13 insertions(+)

diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
index 5bf633c15cd4b..6ddda97030628 100644
--- a/drivers/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -942,6 +942,18 @@ static void vmbus_onoffer_rescind(struct vmbus_channel_message_header *hdr)
 
 	mutex_lock(&vmbus_connection.channel_mutex);
 	channel = relid2channel(rescind->child_relid);
+	if (channel != NULL) {
+		/*
+		 * Guarantee that no other instance of vmbus_onoffer_rescind()
+		 * has got a reference to the channel object.  Synchronize on
+		 * &vmbus_connection.channel_mutex.
+		 */
+		if (channel->rescind_ref) {
+			mutex_unlock(&vmbus_connection.channel_mutex);
+			return;
+		}
+		channel->rescind_ref = true;
+	}
 	mutex_unlock(&vmbus_connection.channel_mutex);
 
 	if (channel == NULL) {
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index 63cd81e5610d1..22e2c2d75361e 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -710,6 +710,7 @@ struct vmbus_channel {
 	u8 monitor_bit;
 
 	bool rescind; /* got rescind msg */
+	bool rescind_ref; /* got rescind msg, got channel reference */
 	struct completion rescind_event;
 
 	u32 ringbuffer_gpadlhandle;
-- 
2.27.0

