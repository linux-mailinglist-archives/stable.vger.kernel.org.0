Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FCD219915C
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:20:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731324AbgCaJQL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:16:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:36786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731870AbgCaJQK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:16:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03EF620675;
        Tue, 31 Mar 2020 09:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585646169;
        bh=St995Wd1RmOD++GY9bUxVb2UFud/otFNFnRTSJ7OFns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lx/8qEcAZ3d34NuNAAEhqRXC//efcKpmCmXoCKYEXJdKUxy7MLIGRvoaBOiuw5y92
         9Q2D4akD133p6PnctrffHxMOFjhjto22DqdVmuLVWAL8JO+JTOQLOlFwkD3P/i/7fP
         JzlydhGV1tSCtraMBhL30UXhuE0lZ7zldWe1R2ZU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Wiedmann <jwi@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 066/155] s390/qeth: dont reset default_out_queue
Date:   Tue, 31 Mar 2020 10:58:26 +0200
Message-Id: <20200331085425.859642916@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085418.274292403@linuxfoundation.org>
References: <20200331085418.274292403@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/net/qeth_core_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index b727d1e34523e..ac8ad951a4203 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -1244,7 +1244,6 @@ static int qeth_osa_set_output_queues(struct qeth_card *card, bool single)
 	if (count == 1)
 		dev_info(&card->gdev->dev, "Priority Queueing not supported\n");
 
-	card->qdio.default_out_queue = single ? 0 : QETH_DEFAULT_QUEUE;
 	card->qdio.no_out_queues = count;
 	return 0;
 }
-- 
2.20.1



