Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 225AF3B6450
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 17:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235345AbhF1PGv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 11:06:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:39766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237100AbhF1PFN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 11:05:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3EB7361CFA;
        Mon, 28 Jun 2021 14:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891404;
        bh=oKG8iw/f0gj3dw4E80juK/oRhN8as7ttYcrj0IquFzQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JJVcWjNrvPooIMBOt85kV4MOEZ45fvsEpHeuzHiqlbMoriicma2mcQ9hTF006037a
         NiH3vcfB4rpANFbEPmXxJc1zhllRzRS74ze3X3qJvWn5gFEkX2EIX/Pz+ozBujyHde
         XuRR4jpMyFaw7A3a4l5ugDnQ5jwFRbjYHwczsljzcHOGMdnu4mwULfjPbop0YFAEdo
         nP5lI+J3noRi2HbTTa6o4waUj1J3uB3bOTqX2FCO6InG+Mus+3Bs9Zxd1qxawcQqD2
         GSDer3wRiNnNjVpS9PP7FXSC+Kd4bh80lKpCsIyuQzRcd0QRLhIv6lEha33aYhJaJe
         TcvNDIYvzirYw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Norbert Slusarek <nslusarek@gmx.net>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.4 31/57] can: bcm: fix infoleak in struct bcm_msg_head
Date:   Mon, 28 Jun 2021 10:42:30 -0400
Message-Id: <20210628144256.34524-32-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628144256.34524-1-sashal@kernel.org>
References: <20210628144256.34524-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.274-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.274-rc1
X-KernelTest-Deadline: 2021-06-30T14:42+00:00
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
index 1f15622d3c65..bd9e10db6cd7 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -392,6 +392,7 @@ static void bcm_tx_timeout_tsklet(unsigned long data)
 		if (!op->count && (op->flags & TX_COUNTEVT)) {
 
 			/* create notification to user */
+			memset(&msg_head, 0, sizeof(msg_head));
 			msg_head.opcode  = TX_EXPIRED;
 			msg_head.flags   = op->flags;
 			msg_head.count   = op->count;
@@ -439,6 +440,7 @@ static void bcm_rx_changed(struct bcm_op *op, struct can_frame *data)
 	/* this element is not throttled anymore */
 	data->can_dlc &= (BCM_CAN_DLC_MASK|RX_RECV);
 
+	memset(&head, 0, sizeof(head));
 	head.opcode  = RX_CHANGED;
 	head.flags   = op->flags;
 	head.count   = op->count;
@@ -550,6 +552,7 @@ static void bcm_rx_timeout_tsklet(unsigned long data)
 	struct bcm_msg_head msg_head;
 
 	/* create notification to user */
+	memset(&msg_head, 0, sizeof(msg_head));
 	msg_head.opcode  = RX_TIMEOUT;
 	msg_head.flags   = op->flags;
 	msg_head.count   = op->count;
-- 
2.30.2

