Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0CE133B657
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:59:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232076AbhCON5n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:57:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:34534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231382AbhCON5J (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:57:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 53E5764EFD;
        Mon, 15 Mar 2021 13:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816628;
        bh=/ARiGRTysZEO0zch14sIudIpLeSsRLsa8TZ0ZFfxbQc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NmoQkCSMlfYCec+n8+h0wN9bI3/YaS+AtlxUaOHLMMus2mRYsqhTBEPjPDBDJmDDe
         E5Iy2tWf5FmYxzbD8ARtHFM/LutuHnzoSAkZgtoR9s3KqwHHCMkY84vo/YoyMcqole
         zbJ6iv3k5TI4J9ORMDqAOcNj0gPMU4znOwTY00Nw=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Torin Cooper-Bennun <torin@maxiluxsystems.com>
Subject: [PATCH 5.4 013/168] can: tcan4x5x: tcan4x5x_init(): fix initialization - clear MRAM before entering Normal Mode
Date:   Mon, 15 Mar 2021 14:54:05 +0100
Message-Id: <20210315135550.775526741@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135550.333963635@linuxfoundation.org>
References: <20210315135550.333963635@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Torin Cooper-Bennun <torin@maxiluxsystems.com>

commit 2712625200ed69c642b9abc3a403830c4643364c upstream.

This patch prevents a potentially destructive race condition. The
device is fully operational on the bus after entering Normal Mode, so
zeroing the MRAM after entering this mode may lead to loss of
information, e.g. new received messages.

This patch fixes the problem by first initializing the MRAM, then
bringing the device into Normale Mode.

Fixes: 5443c226ba91 ("can: tcan4x5x: Add tcan4x5x driver to the kernel")
Link: https://lore.kernel.org/r/20210226163440.313628-1-torin@maxiluxsystems.com
Suggested-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Torin Cooper-Bennun <torin@maxiluxsystems.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/m_can/tcan4x5x.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/can/m_can/tcan4x5x.c
+++ b/drivers/net/can/m_can/tcan4x5x.c
@@ -325,14 +325,14 @@ static int tcan4x5x_init(struct m_can_cl
 	if (ret)
 		return ret;
 
+	/* Zero out the MCAN buffers */
+	m_can_init_ram(cdev);
+
 	ret = regmap_update_bits(tcan4x5x->regmap, TCAN4X5X_CONFIG,
 				 TCAN4X5X_MODE_SEL_MASK, TCAN4X5X_MODE_NORMAL);
 	if (ret)
 		return ret;
 
-	/* Zero out the MCAN buffers */
-	m_can_init_ram(cdev);
-
 	return ret;
 }
 


