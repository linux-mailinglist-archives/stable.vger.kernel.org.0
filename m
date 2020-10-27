Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2C8629B16C
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:31:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1759359AbgJ0O3d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:29:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:56194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2896873AbgJ0O3c (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:29:32 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74C2E20780;
        Tue, 27 Oct 2020 14:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808972;
        bh=tULIUWg7B1YAOLBcOrrNpuzvW9BE7hWcS42Al0xnG6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rdudtSihF8K4dwDEujhDjPMq08vvYzYKFbvtZ4oxiQQvIHHMP/mJjCYy+Bayvf/So
         uC3SuI37gfPj7B+Oexk2UUjbTuYFfVKVUKo992zcc5/vPuWvm7kzN/dDIVP40kX/60
         VZ+py0gvxR5IBGN2/Jmy1J5tbdePKiAIfc1M5gnc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dylan Hung <dylan_hung@aspeedtech.com>,
        Joel Stanley <joel@jms.id.au>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 029/408] net: ftgmac100: Fix Aspeed ast2600 TX hang issue
Date:   Tue, 27 Oct 2020 14:49:27 +0100
Message-Id: <20201027135456.416277333@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dylan Hung <dylan_hung@aspeedtech.com>

[ Upstream commit 137d23cea1c044b2d4853ac71bc68126b25fdbb2 ]

The new HW arbitration feature on Aspeed ast2600 will cause MAC TX to
hang when handling scatter-gather DMA.  Disable the problematic feature
by setting MAC register 0x58 bit28 and bit27.

Fixes: 39bfab8844a0 ("net: ftgmac100: Add support for DT phy-handle property")
Signed-off-by: Dylan Hung <dylan_hung@aspeedtech.com>
Reviewed-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/faraday/ftgmac100.c |    5 +++++
 drivers/net/ethernet/faraday/ftgmac100.h |    8 ++++++++
 2 files changed, 13 insertions(+)

--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -1807,6 +1807,11 @@ static int ftgmac100_probe(struct platfo
 		priv->rxdes0_edorr_mask = BIT(30);
 		priv->txdes0_edotr_mask = BIT(30);
 		priv->is_aspeed = true;
+		/* Disable ast2600 problematic HW arbitration */
+		if (of_device_is_compatible(np, "aspeed,ast2600-mac")) {
+			iowrite32(FTGMAC100_TM_DEFAULT,
+				  priv->base + FTGMAC100_OFFSET_TM);
+		}
 	} else {
 		priv->rxdes0_edorr_mask = BIT(15);
 		priv->txdes0_edotr_mask = BIT(15);
--- a/drivers/net/ethernet/faraday/ftgmac100.h
+++ b/drivers/net/ethernet/faraday/ftgmac100.h
@@ -170,6 +170,14 @@
 #define FTGMAC100_MACCR_SW_RST		(1 << 31)
 
 /*
+ * test mode control register
+ */
+#define FTGMAC100_TM_RQ_TX_VALID_DIS (1 << 28)
+#define FTGMAC100_TM_RQ_RR_IDLE_PREV (1 << 27)
+#define FTGMAC100_TM_DEFAULT                                                   \
+	(FTGMAC100_TM_RQ_TX_VALID_DIS | FTGMAC100_TM_RQ_RR_IDLE_PREV)
+
+/*
  * PHY control register
  */
 #define FTGMAC100_PHYCR_MDC_CYCTHR_MASK	0x3f


