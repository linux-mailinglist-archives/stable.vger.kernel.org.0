Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 265CC47ACD6
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:47:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237354AbhLTOrR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:47:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236918AbhLTOpN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:45:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6EA0C079798;
        Mon, 20 Dec 2021 06:43:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95351B80EF0;
        Mon, 20 Dec 2021 14:43:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7CAEC36AE8;
        Mon, 20 Dec 2021 14:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011392;
        bh=ZmppYWsiEz+vwR6RbXUz1zrf+CsowWaLIP644YxsmYw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uUbsf+84HWPpAZHjfOJJrHWN6YqBun3AHTaDGLpJHcqre7UhlgSXDkL/sZOlOV2Nm
         X3B/ydH/HbpOy1IAljfaoWMACeLsTs4BZeKeD8jysIN0gY6FheAhEGJnvdcxP9gjRZ
         aH11Vn9A5jZxvviGMfuNjATe4lV+dFvf/JyTa6q0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 39/56] net: systemport: Add global locking for descriptor lifecycle
Date:   Mon, 20 Dec 2021 15:34:32 +0100
Message-Id: <20211220143024.725551978@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143023.451982183@linuxfoundation.org>
References: <20211220143023.451982183@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

commit 8b8e6e782456f1ce02a7ae914bbd5b1053f0b034 upstream.

The descriptor list is a shared resource across all of the transmit queues, and
the locking mechanism used today only protects concurrency across a given
transmit queue between the transmit and reclaiming. This creates an opportunity
for the SYSTEMPORT hardware to work on corrupted descriptors if we have
multiple producers at once which is the case when using multiple transmit
queues.

This was particularly noticeable when using multiple flows/transmit queues and
it showed up in interesting ways in that UDP packets would get a correct UDP
header checksum being calculated over an incorrect packet length. Similarly TCP
packets would get an equally correct checksum computed by the hardware over an
incorrect packet length.

The SYSTEMPORT hardware maintains an internal descriptor list that it re-arranges
when the driver produces a new descriptor anytime it writes to the
WRITE_PORT_{HI,LO} registers, there is however some delay in the hardware to
re-organize its descriptors and it is possible that concurrent TX queues
eventually break this internal allocation scheme to the point where the
length/status part of the descriptor gets used for an incorrect data buffer.

The fix is to impose a global serialization for all TX queues in the short
section where we are writing to the WRITE_PORT_{HI,LO} registers which solves
the corruption even with multiple concurrent TX queues being used.

Fixes: 80105befdb4b ("net: systemport: add Broadcom SYSTEMPORT Ethernet MAC driver")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20211215202450.4086240-1-f.fainelli@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bcmsysport.c |    5 +++++
 drivers/net/ethernet/broadcom/bcmsysport.h |    1 +
 2 files changed, 6 insertions(+)

--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -120,9 +120,13 @@ static inline void tdma_port_write_desc_
 					     struct dma_desc *desc,
 					     unsigned int port)
 {
+	unsigned long desc_flags;
+
 	/* Ports are latched, so write upper address first */
+	spin_lock_irqsave(&priv->desc_lock, desc_flags);
 	tdma_writel(priv, desc->addr_status_len, TDMA_WRITE_PORT_HI(port));
 	tdma_writel(priv, desc->addr_lo, TDMA_WRITE_PORT_LO(port));
+	spin_unlock_irqrestore(&priv->desc_lock, desc_flags);
 }
 
 /* Ethtool operations */
@@ -2003,6 +2007,7 @@ static int bcm_sysport_open(struct net_d
 	}
 
 	/* Initialize both hardware and software ring */
+	spin_lock_init(&priv->desc_lock);
 	for (i = 0; i < dev->num_tx_queues; i++) {
 		ret = bcm_sysport_init_tx_ring(priv, i);
 		if (ret) {
--- a/drivers/net/ethernet/broadcom/bcmsysport.h
+++ b/drivers/net/ethernet/broadcom/bcmsysport.h
@@ -751,6 +751,7 @@ struct bcm_sysport_priv {
 	int			wol_irq;
 
 	/* Transmit rings */
+	spinlock_t		desc_lock;
 	struct bcm_sysport_tx_ring *tx_rings;
 
 	/* Receive queue */


