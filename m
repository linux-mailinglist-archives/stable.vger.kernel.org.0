Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40C483B628E
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236416AbhF1OsY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:48:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:50216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235099AbhF1OoN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:44:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2271C61CFB;
        Mon, 28 Jun 2021 14:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890838;
        bh=+fPmcfoA9qqM1w/D6dtgSeRkDeGJRFzdAT1LXr49WoU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lfimNYCk7Ihii38Nes/0nzafY9iOL0zAXqy89Zr+JdGf2P1YejOD62UEuPW/wGxJX
         nKuv82q94rYogO3tCG6vfgdJJw7tPxT4Y24rMnCNLjg4kxQnTFApG1W+aSy5+Ef+TT
         /uGHKfNsggAP7DvGqewEk1JM++1eDfjCB1rbEicyr4b4v4SKoaf0EhI+vmYEfD17ma
         a43IYwaNv3t8QKyUpOAkk6dpHdifA9iUYHigXQfd2SoROf5JIkTCxyj4bfocqudQPI
         bdWt0Jk6f+Og3OmUrOQsBSDgokC7vYKTtqBC5IIUFwRHDAyonrAWOGQA92ChLcZh1b
         3t8Iaf8qJxpgw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Norbert Slusarek <nslusarek@gmx.net>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.19 058/109] can: bcm: fix infoleak in struct bcm_msg_head
Date:   Mon, 28 Jun 2021 10:32:14 -0400
Message-Id: <20210628143305.32978-59-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143305.32978-1-sashal@kernel.org>
References: <20210628143305.32978-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.196-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.196-rc1
X-KernelTest-Deadline: 2021-06-30T14:32+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Norbert Slusarek <nslusarek@gmx.net>

commit 5e87ddbe3942e27e939bdc02deb8579b0cbd8ecc upstream.

On 64-bit systems, struct bcm_msg_head has an added padding of 4 bytes between
struct members count and ival1. Even though all struct members are initialized,
the 4-byte hole will contain data from the kernel stack. This patch zeroes out
struct bcm_msg_head before usage, preventing infoleaks to userspace.

Fixes: ffd980f976e7 ("[CAN]: Add broadcast manager (bcm) protocol")
Link: https://lore.kernel.org/r/trinity-7c1b2e82-e34f-4885-8060-2cd7a13769ce-1623532166177@3c-app-gmx-bs52
Cc: linux-stable <stable@vger.kernel.org>
Signed-off-by: Norbert Slusarek <nslusarek@gmx.net>
Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/can/bcm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/can/bcm.c b/net/can/bcm.c
index 79bb8afa9c0c..c82137fb2763 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -393,6 +393,7 @@ static void bcm_tx_timeout_tsklet(unsigned long data)
 		if (!op->count && (op->flags & TX_COUNTEVT)) {
 
 			/* create notification to user */
+			memset(&msg_head, 0, sizeof(msg_head));
 			msg_head.opcode  = TX_EXPIRED;
 			msg_head.flags   = op->flags;
 			msg_head.count   = op->count;
@@ -440,6 +441,7 @@ static void bcm_rx_changed(struct bcm_op *op, struct canfd_frame *data)
 	/* this element is not throttled anymore */
 	data->flags &= (BCM_CAN_FLAGS_MASK|RX_RECV);
 
+	memset(&head, 0, sizeof(head));
 	head.opcode  = RX_CHANGED;
 	head.flags   = op->flags;
 	head.count   = op->count;
@@ -554,6 +556,7 @@ static void bcm_rx_timeout_tsklet(unsigned long data)
 	struct bcm_msg_head msg_head;
 
 	/* create notification to user */
+	memset(&msg_head, 0, sizeof(msg_head));
 	msg_head.opcode  = RX_TIMEOUT;
 	msg_head.flags   = op->flags;
 	msg_head.count   = op->count;
-- 
2.30.2

