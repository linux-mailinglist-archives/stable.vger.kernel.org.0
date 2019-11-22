Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 853FB106FAF
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:17:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729279AbfKVKtH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:49:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:58260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729995AbfKVKtG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:49:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A51520715;
        Fri, 22 Nov 2019 10:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574419744;
        bh=JZdrSf66McTwmVPyGVXRXf/zpqf72r7V9/3MkaYOAbA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hszOb+BKfTOLAcdM9CKoSpzqOVQmVCC2XgZOfnT0w/ktvV4YZEJaY59SXQN11OZ2M
         wazEiElggdPRhkhi8i648RUBeG6kW0pDxNdBvPlNbx+6FCeBXgn2m09IzbfaZngaru
         7kUVDHF50cY1VwgFhk8n3Ys0woJ+Apl+Iqfw4Usk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 163/222] ata: ahci_brcm: Allow using driver or DSL SoCs
Date:   Fri, 22 Nov 2019 11:28:23 +0100
Message-Id: <20191122100914.392555480@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100830.874290814@linuxfoundation.org>
References: <20191122100830.874290814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 7fb44929cb0e5cdcde143e1ca3ca57b5b8247db0 ]

The Broadcom STB AHCI controller is the same as the one found on DSL
SoCs, so we will utilize the same driver on these systems as well.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index 5d16fc4fa46c7..a8d4f4b5a77eb 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -100,7 +100,8 @@ config SATA_AHCI_PLATFORM
 
 config AHCI_BRCM
 	tristate "Broadcom AHCI SATA support"
-	depends on ARCH_BRCMSTB || BMIPS_GENERIC || ARCH_BCM_NSP
+	depends on ARCH_BRCMSTB || BMIPS_GENERIC || ARCH_BCM_NSP || \
+		   ARCH_BCM_63XX
 	help
 	  This option enables support for the AHCI SATA3 controller found on
 	  Broadcom SoC's.
-- 
2.20.1



