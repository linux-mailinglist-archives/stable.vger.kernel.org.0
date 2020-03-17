Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E396188064
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:09:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728985AbgCQLJr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:09:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:52300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728980AbgCQLJq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:09:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A3B78205ED;
        Tue, 17 Mar 2020 11:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584443386;
        bh=7dx3zFjLp/kz4Eo9FTGgZ8jdAx4ycmo7KZ3UhlG8kLI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=USRB3LjC+YwAn5Inn1EGPNI+Nk3XQ2Wbt4+rhRi8RfTotb6++82BekRW/FY1KDgo5
         ZUj8yFpRd/b2KG1Db1op51jYffDE43+TDmgbJ8ionuV2jEiumHUewet6mmu3ege0Ve
         toWXEE3lkSdxYZ3E2q6QnQcGHwUZLKJuadOgjybo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Wiedmann <jwi@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 067/151] s390/qeth: dont reset default_out_queue
Date:   Tue, 17 Mar 2020 11:54:37 +0100
Message-Id: <20200317103331.268594801@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103326.593639086@linuxfoundation.org>
References: <20200317103326.593639086@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>

[ Upstream commit 240c1948491b81cfe40f84ea040a8f2a4966f101 ]

When an OSA device in prio-queue setup is reduced to 1 TX queue due to
HW restrictions, we reset its the default_out_queue to 0.

In the old code this was needed so that qeth_get_priority_queue() gets
the queue selection right. But with proper multiqueue support we already
reduced dev->real_num_tx_queues to 1, and so the stack puts all traffic
on txq 0 without even calling .ndo_select_queue.

Thus we can preserve the user's configuration, and apply it if the OSA
device later re-gains support for multiple TX queues.

Fixes: 73dc2daf110f ("s390/qeth: add TX multiqueue support for OSA devices")
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/net/qeth_core_main.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -1244,7 +1244,6 @@ static int qeth_osa_set_output_queues(st
 	if (count == 1)
 		dev_info(&card->gdev->dev, "Priority Queueing not supported\n");
 
-	card->qdio.default_out_queue = single ? 0 : QETH_DEFAULT_QUEUE;
 	card->qdio.no_out_queues = count;
 	return 0;
 }


