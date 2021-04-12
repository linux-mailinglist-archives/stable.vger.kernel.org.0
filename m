Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FCB035BE3E
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:57:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238874AbhDLI50 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:57:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:47610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238997AbhDLIzS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:55:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC8E861289;
        Mon, 12 Apr 2021 08:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217678;
        bh=I5wQw1PcHeB/reKsXI21BtbvRcMrYPGstAvHwkLSSKg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VzBmSHCU85RxtBqcpS9iO8zsNIemF5fP06w2PB7W2wbxbOZpy5B7lvmniGccfOPGp
         2LxXXacWFF253aqvw+Ag64lz5OapSMDR6n9Imm7ZspjeecscMKIEMI9rLphySm0OWF
         n2pucT+P7azA6dPTgyD39ezQcxWLV+npucKQD4+Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 098/188] ARM: OMAP4: Fix PMIC voltage domains for bionic
Date:   Mon, 12 Apr 2021 10:40:12 +0200
Message-Id: <20210412084016.905191111@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084013.643370347@linuxfoundation.org>
References: <20210412084013.643370347@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 30916faa1a6009122e10d0c42338b8db44a36fde ]

We are now registering the mpu domain three times instead of registering
mpu, core and iva domains like we should.

Fixes: d44fa156dcb2 ("ARM: OMAP2+: Configure voltage controller for cpcap")
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap2/pmic-cpcap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-omap2/pmic-cpcap.c b/arch/arm/mach-omap2/pmic-cpcap.c
index 09076ad0576d..668dc84fd31e 100644
--- a/arch/arm/mach-omap2/pmic-cpcap.c
+++ b/arch/arm/mach-omap2/pmic-cpcap.c
@@ -246,10 +246,10 @@ int __init omap4_cpcap_init(void)
 	omap_voltage_register_pmic(voltdm, &omap443x_max8952_mpu);
 
 	if (of_machine_is_compatible("motorola,droid-bionic")) {
-		voltdm = voltdm_lookup("mpu");
+		voltdm = voltdm_lookup("core");
 		omap_voltage_register_pmic(voltdm, &omap_cpcap_core);
 
-		voltdm = voltdm_lookup("mpu");
+		voltdm = voltdm_lookup("iva");
 		omap_voltage_register_pmic(voltdm, &omap_cpcap_iva);
 	} else {
 		voltdm = voltdm_lookup("core");
-- 
2.30.2



