Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F2901D8497
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732336AbgERSMe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:12:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:48670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731073AbgERSDV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:03:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E4B120853;
        Mon, 18 May 2020 18:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589825000;
        bh=qPiPvnOGJzhRxWccUafyKknE9pRDCl2DUrjtZb6VY4k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E1snMUohdoan0/P+MKbqUQ4U/ur3mu2vp4bV6Vy6JGFGhxWcH4XFqWaO0gg8BBrdH
         RQfTpz8rqLvncqWpVSQxpfk9dsHmWZX5EtS/Bg3ZdpX2WUIOwqYOB033r97SILQn1P
         PUUtM981Krj7HSNOgYWiMPxR2KgBjyOmndaKh8Qo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Grzegorz Kowal <custos.mentis@gmail.com>,
        Ben Chuang <ben.chuang@genesyslogic.com.tw>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 090/194] mmc: sdhci-pci-gli: Fix can not access GL9750 after reboot from Windows 10
Date:   Mon, 18 May 2020 19:36:20 +0200
Message-Id: <20200518173539.125024739@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
References: <20200518173531.455604187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Chuang <ben.chuang@genesyslogic.com.tw>

[ Upstream commit b56ff195c317ad28c05d354aeecbb9995b8e08c1 ]

Need to clear some bits in a vendor-defined register after reboot from
Windows 10.

Fixes: e51df6ce668a ("mmc: host: sdhci-pci: Add Genesys Logic GL975x support")
Reported-by: Grzegorz Kowal <custos.mentis@gmail.com>
Signed-off-by: Ben Chuang <ben.chuang@genesyslogic.com.tw>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Tested-by: Grzegorz Kowal <custos.mentis@gmail.com>
Link: https://lore.kernel.org/r/20200504063957.6638-1-benchuanggli@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci-pci-gli.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/mmc/host/sdhci-pci-gli.c b/drivers/mmc/host/sdhci-pci-gli.c
index ff39d81a5742c..fd76aa672e020 100644
--- a/drivers/mmc/host/sdhci-pci-gli.c
+++ b/drivers/mmc/host/sdhci-pci-gli.c
@@ -26,6 +26,9 @@
 #define   SDHCI_GLI_9750_DRIVING_2    GENMASK(27, 26)
 #define   GLI_9750_DRIVING_1_VALUE    0xFFF
 #define   GLI_9750_DRIVING_2_VALUE    0x3
+#define   SDHCI_GLI_9750_SEL_1        BIT(29)
+#define   SDHCI_GLI_9750_SEL_2        BIT(31)
+#define   SDHCI_GLI_9750_ALL_RST      (BIT(24)|BIT(25)|BIT(28)|BIT(30))
 
 #define SDHCI_GLI_9750_PLL	      0x864
 #define   SDHCI_GLI_9750_PLL_TX2_INV    BIT(23)
@@ -122,6 +125,8 @@ static void gli_set_9750(struct sdhci_host *host)
 				    GLI_9750_DRIVING_1_VALUE);
 	driving_value |= FIELD_PREP(SDHCI_GLI_9750_DRIVING_2,
 				    GLI_9750_DRIVING_2_VALUE);
+	driving_value &= ~(SDHCI_GLI_9750_SEL_1|SDHCI_GLI_9750_SEL_2|SDHCI_GLI_9750_ALL_RST);
+	driving_value |= SDHCI_GLI_9750_SEL_2;
 	sdhci_writel(host, driving_value, SDHCI_GLI_9750_DRIVING);
 
 	sw_ctrl_value &= ~SDHCI_GLI_9750_SW_CTRL_4;
-- 
2.20.1



