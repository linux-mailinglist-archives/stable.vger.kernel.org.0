Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE442F79D7
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:42:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731278AbhAOMlp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:41:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:47140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388335AbhAOMjh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:39:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD7262399A;
        Fri, 15 Jan 2021 12:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714337;
        bh=fsrdxB3UmLzbpBpovDqV2RUVWXXFaljarkDsemZlapM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tRF7xUFVuxkaoN5aB2UM67npbkXHxIHDcSe19KRj4HWPpsPqCBPEr5Prn0SYJ/7oG
         zGP91olbcY/BKkgRKgk3en3v/KoaccTER9LhkADCUCF/S23uqnw1ndhq0DVNmYdK0K
         1GW0gnVI7+xEsyqo5mL3OnOlXqN6muEzDQHSd+uQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Chulski <stefanc@marvell.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 090/103] net: mvpp2: disable force link UP during port init procedure
Date:   Fri, 15 Jan 2021 13:28:23 +0100
Message-Id: <20210115122010.369182537@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115122006.047132306@linuxfoundation.org>
References: <20210115122006.047132306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Chulski <stefanc@marvell.com>

commit 87508224485323ce2d4e7fb929ec80f51adcc238 upstream.

Force link UP can be enabled by bootloader during tftpboot
and breaks NFS support.
Force link UP disabled during port init procedure.

Fixes: f84bf386f395 ("net: mvpp2: initialize the GoP")
Signed-off-by: Stefan Chulski <stefanc@marvell.com>
Acked-by: Marcin Wojtas <mw@semihalf.com>
Link: https://lore.kernel.org/r/1608216735-14501-1-git-send-email-stefanc@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -5480,7 +5480,7 @@ static int mvpp2_port_init(struct mvpp2_
 	struct mvpp2 *priv = port->priv;
 	struct mvpp2_txq_pcpu *txq_pcpu;
 	unsigned int thread;
-	int queue, err;
+	int queue, err, val;
 
 	/* Checks for hardware constraints */
 	if (port->first_rxq + port->nrxqs >
@@ -5494,6 +5494,18 @@ static int mvpp2_port_init(struct mvpp2_
 	mvpp2_egress_disable(port);
 	mvpp2_port_disable(port);
 
+	if (mvpp2_is_xlg(port->phy_interface)) {
+		val = readl(port->base + MVPP22_XLG_CTRL0_REG);
+		val &= ~MVPP22_XLG_CTRL0_FORCE_LINK_PASS;
+		val |= MVPP22_XLG_CTRL0_FORCE_LINK_DOWN;
+		writel(val, port->base + MVPP22_XLG_CTRL0_REG);
+	} else {
+		val = readl(port->base + MVPP2_GMAC_AUTONEG_CONFIG);
+		val &= ~MVPP2_GMAC_FORCE_LINK_PASS;
+		val |= MVPP2_GMAC_FORCE_LINK_DOWN;
+		writel(val, port->base + MVPP2_GMAC_AUTONEG_CONFIG);
+	}
+
 	port->tx_time_coal = MVPP2_TXDONE_COAL_USEC;
 
 	port->txqs = devm_kcalloc(dev, port->ntxqs, sizeof(*port->txqs),


