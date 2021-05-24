Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C42738EE76
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234339AbhEXPvA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:51:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:33922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234107AbhEXPs3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:48:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CAE0061492;
        Mon, 24 May 2021 15:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870645;
        bh=Jbp0dyKfEnwaO2xXfVC0H7Cf3zzyZ2HP6DBEF+6ZlSE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E3WCdb1ruq61vDyYeXVcRVC5S1A6VckdJFD1I2RuR0TuP4GHWh75sTb2pNoGhwwCB
         62Y52hrwEqkB0fkPq3Wlcp3vWgI+TZha4PLviOyh70QRccrWSsTlnghlgTeQizNL/Z
         jrAH1gexcyte3bRvP0AvUlAxhJ6DSzip1jO5CrkY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Beer <dlbeer@gmail.com>,
        Ben Chuang <benchuanggli@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.4 40/71] mmc: sdhci-pci-gli: increase 1.8V regulator wait
Date:   Mon, 24 May 2021 17:25:46 +0200
Message-Id: <20210524152327.770397183@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152326.447759938@linuxfoundation.org>
References: <20210524152326.447759938@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Beer <dlbeer@gmail.com>

commit a1149a6c06ee094a6e62886b0c0e8e66967a728a upstream.

Inserting an SD-card on an Intel NUC10i3FNK4 (which contains a GL9755)
results in the message:

    mmc0: 1.8V regulator output did not become stable

Following this message, some cards work (sometimes), but most cards fail
with EILSEQ. This behaviour is observed on Debian 10 running kernel
4.19.188, but also with 5.8.18 and 5.11.15.

The driver currently waits 5ms after switching on the 1.8V regulator for
it to become stable. Increasing this to 10ms gets rid of the warning
about stability, but most cards still fail. Increasing it to 20ms gets
some cards working (a 32GB Samsung micro SD works, a 128GB ADATA
doesn't). At 50ms, the ADATA works most of the time, and at 100ms both
cards work reliably.

Signed-off-by: Daniel Beer <dlbeer@gmail.com>
Acked-by: Ben Chuang <benchuanggli@gmail.com>
Fixes: e51df6ce668a ("mmc: host: sdhci-pci: Add Genesys Logic GL975x support")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210424081652.GA16047@nyquist.nev
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-pci-gli.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/mmc/host/sdhci-pci-gli.c
+++ b/drivers/mmc/host/sdhci-pci-gli.c
@@ -318,8 +318,13 @@ static void sdhci_gli_voltage_switch(str
 	 *
 	 * Wait 5ms after set 1.8V signal enable in Host Control 2 register
 	 * to ensure 1.8V signal enable bit is set by GL9750/GL9755.
+	 *
+	 * ...however, the controller in the NUC10i3FNK4 (a 9755) requires
+	 * slightly longer than 5ms before the control register reports that
+	 * 1.8V is ready, and far longer still before the card will actually
+	 * work reliably.
 	 */
-	usleep_range(5000, 5500);
+	usleep_range(100000, 110000);
 }
 
 static void sdhci_gl9750_reset(struct sdhci_host *host, u8 mask)


