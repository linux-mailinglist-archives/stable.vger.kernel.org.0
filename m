Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74B0E2268DB
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732360AbgGTQWK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:22:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:43894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733119AbgGTQHL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:07:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04EC122CBB;
        Mon, 20 Jul 2020 16:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261230;
        bh=yzw0LtptuaaNYe9G/8UNQgeYu5qs1/sEz+ovQuGKVQY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xrdWBYy1cTUEEXxiz+5FTlT5oO9Au04M0lfypYZRFwnjjzAnvZxVNoJ/h3wHlbjuN
         4eJmPGpTnh5/uqts+YDZtbd7i4ZFxDeuGkXitfvq5YwFOJY4f9FzjguLRf5M+mt+P8
         Un+h53IliW8mjIlfO1bcQ0bl9njW2MnOUBIbpIl8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Carl Huang <cjhuang@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.7 010/244] net: qrtr: free flow in __qrtr_node_release
Date:   Mon, 20 Jul 2020 17:34:41 +0200
Message-Id: <20200720152826.358902706@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Carl Huang <cjhuang@codeaurora.org>

[ Upstream commit 28541f3d324f6de1e545e2875283b6cef95c5d36 ]

The flow is allocated in qrtr_tx_wait, but not freed when qrtr node
is released. (*slot) becomes NULL after radix_tree_iter_delete is
called in __qrtr_node_release. The fix is to save (*slot) to a
vairable and then free it.

This memory leak is catched when kmemleak is enabled in kernel,
the report looks like below:

unreferenced object 0xffffa0de69e08420 (size 32):
  comm "kworker/u16:3", pid 176, jiffies 4294918275 (age 82858.876s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 28 84 e0 69 de a0 ff ff  ........(..i....
    28 84 e0 69 de a0 ff ff 03 00 00 00 00 00 00 00  (..i............
  backtrace:
    [<00000000e252af0a>] qrtr_node_enqueue+0x38e/0x400 [qrtr]
    [<000000009cea437f>] qrtr_sendmsg+0x1e0/0x2a0 [qrtr]
    [<000000008bddbba4>] sock_sendmsg+0x5b/0x60
    [<0000000003beb43a>] qmi_send_message.isra.3+0xbe/0x110 [qmi_helpers]
    [<000000009c9ae7de>] qmi_send_request+0x1c/0x20 [qmi_helpers]

Signed-off-by: Carl Huang <cjhuang@codeaurora.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/qrtr/qrtr.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -166,6 +166,7 @@ static void __qrtr_node_release(struct k
 {
 	struct qrtr_node *node = container_of(kref, struct qrtr_node, ref);
 	struct radix_tree_iter iter;
+	struct qrtr_tx_flow *flow;
 	unsigned long flags;
 	void __rcu **slot;
 
@@ -181,8 +182,9 @@ static void __qrtr_node_release(struct k
 
 	/* Free tx flow counters */
 	radix_tree_for_each_slot(slot, &node->qrtr_tx_flow, &iter, 0) {
+		flow = *slot;
 		radix_tree_iter_delete(&node->qrtr_tx_flow, &iter, slot);
-		kfree(*slot);
+		kfree(flow);
 	}
 	kfree(node);
 }


