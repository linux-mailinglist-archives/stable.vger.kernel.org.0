Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1B292C0B29
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:55:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730972AbgKWNUm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:20:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:52038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732215AbgKWMjR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:39:17 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A60E2065E;
        Mon, 23 Nov 2020 12:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135156;
        bh=M6L+Nawp5+EPafUv3Lj7DKn06qbCVDGJ6RaSKEWqFxc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wmh4nqKesNUfXWzaxJMPF84XSrjCpe8BdLzhkqjtqu0GhCkUkVSmYmMd7UmOKIs6G
         BaAe2jXsigLZOfKM8HosamJxJZSDfrDeddoc0zhinWm7TnNfv6L942WncXGEU6jm1x
         h+93/dpE9bIWzn1l90eYpb5ThBsPviyMPUp24Yi0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jimmy Assarsson <extja@kvaser.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 095/158] can: kvaser_pciefd: Fix KCAN bittiming limits
Date:   Mon, 23 Nov 2020 13:22:03 +0100
Message-Id: <20201123121824.515427206@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121819.943135899@linuxfoundation.org>
References: <20201123121819.943135899@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jimmy Assarsson <extja@kvaser.com>

[ Upstream commit 470e14c00c63752466ac44de392f584dfdddd82e ]

Use correct bittiming limits for the KCAN CAN controller.

Fixes: 26ad340e582d ("can: kvaser_pciefd: Add driver for Kvaser PCIEcan devices")
Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
Link: https://lore.kernel.org/r/20201115163027.16851-1-jimmyassarsson@gmail.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/kvaser_pciefd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/kvaser_pciefd.c b/drivers/net/can/kvaser_pciefd.c
index 6f766918211a4..72acd1ba162d2 100644
--- a/drivers/net/can/kvaser_pciefd.c
+++ b/drivers/net/can/kvaser_pciefd.c
@@ -287,12 +287,12 @@ struct kvaser_pciefd_tx_packet {
 static const struct can_bittiming_const kvaser_pciefd_bittiming_const = {
 	.name = KVASER_PCIEFD_DRV_NAME,
 	.tseg1_min = 1,
-	.tseg1_max = 255,
+	.tseg1_max = 512,
 	.tseg2_min = 1,
 	.tseg2_max = 32,
 	.sjw_max = 16,
 	.brp_min = 1,
-	.brp_max = 4096,
+	.brp_max = 8192,
 	.brp_inc = 1,
 };
 
-- 
2.27.0



