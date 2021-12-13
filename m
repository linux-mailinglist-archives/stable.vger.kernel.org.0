Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 063454727D5
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:06:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237706AbhLMKFM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:05:12 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:49818 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240474AbhLMKB6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:01:58 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 64D72CE0F60;
        Mon, 13 Dec 2021 10:01:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D9B5C34600;
        Mon, 13 Dec 2021 10:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389714;
        bh=u0AtQoLqwH2s+1c8fUnA2GJ5fF1TZkWccvA58DJuqQM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H3d+2pJbckvYqNTVu56gdm/o8McBRVOP37O0wCdCiWEiC8RMUPcwY0qBiONQTALm9
         G5ZtTV89qF2nZ/6YN4sCpkeeNpkTZ7XQR2F72Nkm8EEgvGlPPb459vjuklUd6Searw
         TJAlYCz0GMdrYu5bp/+BOFnS3II6tvNfFdnohOqw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Billy Tsai <billy_tsai@aspeedtech.com>,
        Joel Stanley <joel@jms.id.au>, Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.15 163/171] irqchip/aspeed-scu: Replace update_bits with write_bits.
Date:   Mon, 13 Dec 2021 10:31:18 +0100
Message-Id: <20211213092950.497257971@linuxfoundation.org>
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

From: Billy Tsai <billy_tsai@aspeedtech.com>

commit 8958389681b929fcc7301e7dc5f0da12e4a256a0 upstream.

The interrupt status bits are cleared by writing 1, we should force a
write to clear the interrupt without checking if the value has changed.

Fixes: 04f605906ff0 ("irqchip: Add Aspeed SCU interrupt controller")
Signed-off-by: Billy Tsai <billy_tsai@aspeedtech.com>
Reviewed-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20211124094348.11621-1-billy_tsai@aspeedtech.com
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-aspeed-scu-ic.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/irqchip/irq-aspeed-scu-ic.c
+++ b/drivers/irqchip/irq-aspeed-scu-ic.c
@@ -76,8 +76,8 @@ static void aspeed_scu_ic_irq_handler(st
 		generic_handle_domain_irq(scu_ic->irq_domain,
 					  bit - scu_ic->irq_shift);
 
-		regmap_update_bits(scu_ic->scu, scu_ic->reg, mask,
-				   BIT(bit + ASPEED_SCU_IC_STATUS_SHIFT));
+		regmap_write_bits(scu_ic->scu, scu_ic->reg, mask,
+				  BIT(bit + ASPEED_SCU_IC_STATUS_SHIFT));
 	}
 
 	chained_irq_exit(chip, desc);


