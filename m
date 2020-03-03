Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEF8017800F
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 19:59:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732314AbgCCRy2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:54:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:35592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732517AbgCCRy1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:54:27 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EEB2A206D5;
        Tue,  3 Mar 2020 17:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583258067;
        bh=YHXFE6QN7HtiBj1Mkt+G80ciFeW6QQPn2fBKaykZeQ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ETowBBpXfqZTp520LC0K5bQ/pcFkYgbY7DCFR6hrk9ixTSc513L7Vn7tdv4NczfN5
         HugqUTJ8PTr/mD8RIYP8tExGa7XjQ8NC0pXTiY+8annGDwona/MAepuPo6knl/xmMI
         hAPC/U2jBk4XUZcYbyv12DsPYKDxwxygaIIXgoVk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sameeh Jubran <sameehj@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 059/152] net: ena: ena-com.c: prevent NULL pointer dereference
Date:   Tue,  3 Mar 2020 18:42:37 +0100
Message-Id: <20200303174309.150387083@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174302.523080016@linuxfoundation.org>
References: <20200303174302.523080016@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

[ Upstream commit c207979f5ae10ed70aff1bb13f39f0736973de99 ]

comp_ctx can be NULL in a very rare case when an admin command is executed
during the execution of ena_remove().

The bug scenario is as follows:

* ena_destroy_device() sets the comp_ctx to be NULL
* An admin command is executed before executing unregister_netdev(),
  this can still happen because our device can still receive callbacks
  from the netdev infrastructure such as ethtool commands.
* When attempting to access the comp_ctx, the bug occurs since it's set
  to NULL

Fix:
Added a check that comp_ctx is not NULL

Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_com.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
index 74743fd8a1e0a..304531332e70a 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -200,6 +200,11 @@ static void comp_ctxt_release(struct ena_com_admin_queue *queue,
 static struct ena_comp_ctx *get_comp_ctxt(struct ena_com_admin_queue *queue,
 					  u16 command_id, bool capture)
 {
+	if (unlikely(!queue->comp_ctx)) {
+		pr_err("Completion context is NULL\n");
+		return NULL;
+	}
+
 	if (unlikely(command_id >= queue->q_depth)) {
 		pr_err("command id is larger than the queue size. cmd_id: %u queue size %d\n",
 		       command_id, queue->q_depth);
-- 
2.20.1



