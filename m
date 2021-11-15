Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B8F9451427
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:05:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349069AbhKOUCF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 15:02:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:45222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344316AbhKOTYZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:24:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 14FAC6365F;
        Mon, 15 Nov 2021 18:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002548;
        bh=/ey6KH/q6sKRumaNec6m85EQxVO2256Ug52inxW9gkw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T1OzqItgABQvy2rJ0u+WcTbsYED4KiKCXzbUDP9uT7Nc3p0rru2a3+JjlJLEDzmQL
         L7hB/yQ+kKguLedR3tbrP+3whJar24Dm4e7YTNJ/4bIMFoH3gXpwRqiHzrqohs5kfh
         LfXH6bgZr5dmT8ZBz+iVxSqBDNKJVC1US+QyY1mY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sumit Saxena <sumit.saxena@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 610/917] scsi: megaraid_sas: Fix concurrent access to ISR between IRQ polling and real interrupt
Date:   Mon, 15 Nov 2021 18:01:45 +0100
Message-Id: <20211115165449.486280436@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sumit Saxena <sumit.saxena@broadcom.com>

[ Upstream commit e7dcc514a49e74051b869697d5ab0370f6301d57 ]

IRQ polling thread calls ISR after enable_irq() to handle any missed I/O
completion. The atomic flag "in_used" was added to have the synchronization
between the IRQ polling thread and the interrupt context. There is a bug
around it leading to a race condition.

Below is the sequence:

 - IRQ polling thread accesses ISR, fetches the reply descriptor.

 - Real interrupt arrives and pre-empts polling thread (enable_irq() is
   already called).

 - Interrupt context picks the same reply descriptor as fetched by polling
   thread, processes it, and exits.

 - Polling thread resumes and processes the descriptor which is already
   processed by interrupt thread leads to kernel crash.

Setting the "in_used" flag before fetching the reply descriptor ensures
synchronized access to ISR.

Link: https://www.spinics.net/lists/linux-scsi/msg159440.html
Link: https://lore.kernel.org/r/20210929124022.24605-2-sumit.saxena@broadcom.com
Fixes: 9bedd36e9146 ("scsi: megaraid_sas: Handle missing interrupts while re-enabling IRQs")
Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 26d0cf9353dd6..eb5ceb75a15ec 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -3530,6 +3530,9 @@ complete_cmd_fusion(struct megasas_instance *instance, u32 MSIxIndex,
 	if (atomic_read(&instance->adprecovery) == MEGASAS_HW_CRITICAL_ERROR)
 		return IRQ_HANDLED;
 
+	if (irq_context && !atomic_add_unless(&irq_context->in_used, 1, 1))
+		return 0;
+
 	desc = fusion->reply_frames_desc[MSIxIndex] +
 				fusion->last_reply_idx[MSIxIndex];
 
@@ -3540,11 +3543,11 @@ complete_cmd_fusion(struct megasas_instance *instance, u32 MSIxIndex,
 	reply_descript_type = reply_desc->ReplyFlags &
 		MPI2_RPY_DESCRIPT_FLAGS_TYPE_MASK;
 
-	if (reply_descript_type == MPI2_RPY_DESCRIPT_FLAGS_UNUSED)
+	if (reply_descript_type == MPI2_RPY_DESCRIPT_FLAGS_UNUSED) {
+		if (irq_context)
+			atomic_dec(&irq_context->in_used);
 		return IRQ_NONE;
-
-	if (irq_context && !atomic_add_unless(&irq_context->in_used, 1, 1))
-		return 0;
+	}
 
 	num_completed = 0;
 
-- 
2.33.0



