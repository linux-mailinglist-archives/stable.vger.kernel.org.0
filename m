Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09F2611B512
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:52:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732237AbfLKPVq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:21:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:52178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731843AbfLKPVq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:21:46 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 061EA22B48;
        Wed, 11 Dec 2019 15:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077705;
        bh=/dvgmQLUN6wuX8fkvJhaeVPNjrPICtvsB+kOHdqPQro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Li8KSETe0LX9WzSybc9IujVn1th81isSuUS6OFe5djDCq9kdZWTXyVrx/wYU4H/Ab
         nT/RvJ7dlBS/PbgXqtEm2iwii/VuWHLs3jxB3xH0sPd1HIzM5UAeUpxpmDrUUKomnv
         bljYEvUSE4JPZy1cNIWupHFN0NXbRo9QoTxr+WBw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 138/243] ARM: OMAP1/2: fix SoC name printing
Date:   Wed, 11 Dec 2019 16:05:00 +0100
Message-Id: <20191211150348.475025265@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aaro Koskinen <aaro.koskinen@iki.fi>

[ Upstream commit 04a92358b3964988c78dfe370a559ae550383886 ]

Currently we get extra newlines on OMAP1/2 when the SoC name is printed:

[    0.000000] OMAP1510
[    0.000000]  revision 2 handled as 15xx id: bc058c9b93111a16

[    0.000000] OMAP2420
[    0.000000]

Fix by using pr_cont.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap1/id.c | 6 +++---
 arch/arm/mach-omap2/id.c | 4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-omap1/id.c b/arch/arm/mach-omap1/id.c
index 52de382fc8047..7e49dfda3d2f4 100644
--- a/arch/arm/mach-omap1/id.c
+++ b/arch/arm/mach-omap1/id.c
@@ -200,10 +200,10 @@ void __init omap_check_revision(void)
 		printk(KERN_INFO "Unknown OMAP cpu type: 0x%02x\n", cpu_type);
 	}
 
-	printk(KERN_INFO "OMAP%04x", omap_revision >> 16);
+	pr_info("OMAP%04x", omap_revision >> 16);
 	if ((omap_revision >> 8) & 0xff)
-		printk(KERN_INFO "%x", (omap_revision >> 8) & 0xff);
-	printk(KERN_INFO " revision %i handled as %02xxx id: %08x%08x\n",
+		pr_cont("%x", (omap_revision >> 8) & 0xff);
+	pr_cont(" revision %i handled as %02xxx id: %08x%08x\n",
 	       die_rev, omap_revision & 0xff, system_serial_low,
 	       system_serial_high);
 }
diff --git a/arch/arm/mach-omap2/id.c b/arch/arm/mach-omap2/id.c
index 68ba5f472f6ba..859c71c4e9324 100644
--- a/arch/arm/mach-omap2/id.c
+++ b/arch/arm/mach-omap2/id.c
@@ -199,8 +199,8 @@ void __init omap2xxx_check_revision(void)
 
 	pr_info("%s", soc_name);
 	if ((omap_rev() >> 8) & 0x0f)
-		pr_info("%s", soc_rev);
-	pr_info("\n");
+		pr_cont("%s", soc_rev);
+	pr_cont("\n");
 }
 
 #define OMAP3_SHOW_FEATURE(feat)		\
-- 
2.20.1



