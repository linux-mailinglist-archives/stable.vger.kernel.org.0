Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA4047294F
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:20:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240046AbhLMKTg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:19:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239382AbhLMKQQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:16:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19573C0FD23C;
        Mon, 13 Dec 2021 01:55:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B4520B80E63;
        Mon, 13 Dec 2021 09:55:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2D2BC34601;
        Mon, 13 Dec 2021 09:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389324;
        bh=oSCvSU7IpX7Ps17Z2x9O67H4wLD7UQ9Pt+nl410x/Ck=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xkHNKsbzqoDCMIpG+F7TuI43sd/M3jpRdg1X+qLzeR86DrYw4Wruuzm0GJKfBiHLk
         nuUIruHTJX3AFSpXGoBU7VyhKdIV2aGpHZ11RE+67B6J1Qzv2PWnf8MVz0MiGslWvp
         aX5KooBxlw7AUpdr9RZf812ctAijmSCk/AWL3+mU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matt Kline <matt@bitbashing.io>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.15 027/171] can: m_can: pci: fix iomap_read_fifo() and iomap_write_fifo()
Date:   Mon, 13 Dec 2021 10:29:02 +0100
Message-Id: <20211213092945.977261704@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>

commit d737de2d7cc3efdacbf17d4e22efc75697bd76d9 upstream.

The same fix that was previously done in m_can_platform in commit
99d173fbe894 ("can: m_can: fix iomap_read_fifo() and iomap_write_fifo()")
is required in m_can_pci as well to make iomap_read_fifo() and
iomap_write_fifo() work for val_count > 1.

Fixes: 812270e5445b ("can: m_can: Batch FIFO writes during CAN transmit")
Fixes: 1aa6772f64b4 ("can: m_can: Batch FIFO reads during CAN receive")
Link: https://lore.kernel.org/all/20211118144011.10921-1-matthias.schiffer@ew.tq-group.com
Cc: stable@vger.kernel.org
Cc: Matt Kline <matt@bitbashing.io>
Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Tested-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/m_can/m_can_pci.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/drivers/net/can/m_can/m_can_pci.c
+++ b/drivers/net/can/m_can/m_can_pci.c
@@ -42,8 +42,13 @@ static u32 iomap_read_reg(struct m_can_c
 static int iomap_read_fifo(struct m_can_classdev *cdev, int offset, void *val, size_t val_count)
 {
 	struct m_can_pci_priv *priv = cdev_to_priv(cdev);
+	void __iomem *src = priv->base + offset;
 
-	ioread32_rep(priv->base + offset, val, val_count);
+	while (val_count--) {
+		*(unsigned int *)val = ioread32(src);
+		val += 4;
+		src += 4;
+	}
 
 	return 0;
 }
@@ -61,8 +66,13 @@ static int iomap_write_fifo(struct m_can
 			    const void *val, size_t val_count)
 {
 	struct m_can_pci_priv *priv = cdev_to_priv(cdev);
+	void __iomem *dst = priv->base + offset;
 
-	iowrite32_rep(priv->base + offset, val, val_count);
+	while (val_count--) {
+		iowrite32(*(unsigned int *)val, dst);
+		val += 4;
+		dst += 4;
+	}
 
 	return 0;
 }


