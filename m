Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89FCE2B64A1
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:50:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732396AbgKQNe5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:34:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:45610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732389AbgKQNez (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:34:55 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 321E32465E;
        Tue, 17 Nov 2020 13:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620095;
        bh=stb4IzjJer82EyL8ykEJcgeYA5dN/7TaUve1TQJ+6FQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nqLPtiEmQu7SYaHpgXLniak5GIUx8nXi1TtgrpcTzlzRlwG03FUxrcR6zu+JStirF
         9DR1vlKh/8EfT85prwcK+QyxP3PApsAvcYpoWHyi7u+U+bRcM6VLmbvTld88N1D4XG
         0zF2pyZml/EDw9wWkmMvQKytXdlr2DPX2rFczABg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tomas Henzl <thenzl@redhat.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 106/255] scsi: mpt3sas: Fix timeouts observed while reenabling IRQ
Date:   Tue, 17 Nov 2020 14:04:06 +0100
Message-Id: <20201117122144.117352216@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>

[ Upstream commit 5feed64f9199ff90c4239971733f23f30aeb2484 ]

While reenabling the IRQ after irq poll there may be small time window
where HBA firmware has posted some replies and raise the interrupts but
driver has not received the interrupts. So we may observe I/O timeouts as
the driver has not processed the replies as interrupts got missed while
reenabling the IRQ.

To fix this issue the driver has to go for one more round of processing the
reply descriptors from reply descriptor post queue after enabling the IRQ.

Link: https://lore.kernel.org/r/20201102072746.27410-1-sreekanth.reddy@broadcom.com
Reported-by: Tomas Henzl <thenzl@redhat.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index e86682dc34eca..87d05c1950870 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -1742,6 +1742,13 @@ _base_irqpoll(struct irq_poll *irqpoll, int budget)
 		reply_q->irq_poll_scheduled = false;
 		reply_q->irq_line_enable = true;
 		enable_irq(reply_q->os_irq);
+		/*
+		 * Go for one more round of processing the
+		 * reply descriptor post queue incase if HBA
+		 * Firmware has posted some reply descriptors
+		 * while reenabling the IRQ.
+		 */
+		_base_process_reply_queue(reply_q);
 	}
 
 	return num_entries;
-- 
2.27.0



