Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D86E026B6FF
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 02:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726996AbgIPAPq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 20:15:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:39912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726925AbgIOOYz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:24:55 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7448D22400;
        Tue, 15 Sep 2020 14:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179541;
        bh=OgzGJ0e6vcQBf4jmxuvDV6W+4piAJ1HNQbwRfK9j4qY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xZuyXbCG7yBoQM/5ir5VA42jmEciRYTqtu8Aur/azuzQV8u8t2Aae07WaQSl3XzTi
         XLJeWMUCTNyPy8a4rJa3ipudbqf17F9jJk2VCbUSEHTQoeIhB2FOkUFxp6IDJNwkbj
         i8lucqoSxmSrTDWDkVRvtlFlWspMDwerKe+T8C6s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tomas Henzl <thenzl@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 021/132] scsi: mpt3sas: Dont call disable_irq from IRQ poll handler
Date:   Tue, 15 Sep 2020 16:12:03 +0200
Message-Id: <20200915140645.134923993@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140644.037604909@linuxfoundation.org>
References: <20200915140644.037604909@linuxfoundation.org>
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
index 7fd1d731555f9..b7e44634d0dc2 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -1632,7 +1632,7 @@ _base_irqpoll(struct irq_poll *irqpoll, int budget)
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



