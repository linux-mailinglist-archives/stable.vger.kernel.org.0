Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74C5EACCF6
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 14:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729742AbfIHMoS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 08:44:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:58818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729735AbfIHMoR (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 08:44:17 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8848421920;
        Sun,  8 Sep 2019 12:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567946657;
        bh=jaiPO4WwP8gIgvXqmYmnleiQmHpvd5tKNuZEiZG9TLo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E6pfAWU5T9bTWVElJ+z1PWlpPX5uM6C7rb/qEhsxB1vyoOLyMrnNphnNkIBheQbjZ
         5oSWYr2AWRobd+JlNO74LlTuHXGjaOjGNTw3m1VM/MYihwZVz0p1vEhSGmEY2ESoW2
         Qan1hTRBIjOCP0lVJckGyiG7e3jhJogNyvNZVNCg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Graf <agraf@suse.de>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Brown <broonie@kernel.org>, Eric Anholt <eric@anholt.net>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com, linux-spi@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 18/26] spi: bcm2835aux: ensure interrupts are enabled for shared handler
Date:   Sun,  8 Sep 2019 13:41:57 +0100
Message-Id: <20190908121108.502407891@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190908121057.216802689@linuxfoundation.org>
References: <20190908121057.216802689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit bc519d9574618e47a0c788000fb78da95e18d953 ]

The BCM2835 AUX SPI has a shared interrupt line (with AUX UART).
Downstream fixes this with an AUX irqchip to demux the IRQ sources and a
DT change which breaks compatibility with older kernels. The AUX irqchip
was already rejected for upstream[1] and the DT change would break
working systems if the DTB is updated to a newer one. The latter issue
was brought to my attention by Alex Graf.

The root cause however is a bug in the shared handler. Shared handlers
must check that interrupts are actually enabled before servicing the
interrupt. Add a check that the TXEMPTY or IDLE interrupts are enabled.

[1] https://patchwork.kernel.org/patch/9781221/

Cc: Alexander Graf <agraf@suse.de>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Eric Anholt <eric@anholt.net>
Cc: Stefan Wahren <stefan.wahren@i2se.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Ray Jui <rjui@broadcom.com>
Cc: Scott Branden <sbranden@broadcom.com>
Cc: bcm-kernel-feedback-list@broadcom.com
Cc: linux-spi@vger.kernel.org
Cc: linux-rpi-kernel@lists.infradead.org
Cc: linux-arm-kernel@lists.infradead.org
Signed-off-by: Rob Herring <robh@kernel.org>
Reviewed-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-bcm2835aux.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/spi/spi-bcm2835aux.c b/drivers/spi/spi-bcm2835aux.c
index 7428091d3f5b8..bd00b7cc8b78b 100644
--- a/drivers/spi/spi-bcm2835aux.c
+++ b/drivers/spi/spi-bcm2835aux.c
@@ -184,6 +184,11 @@ static irqreturn_t bcm2835aux_spi_interrupt(int irq, void *dev_id)
 	struct bcm2835aux_spi *bs = spi_master_get_devdata(master);
 	irqreturn_t ret = IRQ_NONE;
 
+	/* IRQ may be shared, so return if our interrupts are disabled */
+	if (!(bcm2835aux_rd(bs, BCM2835_AUX_SPI_CNTL1) &
+	      (BCM2835_AUX_SPI_CNTL1_TXEMPTY | BCM2835_AUX_SPI_CNTL1_IDLE)))
+		return ret;
+
 	/* check if we have data to read */
 	while (bs->rx_len &&
 	       (!(bcm2835aux_rd(bs, BCM2835_AUX_SPI_STAT) &
-- 
2.20.1



