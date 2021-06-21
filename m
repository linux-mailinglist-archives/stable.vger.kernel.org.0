Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0295D3AEDAC
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231346AbhFUQWA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:22:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:41976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231483AbhFUQVB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:21:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7A4D6115B;
        Mon, 21 Jun 2021 16:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292326;
        bh=1x1hRAZ6Pi+CYrRjBq9UTSxGmEdKMGhQ4ei0K8P946A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XGMFpOSRv8TH8lu+ICCeoK2f4x8Gl9MRMUo+MjeEJr5NBPcaWFesFNSz2X8meXiq9
         +bDR2EjrtI2nNxw43Z5++0F4O6D3LM68jHVvgNJb3rE6r8+ZEX/GfvwJ87d0xrH+es
         81eQVpCD5R9Gz4p8pYX0g88SwIKWzUrPbPm0tLuk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Norbert Slusarek <nslusarek@gmx.net>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.4 50/90] can: bcm: fix infoleak in struct bcm_msg_head
Date:   Mon, 21 Jun 2021 18:15:25 +0200
Message-Id: <20210621154905.834965762@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154904.159672728@linuxfoundation.org>
References: <20210621154904.159672728@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
 net/can/bcm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -404,6 +404,7 @@ static enum hrtimer_restart bcm_tx_timeo
 		if (!op->count && (op->flags & TX_COUNTEVT)) {
 
 			/* create notification to user */
+			memset(&msg_head, 0, sizeof(msg_head));
 			msg_head.opcode  = TX_EXPIRED;
 			msg_head.flags   = op->flags;
 			msg_head.count   = op->count;
@@ -441,6 +442,7 @@ static void bcm_rx_changed(struct bcm_op
 	/* this element is not throttled anymore */
 	data->flags &= (BCM_CAN_FLAGS_MASK|RX_RECV);
 
+	memset(&head, 0, sizeof(head));
 	head.opcode  = RX_CHANGED;
 	head.flags   = op->flags;
 	head.count   = op->count;
@@ -562,6 +564,7 @@ static enum hrtimer_restart bcm_rx_timeo
 	}
 
 	/* create notification to user */
+	memset(&msg_head, 0, sizeof(msg_head));
 	msg_head.opcode  = RX_TIMEOUT;
 	msg_head.flags   = op->flags;
 	msg_head.count   = op->count;


