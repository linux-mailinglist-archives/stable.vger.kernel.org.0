Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11FA92A168F
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:47:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727787AbgJaLqx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:46:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:47482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727964AbgJaLqO (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:46:14 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B313205F4;
        Sat, 31 Oct 2020 11:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144774;
        bh=SMfhHhQwtwwMYs3J42tcHlFTpIPOsdFSqU6SIl2UIY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZMqCwToCinzmLb8f5yOiwu0YaPQG+DT2sdvC2NJN/bjWeJaM/t4r82tXfKibPQySk
         j8esOa1m81wQT+xQ3eKvjIFWUt80zSqoFxvZb+OUeXMfgs+FPaQy5f4bcl16UJ1LlL
         oVdYxk4hVMmmCIQA6PeGJyHMihJWk8t1/Wp6nCxk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Tomasz Maciej Nowak <tmn505@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.9 57/74] ata: ahci: mvebu: Make SATA PHY optional for Armada 3720
Date:   Sat, 31 Oct 2020 12:36:39 +0100
Message-Id: <20201031113502.764538603@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201031113500.031279088@linuxfoundation.org>
References: <20201031113500.031279088@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

commit 45aefe3d2251e4e229d7662052739f96ad1d08d9 upstream.

Older ATF does not provide SMC call for SATA phy power on functionality and
therefore initialization of ahci_mvebu is failing when older version of ATF
is using. In this case phy_power_on() function returns -EOPNOTSUPP.

This patch adds a new hflag AHCI_HFLAG_IGN_NOTSUPP_POWER_ON which cause
that ahci_platform_enable_phys() would ignore -EOPNOTSUPP errors from
phy_power_on() call.

It fixes initialization of ahci_mvebu on Espressobin boards where is older
Marvell's Arm Trusted Firmware without SMC call for SATA phy power.

This is regression introduced in commit 8e18c8e58da64 ("arm64: dts: marvell:
armada-3720-espressobin: declare SATA PHY property") where SATA phy was
defined and therefore ahci_platform_enable_phys() on Espressobin started
failing.

Fixes: 8e18c8e58da64 ("arm64: dts: marvell: armada-3720-espressobin: declare SATA PHY property")
Signed-off-by: Pali Rohár <pali@kernel.org>
Tested-by: Tomasz Maciej Nowak <tmn505@gmail.com>
Cc: <stable@vger.kernel.org> # 5.1+: ea17a0f153af: phy: marvell: comphy: Convert internal SMCC firmware return codes to errno
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ata/ahci.h             |    2 ++
 drivers/ata/ahci_mvebu.c       |    2 +-
 drivers/ata/libahci_platform.c |    2 +-
 3 files changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -240,6 +240,8 @@ enum {
 							as default lpm_policy */
 	AHCI_HFLAG_SUSPEND_PHYS		= (1 << 26), /* handle PHYs during
 							suspend/resume */
+	AHCI_HFLAG_IGN_NOTSUPP_POWER_ON	= (1 << 27), /* ignore -EOPNOTSUPP
+							from phy_power_on() */
 
 	/* ap->flags bits */
 
--- a/drivers/ata/ahci_mvebu.c
+++ b/drivers/ata/ahci_mvebu.c
@@ -227,7 +227,7 @@ static const struct ahci_mvebu_plat_data
 
 static const struct ahci_mvebu_plat_data ahci_mvebu_armada_3700_plat_data = {
 	.plat_config = ahci_mvebu_armada_3700_config,
-	.flags = AHCI_HFLAG_SUSPEND_PHYS,
+	.flags = AHCI_HFLAG_SUSPEND_PHYS | AHCI_HFLAG_IGN_NOTSUPP_POWER_ON,
 };
 
 static const struct of_device_id ahci_mvebu_of_match[] = {
--- a/drivers/ata/libahci_platform.c
+++ b/drivers/ata/libahci_platform.c
@@ -59,7 +59,7 @@ int ahci_platform_enable_phys(struct ahc
 		}
 
 		rc = phy_power_on(hpriv->phys[i]);
-		if (rc) {
+		if (rc && !(rc == -EOPNOTSUPP && (hpriv->flags & AHCI_HFLAG_IGN_NOTSUPP_POWER_ON))) {
 			phy_exit(hpriv->phys[i]);
 			goto disable_phys;
 		}


