Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8475114B74F
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:13:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729654AbgA1ONS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:13:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:34878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729644AbgA1ONR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:13:17 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DCA5824688;
        Tue, 28 Jan 2020 14:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220796;
        bh=RZ1sODP1ldMC06iwda+M+fbSP1+nZXkoTs5hhf0lzt8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KvSFiK2FSyPfPN+QYnw+Rf+JXS/p5Hzu5dcCMJxgCvoqaGJ2sjutr+zW1YiHTeiNu
         Pxuvtx1r7ZNMvQ/5KnP9U3JCN4hKg3A6iMXCPd+gR656y5pZ/LI7I/RN1fiWWfv2ir
         P4N4mpC+GEC/XyGb5ro8+4ZykcJQc5O/EnlMoQsY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Wahren <stefan.wahren@in-tech.com>,
        Stefan Wahren <wahrenst@gmx.net>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 149/183] net: qca_spi: Move reset_count to struct qcaspi
Date:   Tue, 28 Jan 2020 15:06:08 +0100
Message-Id: <20200128135844.615158035@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135829.486060649@linuxfoundation.org>
References: <20200128135829.486060649@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Wahren <stefan.wahren@in-tech.com>

[ Upstream commit bc19c32904e36548335b35fdce6ce734e20afc0a ]

The reset counter is specific for every QCA700x chip. So move this
into the private driver struct. Otherwise we get unpredictable reset
behavior in setups with multiple QCA700x chips.

Fixes: 291ab06ecf67 (net: qualcomm: new Ethernet over SPI driver for QCA7000)
Signed-off-by: Stefan Wahren <stefan.wahren@in-tech.com>
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qualcomm/qca_spi.c | 9 ++++-----
 drivers/net/ethernet/qualcomm/qca_spi.h | 1 +
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/qca_spi.c b/drivers/net/ethernet/qualcomm/qca_spi.c
index 7886a8a5b55b3..fb944e65c6324 100644
--- a/drivers/net/ethernet/qualcomm/qca_spi.c
+++ b/drivers/net/ethernet/qualcomm/qca_spi.c
@@ -438,7 +438,6 @@ qcaspi_qca7k_sync(struct qcaspi *qca, int event)
 	u16 signature = 0;
 	u16 spi_config;
 	u16 wrbuf_space = 0;
-	static u16 reset_count;
 
 	if (event == QCASPI_EVENT_CPUON) {
 		/* Read signature twice, if not valid
@@ -491,13 +490,13 @@ qcaspi_qca7k_sync(struct qcaspi *qca, int event)
 
 		qca->sync = QCASPI_SYNC_RESET;
 		qca->stats.trig_reset++;
-		reset_count = 0;
+		qca->reset_count = 0;
 		break;
 	case QCASPI_SYNC_RESET:
-		reset_count++;
+		qca->reset_count++;
 		netdev_dbg(qca->net_dev, "sync: waiting for CPU on, count %u.\n",
-			   reset_count);
-		if (reset_count >= QCASPI_RESET_TIMEOUT) {
+			   qca->reset_count);
+		if (qca->reset_count >= QCASPI_RESET_TIMEOUT) {
 			/* reset did not seem to take place, try again */
 			qca->sync = QCASPI_SYNC_UNKNOWN;
 			qca->stats.reset_timeout++;
diff --git a/drivers/net/ethernet/qualcomm/qca_spi.h b/drivers/net/ethernet/qualcomm/qca_spi.h
index 6e31a0e744a45..c48c314ca4dfa 100644
--- a/drivers/net/ethernet/qualcomm/qca_spi.h
+++ b/drivers/net/ethernet/qualcomm/qca_spi.h
@@ -97,6 +97,7 @@ struct qcaspi {
 
 	unsigned int intr_req;
 	unsigned int intr_svc;
+	u16 reset_count;
 
 #ifdef CONFIG_DEBUG_FS
 	struct dentry *device_root;
-- 
2.20.1



