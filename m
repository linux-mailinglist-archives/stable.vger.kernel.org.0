Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3C5AA8E75
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:33:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387456AbfIDR6I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 13:58:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:36466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387991AbfIDR6H (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 13:58:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 769C522CF7;
        Wed,  4 Sep 2019 17:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567619887;
        bh=71JlX85HloXRuFk35f6G10fhXpqx61Us6ZgYwqEoDeA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=leG1P1Mm2C22K5VPiq+Kpz/8qovMBXguxPh/2rspN8cDzyZ2bzZB0XwRsCRxXOEoR
         V9ygc126N1kuCqw73o4UQg+NkbWfguEJCc49S6IyD8cSrkCkBUsx1Aj1Fz8yajdDfv
         pJzz5HVyiCby80PMtPyrBa8QBZ+mp3adeoQxnfh4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Philip Langdale <philipl@overt.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Manuel Presnitz <mail@mpy.de>
Subject: [PATCH 4.4 72/77] mmc: core: Fix init of SD cards reporting an invalid VDD range
Date:   Wed,  4 Sep 2019 19:53:59 +0200
Message-Id: <20190904175310.073705023@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175303.317468926@linuxfoundation.org>
References: <20190904175303.317468926@linuxfoundation.org>
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
@@ -1232,6 +1232,12 @@ int mmc_attach_sd(struct mmc_host *host)
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


