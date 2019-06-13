Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56B6243FB6
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388929AbfFMP7d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 11:59:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:37312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731480AbfFMItf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:49:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BF26206BA;
        Thu, 13 Jun 2019 08:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415774;
        bh=FRMtpE/fbjkGP/2V8FIwkcRf6zRchrkvT6wBZYNj5x0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TjUffJ9f0N8FH832APkLF15dNXMaiU7AAnZHWpIfx3gsTD7hz+kZZtyqCsTbP5Lb3
         h1CDJP5+5FL0L2ti7wjW4ZfAHj8cwF4cmaI+dn69CAo5wXMryxtfJWUAnoP01Jpynm
         Z9bJGyZ1ZuUbOu6CQP7hVGQRDM7ZdKGQy+JC9JqA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kabir Sahane <x0153567@ti.com>,
        "Andrew F. Davis" <afd@ti.com>, Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 118/155] ARM: OMAP2+: pm33xx-core: Do not Turn OFF CEFUSE as PPA may be using it
Date:   Thu, 13 Jun 2019 10:33:50 +0200
Message-Id: <20190613075659.501071260@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075652.691765927@linuxfoundation.org>
References: <20190613075652.691765927@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 72aff4ecf1cb85a3c6e6b42ccbda0bc631b090b3 ]

This area is used to store keys by HSPPA in case of AM438x SOC. Leave it
active.

Signed-off-by: Kabir Sahane <x0153567@ti.com>
Signed-off-by: Andrew F. Davis <afd@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap2/pm33xx-core.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-omap2/pm33xx-core.c b/arch/arm/mach-omap2/pm33xx-core.c
index 724cf5774a6c..c93b6efd565f 100644
--- a/arch/arm/mach-omap2/pm33xx-core.c
+++ b/arch/arm/mach-omap2/pm33xx-core.c
@@ -51,10 +51,12 @@ static int amx3_common_init(void)
 
 	/* CEFUSE domain can be turned off post bootup */
 	cefuse_pwrdm = pwrdm_lookup("cefuse_pwrdm");
-	if (cefuse_pwrdm)
-		omap_set_pwrdm_state(cefuse_pwrdm, PWRDM_POWER_OFF);
-	else
+	if (!cefuse_pwrdm)
 		pr_err("PM: Failed to get cefuse_pwrdm\n");
+	else if (omap_type() != OMAP2_DEVICE_TYPE_GP)
+		pr_info("PM: Leaving EFUSE power domain active\n");
+	else
+		omap_set_pwrdm_state(cefuse_pwrdm, PWRDM_POWER_OFF);
 
 	return 0;
 }
-- 
2.20.1



