Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C580D328447
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:36:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232847AbhCAQc6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:32:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:60808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234583AbhCAQ1C (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:27:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E97F364EE6;
        Mon,  1 Mar 2021 16:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614615739;
        bh=ZkhmouR1ABSL6l5Si2Cvofoh3fwpuQsyR/9RV4khVRU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xj8hUZWcBlFHs+Qf/ELegFYowkbYam0AOQv0zc6CyE3vXdDjfhkPG9TIpK9Saj2yH
         XAQrXF5GONa2JZrtCNReTRzLI0gDwRTlmotG/lrqRtU945/KLuauQL3+sLQG2jYA5I
         qdXTf9b3c4pXhlYZeNktg+KAN5Sj4A19r1RHMfBs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 043/134] ata: ahci_brcm: Add back regulators management
Date:   Mon,  1 Mar 2021 17:12:24 +0100
Message-Id: <20210301161015.692041996@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161013.585393984@linuxfoundation.org>
References: <20210301161013.585393984@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 10340f8d7b6dd54e616339c8ccb2f397133ebea0 ]

While reworking the resources management and departing from using
ahci_platform_enable_resources() which did not allow a proper step
separation like we need, we unfortunately lost the ability to control
AHCI regulators. This broke some Broadcom STB systems that do expect
regulators to be turned on to link up with attached hard drives.

Fixes: c0cdf2ac4b5b ("ata: ahci_brcm: Fix AHCI resources management")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/ahci_brcm.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/ahci_brcm.c b/drivers/ata/ahci_brcm.c
index f50a76ad63e4a..8354f2de37c31 100644
--- a/drivers/ata/ahci_brcm.c
+++ b/drivers/ata/ahci_brcm.c
@@ -285,6 +285,10 @@ static int brcm_ahci_resume(struct device *dev)
 	if (ret)
 		return ret;
 
+	ret = ahci_platform_enable_regulators(hpriv);
+	if (ret)
+		goto out_disable_clks;
+
 	brcm_sata_init(priv);
 	brcm_sata_phys_enable(priv);
 	brcm_sata_alpm_init(hpriv);
@@ -314,6 +318,8 @@ out_disable_platform_phys:
 	ahci_platform_disable_phys(hpriv);
 out_disable_phys:
 	brcm_sata_phys_disable(priv);
+	ahci_platform_disable_regulators(hpriv);
+out_disable_clks:
 	ahci_platform_disable_clks(hpriv);
 	return ret;
 }
@@ -377,6 +383,10 @@ static int brcm_ahci_probe(struct platform_device *pdev)
 	if (ret)
 		goto out_reset;
 
+	ret = ahci_platform_enable_regulators(hpriv);
+	if (ret)
+		goto out_disable_clks;
+
 	/* Must be first so as to configure endianness including that
 	 * of the standard AHCI register space.
 	 */
@@ -386,7 +396,7 @@ static int brcm_ahci_probe(struct platform_device *pdev)
 	priv->port_mask = brcm_ahci_get_portmask(hpriv, priv);
 	if (!priv->port_mask) {
 		ret = -ENODEV;
-		goto out_disable_clks;
+		goto out_disable_regulators;
 	}
 
 	/* Must be done before ahci_platform_enable_phys() */
@@ -417,6 +427,8 @@ out_disable_platform_phys:
 	ahci_platform_disable_phys(hpriv);
 out_disable_phys:
 	brcm_sata_phys_disable(priv);
+out_disable_regulators:
+	ahci_platform_disable_regulators(hpriv);
 out_disable_clks:
 	ahci_platform_disable_clks(hpriv);
 out_reset:
-- 
2.27.0



