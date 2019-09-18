Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD7AB5CC9
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 08:29:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730212AbfIRGZ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 02:25:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:47140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727354AbfIRGZ5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 02:25:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4ECB20644;
        Wed, 18 Sep 2019 06:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568787956;
        bh=8BE/lpZrr/5Pu+KEzEfHOzkl83WA58DfCYAgxnND3Ls=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xXyljRO0dQ+CXVGjEpAkResB4DkeOIoLS+yThtGNrtSxNXdbGpKwmXuv+hq0WWVZC
         eP7oPqTb/n0Ii0yYUiMvf8wnpnSWXlrM6hLaluNBEV5bByrCW4QeDLeCH+RmVQ2K/G
         cSBQznMOZtPdcb4rEBp/SqP7WuTZgSUzFONtW+dI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stanislaw Gruszka <sgruszka@redhat.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sergey Maranchuk <slav0nic0@gmail.com>
Subject: [PATCH 5.2 39/85] Revert "rt2800: enable TX_PIN_CFG_LNA_PE_ bits per band"
Date:   Wed, 18 Sep 2019 08:18:57 +0200
Message-Id: <20190918061235.375519420@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190918061234.107708857@linuxfoundation.org>
References: <20190918061234.107708857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit 13fa451568ab9e8b3074ef741477c7938c713c42 upstream.

This reverts commit 9ad3b55654455258a9463384edb40077439d879f.

As reported by Sergey:

"I got some problem after upgrade kernel to 5.2 version (debian testing
linux-image-5.2.0-2-amd64). 5Ghz client  stopped to see AP.
Some tests with 1metre distance between client-AP: 2.4Ghz  -22dBm, for
5Ghz - 53dBm !, for longer distance (8m + walls) 2.4 - 61dBm, 5Ghz not
visible."

It was identified that rx signal level degradation was caused by
9ad3b5565445 ("rt2800: enable TX_PIN_CFG_LNA_PE_ bits per band").
So revert this commit.

Cc: <stable@vger.kernel.org> # v5.1+
Reported-and-tested-by: Sergey Maranchuk <slav0nic0@gmail.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c |   18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -4156,24 +4156,18 @@ static void rt2800_config_channel(struct
 	switch (rt2x00dev->default_ant.rx_chain_num) {
 	case 3:
 		/* Turn on tertiary LNAs */
-		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_LNA_PE_A2_EN,
-				   rf->channel > 14);
-		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_LNA_PE_G2_EN,
-				   rf->channel <= 14);
+		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_LNA_PE_A2_EN, 1);
+		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_LNA_PE_G2_EN, 1);
 		/* fall-through */
 	case 2:
 		/* Turn on secondary LNAs */
-		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_LNA_PE_A1_EN,
-				   rf->channel > 14);
-		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_LNA_PE_G1_EN,
-				   rf->channel <= 14);
+		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_LNA_PE_A1_EN, 1);
+		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_LNA_PE_G1_EN, 1);
 		/* fall-through */
 	case 1:
 		/* Turn on primary LNAs */
-		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_LNA_PE_A0_EN,
-				   rf->channel > 14);
-		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_LNA_PE_G0_EN,
-				   rf->channel <= 14);
+		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_LNA_PE_A0_EN, 1);
+		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_LNA_PE_G0_EN, 1);
 		break;
 	}
 


