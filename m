Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4422CA910B
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390008AbfIDSNO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:13:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:57920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390637AbfIDSNN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:13:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C6D122CEA;
        Wed,  4 Sep 2019 18:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620793;
        bh=e4VEkKiQELvj7Z6AAa95aiGEQyZjhunkkdsvdZzpoo8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q0gmUIjhao0S0JdrOJsQcjF6V6r+0e1r6Tcw18evvsxdb8vh56jMXiUSxSHg9wv5b
         hHJk86G/RXUciac/EFz1ckKIoxpkQ2ctMF8ZZs9FeEKATMxZdPegoExQIsPK8wI/x0
         +bnj+6CI2dufSg0x6mAhQFgpY1xUTscAMKaeDUF4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Philip Langdale <philipl@overt.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Manuel Presnitz <mail@mpy.de>
Subject: [PATCH 5.2 095/143] mmc: core: Fix init of SD cards reporting an invalid VDD range
Date:   Wed,  4 Sep 2019 19:53:58 +0200
Message-Id: <20190904175317.892860511@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175314.206239922@linuxfoundation.org>
References: <20190904175314.206239922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ulf Hansson <ulf.hansson@linaro.org>

commit 72741084d903e65e121c27bd29494d941729d4a1 upstream.

The OCR register defines the supported range of VDD voltages for SD cards.
However, it has turned out that some SD cards reports an invalid voltage
range, for example having bit7 set.

When a host supports MMC_CAP2_FULL_PWR_CYCLE and some of the voltages from
the invalid VDD range, this triggers the core to run a power cycle of the
card to try to initialize it at the lowest common supported voltage.
Obviously this fails, since the card can't support it.

Let's fix this problem, by clearing invalid bits from the read OCR register
for SD cards, before proceeding with the VDD voltage negotiation.

Cc: stable@vger.kernel.org
Reported-by: Philip Langdale <philipl@overt.org>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Reviewed-by: Philip Langdale <philipl@overt.org>
Tested-by: Philip Langdale <philipl@overt.org>
Tested-by: Manuel Presnitz <mail@mpy.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/core/sd.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/mmc/core/sd.c
+++ b/drivers/mmc/core/sd.c
@@ -1292,6 +1292,12 @@ int mmc_attach_sd(struct mmc_host *host)
 			goto err;
 	}
 
+	/*
+	 * Some SD cards claims an out of spec VDD voltage range. Let's treat
+	 * these bits as being in-valid and especially also bit7.
+	 */
+	ocr &= ~0x7FFF;
+
 	rocr = mmc_select_voltage(host, ocr);
 
 	/*


