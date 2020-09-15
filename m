Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3094826B55E
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:43:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727507AbgIOXnA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:43:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:46456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727053AbgIOOd4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:33:56 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0FD0623C15;
        Tue, 15 Sep 2020 14:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179908;
        bh=rkonbVPsr0oZPYkcby95d+DG0vos/txgJ7Bkz/jsP48=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ki3DBXnWPdBftQmCvw5tv+HsIlIFm43M44H9FDH6IHfzWcAMwPmS5xyePE6DCCMNZ
         0z/ZO/q/mDChYWbDQQ1KVsBGhfGfI6BEGpqHxdam2ND+03AMXTPW7eX9X6H03TWGra
         b1BMHjxT9P0xIqWNk1IQnHrdGiarAoCM5HT+R89o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tomas Henzl <thenzl@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 033/177] scsi: mpt3sas: Dont call disable_irq from IRQ poll handler
Date:   Tue, 15 Sep 2020 16:11:44 +0200
Message-Id: <20200915140655.229076300@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tomas Henzl <thenzl@redhat.com>

[ Upstream commit b614d55b970d08bcac5b0bc15a5526181b3e4459 ]

disable_irq() might sleep, replace it with disable_irq_nosync(). For
synchronisation 'irq_poll_scheduled' is sufficient

Fixes: 320e77acb3 scsi: mpt3sas: Irq poll to avoid CPU hard lockups
Link: https://lore.kernel.org/r/20200901145026.12174-1-thenzl@redhat.com
Signed-off-by: Tomas Henzl <thenzl@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 96b78fdc6b8a9..a85c9672c6ea3 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -1732,7 +1732,7 @@ _base_irqpoll(struct irq_poll *irqpoll, int budget)
 	reply_q = container_of(irqpoll, struct adapter_reply_queue,
 			irqpoll);
 	if (reply_q->irq_line_enable) {
-		disable_irq(reply_q->os_irq);
+		disable_irq_nosync(reply_q->os_irq);
 		reply_q->irq_line_enable = false;
 	}
 	num_entries = _base_process_reply_queue(reply_q);
-- 
2.25.1



