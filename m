Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2269627C4C0
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729570AbgI2LQO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:16:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:60966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729567AbgI2LQO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:16:14 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D91C4208FE;
        Tue, 29 Sep 2020 11:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378173;
        bh=LJr5lMTFye2vxGi0Lfw2VYCci9SKwWK0bBAKI4s7QuI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fhQgECRuS15LS9ch75bznPX3mmlOY02mkeYlmMCBa9uYi1+/lB3y7dO+K3cJNvTBz
         5lbo1P+TM6dR1Br/fq0YtNjCmTFVBxx1sY0g2drhndMxGWJdnZj1h3L6FcotcgT0A1
         5EWrKAKyNCl+vun+a4o1YDody3pUJKvbS1QJ+nY4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mohan Kumar <mkumard@nvidia.com>,
        Viswanath L <viswanathl@nvidia.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 058/166] ALSA: hda: Clear RIRB status before reading WP
Date:   Tue, 29 Sep 2020 12:59:30 +0200
Message-Id: <20200929105938.115178101@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105935.184737111@linuxfoundation.org>
References: <20200929105935.184737111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mohan Kumar <mkumard@nvidia.com>

[ Upstream commit 6d011d5057ff88ee556c000ac6fe0be23bdfcd72 ]

RIRB interrupt status getting cleared after the write pointer is read
causes a race condition, where last response(s) into RIRB may remain
unserviced by IRQ, eventually causing azx_rirb_get_response to fall
back to polling mode. Clearing the RIRB interrupt status ahead of
write pointer access ensures that this condition is avoided.

Signed-off-by: Mohan Kumar <mkumard@nvidia.com>
Signed-off-by: Viswanath L <viswanathl@nvidia.com>
Link: https://lore.kernel.org/r/1580983853-351-1-git-send-email-viswanathl@nvidia.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_controller.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/sound/pci/hda/hda_controller.c b/sound/pci/hda/hda_controller.c
index fa261b27d8588..8198d2e53b7df 100644
--- a/sound/pci/hda/hda_controller.c
+++ b/sound/pci/hda/hda_controller.c
@@ -1169,16 +1169,23 @@ irqreturn_t azx_interrupt(int irq, void *dev_id)
 		if (snd_hdac_bus_handle_stream_irq(bus, status, stream_update))
 			active = true;
 
-		/* clear rirb int */
 		status = azx_readb(chip, RIRBSTS);
 		if (status & RIRB_INT_MASK) {
+			/*
+			 * Clearing the interrupt status here ensures that no
+			 * interrupt gets masked after the RIRB wp is read in
+			 * snd_hdac_bus_update_rirb. This avoids a possible
+			 * race condition where codec response in RIRB may
+			 * remain unserviced by IRQ, eventually falling back
+			 * to polling mode in azx_rirb_get_response.
+			 */
+			azx_writeb(chip, RIRBSTS, RIRB_INT_MASK);
 			active = true;
 			if (status & RIRB_INT_RESPONSE) {
 				if (chip->driver_caps & AZX_DCAPS_CTX_WORKAROUND)
 					udelay(80);
 				snd_hdac_bus_update_rirb(bus);
 			}
-			azx_writeb(chip, RIRBSTS, RIRB_INT_MASK);
 		}
 	} while (active && ++repeat < 10);
 
-- 
2.25.1



